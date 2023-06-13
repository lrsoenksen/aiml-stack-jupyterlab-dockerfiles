# AIML Docker  Ubuntu:20.04 Focal Container with GPU enabled Tensorflow, Keras, PyTorch and Jupyter Lab
# Author: Luis Soenksen
FROM jupyter/tensorflow-notebook
FROM tensorflow/tensorflow:latest-gpu-jupyter
WORKDIR /root/

# Prepare Container with JupyterLab and JupyterLab extensions
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip install --upgrade pip
RUN pip install jupyter -U && pip install jupyterlab 
RUN pip install \
	notebook \
	ipywidgets \
	jupyter_nbextensions_configurator \
	jupyter_server \
	jupyter_server_fileid \
	jupyter_server_ydoc \
	jupyterlab_widgets \
	ipympl \
	nbdime \
	psutil \
	kaleido \
	ipydrawio \
	jupyterlab-drawio \
	jupyterlab_execute_time \
	jupyter-dash \
	jupyterlab-plotly \
	jupyterlab-dash \
	python-lsp-server \
	jupyterlab-git \
	jupyterlab-github \
	formatter \
	jupyter_bokeh \
	Execution-Time \
	jupyterlab-topbar \
	jupyterlab-topbar-text \
	jupyterlab_latex \
	jupyterlab_tensorboard \
	jupyterlab_nvdashboard \
	jupyterlab-system-monitor \
	jupyterlab_sql \
	aquirdturtle_collapsible_headings \
	lckr-jupyterlab-variableinspector

# Install Useful AI-ML and Visualization Packages
ENV TF_CPP_MIN_LOG_LEVEL=3
RUN pip install \
	plotly \
	dash \	
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
	tensorboard \
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