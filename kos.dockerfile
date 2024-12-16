ARG from_image=ubuntu:noble

FROM $from_image
LABEL org.orpencontainers.image.authors="proan@ingotrobotics.com"

# Install toolchain dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    curl \
    gcc-multilib \
    pkg-config \
    libglib2.0-dev \
    librust-gstreamer-dev \
    protobuf-compiler \
    libprotobuf-dev \
    docker.io \
    && \
    rm -rf /var/lib/apt/lists/*

# The above dependencies are the minimum for feature kos-stub.
# For feature kos-kbot add:
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    librust-gstreamer-video-dev \
    && \
    rm -rf /var/lib/apt/lists/*

# Can install cargo from apt (cargo) or use curl
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install `cross`
SHELL ["/bin/bash", "-l", "-c"]
ENV CROSS_CONTAINER_IN_CONTAINER=true
RUN cargo install cross -f


RUN git clone https://github.com/kscalelabs/kos.git
WORKDIR kos

# Build
RUN cargo build --features kos-stub,kos-kbot


# Build container with
#`DOCKER_BUILDKIT=1 docker build -t kos:latest -f kos.dockerfile .`

# Run container with
#`docker run -it -v /var/run/docker.sock:/var/run/docker.sock kos:latest
