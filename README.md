# instantbox-images

Containers for [instantbox](https://github.com/pythoninthegrass/instantbox) with [ttyd](https://github.com/tsl0922/ttyd) enabled.

Supported distributions: Ubuntu LTS, AlmaLinux, Debian, Fedora, Arch Linux, and Alpine Linux.

## Usage

```bash
docker run --rm -it -p 1588:1588 <image_name>
```

## Building Images

This project uses Docker Buildx Bake for efficient multi-platform builds:

```bash
# Build all images locally (loads to local Docker daemon)
./build.sh

# Build and push all images (multi-platform)
./build.sh --push

# Build specific distributions
./build.sh ubuntu alma

# Build specific versions
./build.sh ubuntu-22-04 fedora-41

# Use custom registry
./build.sh --registry myregistry.com/instantbox --push
```

**Note**: Local builds automatically use your current platform architecture and load images into your local Docker daemon. Push builds create multi-platform images (linux/amd64, linux/arm64).

## Supported Images

| Distribution   | Versions                                | Registry                        | Platforms                 |
|----------------|-----------------------------------------|---------------------------------|---------------------------|
| **Ubuntu**     | 20.04 LTS, 22.04 LTS, 24.04 LTS, latest | `ghcr.io/instantbox/ubuntu`     | linux/amd64, linux/arm64  |
| **AlmaLinux**  | 9, 10, latest                           | `ghcr.io/instantbox/alma`       | linux/amd64, linux/arm64  |
| **Debian**     | 11, 12, latest                          | `ghcr.io/instantbox/debian`     | linux/amd64, linux/arm64  |
| **Fedora**     | 41, 42, latest                          | `ghcr.io/instantbox/fedora`     | linux/amd64, linux/arm64  |
| **Arch Linux** | latest                                  | `ghcr.io/instantbox/arch`       | linux/amd64, linux/arm64  |
| **Alpine**     | latest                                  | `ghcr.io/instantbox/alpine`     | linux/amd64, linux/arm64  |

### Example Usage

```bash
# Ubuntu 22.04 LTS
docker run --rm -it -p 1588:1588 ghcr.io/instantbox/ubuntu:22.04

# AlmaLinux 9
docker run --rm -it -p 1588:1588 ghcr.io/instantbox/alma:9

# Debian 12
docker run --rm -it -p 1588:1588 ghcr.io/instantbox/debian:12

# Alpine Linux
docker run --rm -it -p 1588:1588 ghcr.io/instantbox/alpine:latest
```
