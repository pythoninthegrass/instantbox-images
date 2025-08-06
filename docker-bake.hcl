# Variables with defaults that can be overridden
variable "REGISTRY" {
  default = "ghcr.io/instantbox"
}

variable "PUSH" {
  default = false
}

variable "BUILD_DATE" {
  default = ""
}

variable "VCS_REF" {
  default = ""
}

variable "TTYD_VERSION" {
  default = "1.7.7"
}

variable "LOCAL_PLATFORM" {
  default = "linux/arm64"  # Default to current platform, can be overridden
}

# Function to generate image targets dynamically
function "notequal" {
  params = [a, b]
  result = a != b
}

# Ubuntu targets
target "ubuntu-20-04" {
  context = "."
  dockerfile = "os/ubuntu/Dockerfile-20.04"
  tags = ["${REGISTRY}/ubuntu:20.04"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=ubuntu-20-04"]
  cache-to = ["type=gha,mode=max,scope=ubuntu-20-04"]
}

target "ubuntu-22-04" {
  context = "."
  dockerfile = "os/ubuntu/Dockerfile-22.04"
  tags = ["${REGISTRY}/ubuntu:22.04"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=ubuntu-22-04"]
  cache-to = ["type=gha,mode=max,scope=ubuntu-22-04"]
}

target "ubuntu-24-04" {
  context = "."
  dockerfile = "os/ubuntu/Dockerfile-24.04"
  tags = ["${REGISTRY}/ubuntu:24.04"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=ubuntu-24-04"]
  cache-to = ["type=gha,mode=max,scope=ubuntu-24-04"]
}

target "ubuntu-latest" {
  context = "."
  dockerfile = "os/ubuntu/Dockerfile-latest"
  tags = ["${REGISTRY}/ubuntu:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=ubuntu-latest"]
  cache-to = ["type=gha,mode=max,scope=ubuntu-latest"]
}

# AlmaLinux targets
target "alma-9" {
  context = "."
  dockerfile = "os/alma/Dockerfile-9"
  tags = ["${REGISTRY}/alma:9"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=alma-9"]
  cache-to = ["type=gha,mode=max,scope=alma-9"]
}

target "alma-10" {
  context = "."
  dockerfile = "os/alma/Dockerfile-10"
  tags = ["${REGISTRY}/alma:10"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=alma-10"]
  cache-to = ["type=gha,mode=max,scope=alma-10"]
}

target "alma-latest" {
  context = "."
  dockerfile = "os/alma/Dockerfile-latest"
  tags = ["${REGISTRY}/alma:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=alma-latest"]
  cache-to = ["type=gha,mode=max,scope=alma-latest"]
}

# Debian targets
target "debian-11" {
  context = "."
  dockerfile = "os/debian/Dockerfile-11"
  tags = ["${REGISTRY}/debian:11"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=debian-11"]
  cache-to = ["type=gha,mode=max,scope=debian-11"]
}

target "debian-12" {
  context = "."
  dockerfile = "os/debian/Dockerfile-12"
  tags = ["${REGISTRY}/debian:12"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=debian-12"]
  cache-to = ["type=gha,mode=max,scope=debian-12"]
}

target "debian-latest" {
  context = "."
  dockerfile = "os/debian/Dockerfile-latest"
  tags = ["${REGISTRY}/debian:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=debian-latest"]
  cache-to = ["type=gha,mode=max,scope=debian-latest"]
}

# Fedora targets
target "fedora-41" {
  context = "."
  dockerfile = "os/fedora/Dockerfile-41"
  tags = ["${REGISTRY}/fedora:41"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=fedora-41"]
  cache-to = ["type=gha,mode=max,scope=fedora-41"]
}

target "fedora-42" {
  context = "."
  dockerfile = "os/fedora/Dockerfile-42"
  tags = ["${REGISTRY}/fedora:42"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=fedora-42"]
  cache-to = ["type=gha,mode=max,scope=fedora-42"]
}

target "fedora-latest" {
  context = "."
  dockerfile = "os/fedora/Dockerfile-latest"
  tags = ["${REGISTRY}/fedora:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=fedora-latest"]
  cache-to = ["type=gha,mode=max,scope=fedora-latest"]
}

# Arch targets
target "arch-latest" {
  context = "."
  dockerfile = "os/arch/Dockerfile-latest"
  tags = ["${REGISTRY}/arch:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=arch-latest"]
  cache-to = ["type=gha,mode=max,scope=arch-latest"]
}

# Alpine targets
target "alpine-latest" {
  context = "."
  dockerfile = "os/alpine/Dockerfile-latest"
  tags = ["${REGISTRY}/alpine:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    BUILD_DATE = BUILD_DATE
    VCS_REF = VCS_REF
  }
  cache-from = ["type=gha,scope=alpine-latest"]
  cache-to = ["type=gha,mode=max,scope=alpine-latest"]
}

# Group all targets
group "default" {
  targets = [
    "ubuntu-20-04", "ubuntu-22-04", "ubuntu-24-04", "ubuntu-latest",
    "alma-9", "alma-10", "alma-latest",
    "debian-11", "debian-12", "debian-latest",
    "fedora-41", "fedora-42", "fedora-latest",
    "arch-latest", "alpine-latest"
  ]
}

# OS-specific groups
group "ubuntu" {
  targets = ["ubuntu-20-04", "ubuntu-22-04", "ubuntu-24-04", "ubuntu-latest"]
}

group "alma" {
  targets = ["alma-9", "alma-10", "alma-latest"]
}

group "debian" {
  targets = ["debian-11", "debian-12", "debian-latest"]
}

group "fedora" {
  targets = ["fedora-41", "fedora-42", "fedora-latest"]
}

group "arch" {
  targets = ["arch-latest"]
}

group "alpine" {
  targets = ["alpine-latest"]
}