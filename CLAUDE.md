# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains Docker images for [instantbox](https://github.com/instantbox/instantbox) - a collection of Linux distributions preconfigured with [ttyd](https://github.com/tsl0922/ttyd) for web-based terminal access.

## Architecture

- `os/` directory contains Dockerfiles organized by OS (ubuntu, alma, debian, fedora, arch, alpine)
- Each OS subdirectory has version-specific Dockerfiles (e.g., `Dockerfile-latest`, `Dockerfile-22.04`)
- Ubuntu only includes supported LTS versions (20.04, 22.04, 24.04) plus latest
- Fedora only includes current versions (41, 42) plus latest due to shorter release cycle
- AlmaLinux replaces CentOS with current versions (9, 10) plus latest
- Debian only includes current stable versions (11, 12) plus latest
- `manifest.json` defines the available images with labels and Docker image names
- `build.sh` automates building and pushing all images defined in the manifest
- `icon/` contains PNG logos for each supported OS

## Build System

The build process uses Docker Buildx Bake for efficient multi-platform builds:

### Build Script (`build.sh`)
1. Downloads appropriate ttyd binary for host architecture
2. Sets up Docker buildx builder for multi-platform support
3. Uses `docker-bake.hcl` configuration for coordinated builds
4. Supports parallel building and selective targeting

### Build Commands

Build all images locally (single-platform, loads to Docker daemon):
```bash
./build.sh
```

Build and push all images (multi-platform):
```bash
./build.sh --push
```

Build specific OS families:
```bash
./build.sh ubuntu fedora
```

Build specific versions:
```bash
./build.sh ubuntu-22-04 alma-9
```

Use custom registry:
```bash
./build.sh --registry myregistry.com/instantbox --push
```

**Build Modes:**
- **Local builds** (default): Single-platform for current architecture, images loaded to local Docker daemon
- **Push builds** (`--push`): Multi-platform (linux/amd64, linux/arm64), images pushed to registry

### Docker Bake Configuration (`docker-bake.hcl`)

Defines build targets for all images with:
- Multi-platform support (linux/amd64, linux/arm64)
- Build argument templating
- GitHub Actions cache integration
- OS-specific groupings

### Environment Variables

- `DOCKER_USER`, `DOCKER_PASSWORD`: Docker registry credentials
- `DOCKER_REGISTRY`: Target registry URL
- `TTYD_VERSION`: ttyd version to download (defaults to 1.7.7)
- `REGISTRY`: Override default registry (ghcr.io/instantbox)

## Docker Image Structure

All images follow the same pattern:
- Base OS image as foundation
- ttyd binary copied to `/usr/bin/`
- Working directory set to `/home`
- Exposes port 1588
- Default command runs ttyd with appropriate shell (bash/sh)
- Some images install additional tools (e.g., Ubuntu images include freeFile via pip)

## Testing Images

Run any image locally:
```bash
docker run --rm -it -p 1588:1588 instantbox/ubuntu:latest
```

Then access the terminal at `http://localhost:1588`