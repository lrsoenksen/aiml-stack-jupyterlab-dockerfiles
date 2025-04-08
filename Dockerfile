# AIML Docker  Ubuntu:22.04 Jammy Container with GPU enabled Tensorflow, Keras, PyTorch and Jupyter Lab
# Author: Luis Soenksen
# Last Update: 07-April-2025

FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

WORKDIR /root/

# Install baseline system dependencies and utility tools
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	sudo \
	wget \
	git-core \
	apt-utils \
	build-essential \
	curl \
	git \
	python3 \
	python3-pip \
	yarn \
	npm \
	&& rm -rf /var/lib/apt/lists/*

# Set up Python environment
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip3 install --upgrade pip setuptools wheel

# Install TensorFlow (with GPU support for CUDA 11.8)
RUN pip3 install tensorflow==2.15.0

# Install PyTorch with CUDA 11.8 support
RUN pip3 install torch==2.2.0 torchvision==0.17.0 torchaudio==2.2.0 --index-url https://download.pytorch.org/whl/cu118

# Install Jupyter ecosystem and scientific/ML tools
RUN apt-get update && apt-get install -y python3-opencv
RUN pip3 install \
    jupyterlab \
    notebook \
    ipython \
    ipykernel \
    ipywidgets \
    tqdm \
    dash \
    dask \
    plotly \
    shap \
    unsloth

# Set environment variables for NVIDIA runtime
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Set environment variables to remove unnecessary verbose and smooth unsloth
ENV TF_CPP_MIN_LOG_LEVEL=3
ENV USER=root  # This is the equivalent of os.environ["USER"] = "root"
