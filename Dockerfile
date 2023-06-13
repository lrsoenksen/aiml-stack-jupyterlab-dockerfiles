# AIML Docker  Ubuntu:20.04 Focal Container with GPU enabled Tensorflow, Keras, PyTorch and Jupyter Lab
# Author: Luis Soenksen

FROM tensorflow/tensorflow:latest-gpu-jupyter
WORKDIR /root/

# Prepare Container with Jupyter Lab
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip install --upgrade pip
RUN pip install jupyter -U && pip install jupyterlab
RUN pip install \
	jupyter_nbextensions_configurator \
	jupyter_server \
	jupyter_server_fileid \
	jupyter_server_ydoc

# Install Useful AI-ML and Visualization Packages
ENV TF_CPP_MIN_LOG_LEVEL=3
RUN pip install \
	plotly \
	dask \
	tqdm \
	shap \
	seaborn \
	scikit-learn \
	scikit-image \
	matplotlib \
	opencv-python-headless \
	nlp \
	nltk \
	tensorflow-hub \
	tensorflow_datasets \
	wandb \
	lime \
	theano \
	torch \
	torchaudio \
	torchvision \
	autokeras \
	lazypredict \
	transformers