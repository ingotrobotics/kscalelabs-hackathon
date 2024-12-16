ARG from_image=ubuntu:noble
# ubuntu:focal

FROM $from_image as builder
LABEL org.opencontainers.image.authors="proan@ingotrobotics.com"

# Install toolchain dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    make \
    git \
    ca-certificates \
    wget \
    g++ \
    && \
    rm -rf /var/lib/apt/lists/*

# Install Python and virtual environment
ENV CONDA_PATH="$HOME/miniconda3"
RUN mkdir -p "$CONDA_PATH" && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "$CONDA_PATH"/miniconda.sh && \
    chmod +x "$CONDA_PATH"/miniconda.sh


RUN ["/bin/bash", "-c", "$CONDA_PATH/miniconda.sh -b -u -p $CONDA_PATH"]
#rm ~/miniconda3/miniconda.sh
#SHELL ["/bin/bash", "-c"]

RUN git clone https://github.com/kscalelabs/sim.git
WORKDIR sim

SHELL ["/bin/bash", "-c"]
RUN source "$CONDA_PATH"/bin/activate && \
    conda create -y --name kscale-sim-library python=3.8.19 && \
    conda activate kscale-sim-library &&\ 
    make install-dev


RUN wget -q https://developer.nvidia.com/isaac-gym-preview-4 -O IsaacGym_Preview_4_Package.tar.gz && \
    tar -xvf IsaacGym_Preview_4_Package.tar.gz

#ENV ISAACGYM_PATH="/sim/isaacgym"
from builder
RUN source "$CONDA_PATH"/bin/activate && \
    conda activate kscale-sim-library && \
    conda env config vars set ISAACGYM_PATH=`pwd`/isaacgym && \
    conda deactivate && \
    conda activate kscale-sim-library && \
    make install-third-party-external

RUN echo "source "$CONDA_PATH"/bin/activate && \
    conda activate kscale-sim-library"  >> /root/.bashrc


#    export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"

# Build
#`DOCKER_BUILDKIT=1 docker build -t kscale-sim:latest -f kscale-sim.dockerfile .`

# Run
#`docker run -it --rm --runtime=nvidia --gpus all -v /tmp/.X11-unix:/tmp/.X11-unix -v ${HOME}/.Xauthority:/root/.Xauthority -e DISPLAY=$DISPLAY kscale-sim:latest`
