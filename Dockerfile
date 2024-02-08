# AIML Docker  Ubuntu:22.04 Jammy Container with GPU enabled Tensorflow, Keras, PyTorch and Jupyter Lab
# Author: Luis Soenksen

FROM ubuntu:22.04
WORKDIR /root/

# Install baseline utility tools
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y\
	sudo \
	wget \
	git-core \
	apt-utils \
	build-essential \
	curl \
	yarn \
	npm &&\
	rm -rf /var/lib/apt/lists/*

# Add libcuda dummy dependency
ADD control .
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install --yes equivs && \
	equivs-build control && \
	dpkg -i libcuda1-dummy_11.8_all.deb && \
	rm control libcuda1-dummy_11.8* && \
	apt-get remove --yes --purge --autoremove equivs && \
	rm -rf /var/lib/apt/lists/*

# Setup Lambda repository
ADD lambda.gpg .
RUN apt-get update && \
	apt-get install --yes gnupg && \
	gpg --dearmor -o /etc/apt/trusted.gpg.d/lambda.gpg < lambda.gpg && \
	rm lambda.gpg && \
	echo "deb http://archive.lambdalabs.com/ubuntu jammy main" > /etc/apt/sources.list.d/lambda.list && \
	echo "Package: *" > /etc/apt/preferences.d/lambda && \
	echo "Pin: origin archive.lambdalabs.com" >> /etc/apt/preferences.d/lambda && \
	echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/lambda && \
	echo "cudnn cudnn/license_preseed select ACCEPT" | debconf-set-selections && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
		apt-get install \
		--yes \
		--no-install-recommends \
		--option "Acquire::http::No-Cache=true" \
		--option "Acquire::http::Pipeline-Depth=0" \
		lambda-stack-cuda \
		lambda-server && \
	rm -rf /var/lib/apt/lists/*

# Setup for nvidia-docker
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.8"

# Prepare Container with JupyterLab and JupyterLab extensions
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip install --upgrade jupyterlab
RUN pip install ipywidgets

# Install Useful AI-ML and Visualization Packages
ENV TF_CPP_MIN_LOG_LEVEL=3
RUN apt-get update && apt-get install -y python3-opencv
RUN pip install \
	tqdm \
	dash \
	dask \
	tensorflow \
	tensorboard \
	tensorflow-hub \
	tensorflow_datasets \
	theano \
	torch \
	torchaudio \
	torchvision \
	autokeras \
	lazypredict \
	transformers \
	scipy \
	scikit-learn \
	scikit-image \
	matplotlib \
	plotly \
	seaborn \
	shap \
	lime \
	nlp \
	nltk \
	wandb

# Add more PIP installs here --^
