#!/usr/bin/env bash

# shellcheck disable=SC2086

set -euo pipefail

# Default values
DEFAULT_REGISTRY="ghcr.io/instantbox"
SHOULD_PUSH=false
TARGETS=""
PARALLEL_BUILDS=4

# Parse command line arguments
usage() {
	cat <<EOF
Usage: $0 [OPTIONS] [TARGETS...]

Build instantbox Docker images using docker buildx bake.

OPTIONS:
  -r, --registry REGISTRY    Container registry (default: $DEFAULT_REGISTRY)
  -p, --push                 Push images to registry
  -j, --parallel NUM         Number of parallel builds (default: $PARALLEL_BUILDS)
  -h, --help                 Show this help message

TARGETS:
  If no targets specified, builds all images.
  Available targets:
    all, default              - Build all images
    ubuntu, alma, debian,     - Build specific OS family
    fedora, arch, alpine
    ubuntu-20-04, ubuntu-22-04, ubuntu-24-04, ubuntu-latest
    alma-9, alma-10, alma-latest
    debian-11, debian-12, debian-latest
    fedora-41, fedora-42, fedora-latest
    arch-latest, alpine-latest

EXAMPLES:
  $0                         # Build all images locally
  $0 --push                  # Build and push all images
  $0 --registry myregistry.com/instantbox --push
  $0 ubuntu fedora           # Build only Ubuntu and Fedora images
  $0 ubuntu-22-04 alma-9     # Build specific versions

ENVIRONMENT VARIABLES:
  DOCKER_USER                Docker registry username (for login)
  DOCKER_PASSWORD            Docker registry password (for login)
  DOCKER_REGISTRY            Docker registry URL (for login)
  TTYD_VERSION               ttyd version to download (default: 1.7.7)
  REGISTRY                   Override default registry
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
	case $1 in
	-r | --registry)
		REGISTRY="$2"
		shift 2
		;;
	-p | --push)
		SHOULD_PUSH=true
		shift
		;;
	-j | --parallel)
		PARALLEL_BUILDS="$2"
		shift 2
		;;
	-h | --help)
		usage
		exit 0
		;;
	-*)
		echo "Unknown option $1"
		usage
		exit 1
		;;
	*)
		TARGETS="$TARGETS $1"
		shift
		;;
	esac
done

# Set registry from environment or default
REGISTRY="${REGISTRY:-${DEFAULT_REGISTRY}}"

# If no targets specified, build all
if [[ -z "$TARGETS" ]]; then
	TARGETS="default"
fi

# Detect system architecture and map to ttyd binary naming
ARCH=$(uname -m)
case $ARCH in
x86_64)
	TTYD_ARCH="x86_64"
	LOCAL_PLATFORM="linux/amd64"
	;;
aarch64 | arm64)
	TTYD_ARCH="aarch64"
	LOCAL_PLATFORM="linux/arm64"
	;;
armv7l)
	TTYD_ARCH="armhf"
	LOCAL_PLATFORM="linux/arm/v7"
	;;
i686 | i386)
	TTYD_ARCH="i686"
	LOCAL_PLATFORM="linux/386"
	;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

TTYD_BINARY="ttyd.${TTYD_ARCH}"
echo "Downloading ttyd for architecture: $ARCH (${TTYD_BINARY})"
rm "./${TTYD_BINARY}" >/dev/null 2>&1 || true
wget -q "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION:-1.7.7}/${TTYD_BINARY}"

if [[ ! -f "./${TTYD_BINARY}" ]]; then
	echo "Failed to download ttyd for architecture: $ARCH"
	exit 1
fi

# Copy to generic name for Docker builds
cp "./${TTYD_BINARY}" "./ttyd_linux.x86_64"
echo "ttyd binary ready: ttyd_linux.x86_64"

# Login to registry if credentials are provided
if [[ "$SHOULD_PUSH" == "true" ]]; then
	if [[ -n "${DOCKER_USER:-}" && -n "${DOCKER_PASSWORD:-}" ]]; then
		echo "Logging into Docker registry: ${DOCKER_REGISTRY:-$REGISTRY}"
		echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin "${DOCKER_REGISTRY:-$REGISTRY}"
	else
		echo "Warning: DOCKER_USER and DOCKER_PASSWORD not set, push may fail"
	fi
fi

# Prepare build arguments
BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
VCS_REF=$(git rev-parse --short HEAD)

# Set buildx builder with multiplatform support
if ! docker buildx ls | grep -q "instantbox-builder"; then
	echo "Creating buildx builder 'instantbox-builder'"
	docker buildx create --name instantbox-builder --driver docker-container --bootstrap
fi
docker buildx use instantbox-builder

echo ""
echo "##########################################################################"
echo "##  Building images with docker buildx bake"
echo "##  Registry: $REGISTRY"
echo "##  Push: $SHOULD_PUSH"
echo "##  Targets: $TARGETS"
echo "##  Build date: $BUILD_DATE"
echo "##  VCS ref: $VCS_REF"
echo "##########################################################################"
echo ""

# Build with docker buildx bake
export REGISTRY
export BUILD_DATE
export VCS_REF
export TTYD_VERSION
export LOCAL_PLATFORM

# Construct bake command
bake_args=(
	"--file" "docker-bake.hcl"
	"--set" "*.args.BUILD_DATE=${BUILD_DATE}"
	"--set" "*.args.VCS_REF=${VCS_REF}"
)

if [[ "$SHOULD_PUSH" == "true" ]]; then
	bake_args+=("--push")
else
	# Default to loading images locally for single-platform builds
	# Override platforms to current architecture only
	bake_args+=("--load")
	bake_args+=("--set" "*.platform=${LOCAL_PLATFORM}")
fi

# Add parallel builds if specified
if [[ "$PARALLEL_BUILDS" -gt 1 ]]; then
	bake_args+=("--builder" "instantbox-builder")
fi

# Execute bake command
# shellcheck disable=SC2086
docker buildx bake "${bake_args[@]}" $TARGETS

echo ""
echo "##########################################################################"
echo "##  Build completed successfully!"
echo "##########################################################################"

# Clean up builder if we created it
if docker buildx ls | grep -q "instantbox-builder"; then
	echo "Cleaning up buildx builder"
	docker buildx rm instantbox-builder
fi
