# AIML Docker  Ubuntu:22.04 Jammy Container with GPU enabled Tensorflow, Keras, PyTorch and Jupyter Lab
# Author: Luis Soenksen
# Last Update: 22-April-2025

FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

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
	&& rm -rf /var/lib/apt/lists/*

# Install Node.js (v20.x) and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs
    
# Set up Python environment
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip3 install --upgrade pip setuptools wheel

# Install specific protobuf version compatible with TensorFlow and Unsloth
RUN pip3 install protobuf==3.20.3

# Install PyTorch with CUDA 12.1 support
RUN pip3 install torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu121

# Install TensorFlow and Keras
RUN pip3 install tensorflow==2.15.0 keras==2.15.0

# Install Unsloth
RUN pip3 install --no-deps unsloth

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
    shap
    
# OpenAI API Key for Jupyter AI Assistant (replace before build or set at runtime)
ENV JUPYTER_AI_API_KEY=open_ai_key

# Install Jupyter AI with all optional dependencies
RUN pip3 install 'jupyter-ai[all]' && \
    jupyter lab build --dev-build=False --minimize=False

# Set environment variables for NVIDIA runtime
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Set environment variables to remove unnecessary verbose and smooth unsloth
ENV TF_CPP_MIN_LOG_LEVEL=3
ENV USER=root
