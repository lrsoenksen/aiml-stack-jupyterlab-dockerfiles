# AIML Docker Container 
## with Ubuntu:20.04 Focal and GPU enabled Tensorflow, Keras, PyTorch, Jupyter Lab
### Author: Luis Soenksen

Dockerfiles with rolling-release, designed for use with nvidia-container-toolkit

### Installing foundational stuff for Lambdabook (lambda-stack & nvidia-container-toolkit)
A) Install Lambda Stack from Lambdalabs.com (always updated AI software stack)
```
wget -nv -O- https://lambdalabs.com/install-lambda-stack.sh | sh -
sudo reboot
```
B) Ensure Lmbda Stack software is up-to-date with the following simple command:
```
sudo apt-get update && sudo apt-get dist-upgrade
```
C) After you've installed Lambda Stack, install GPU accelerated Docker with this command:
```
sudo apt-get install docker.io nvidia-container-toolkit
```

Note:
Ensure that you have a docker version > 19.03. On Ubuntu, you can simply run `sudo apt-get install docker.io`. On a different OS, or if you prefer to use upstream docker, follow [Docker's installation instructions](https://docs.docker.com/engine/install/ubuntu/). If using Lambda Stack on your host machine, install nvidia-container-toolkit with `sudo apt-get install nvidia-container-toolkit`. Otherwise, follow [NVIDIA's installation instructions](https://github.com/NVIDIA/nvidia-docker)


### Download Dockerfile from repo
```
git clone https://github.com/lrsoenksen/aiml-stack-jupyterlab-dockerfiles
cd aiml-stack-jupyterlab-dockerfiles
```
Download from https://github.com/lrsoenksen/aiml-lambda-stack-jupyterlab-dockerfiles


### Building image
Build the image with the appropriate command for the distribution you wish to use.

```
sudo docker login -u "USERNAME" -p "PASSWORD" docker.io
sudo docker build --rm -t aiml-stack:latest-gpu-jupyter -f Dockerfile .
sudo docker tag aiml-stack:latest-gpu-jupyter lrsoenksen/aiml-stack:latest-gpu-jupyter
sudo docker push lrsoenksen/aiml-stack:latest-gpu-jupyter
```
Note that building these docker images requires acceptance of the [cuDNN license agreement](https://docs.nvidia.com/deeplearning/sdk/cudnn-sla/index.html)


### Testing image

Test the image with GPU using the following commands
```
sudo docker run --gpus all --rm --interactive --tty lrsoenksen/aiml-stack:latest-gpu-jupyter /usr/bin/python3 -c 'import tensorflow as tf; print(tf.config.list_physical_devices())'
```
```
sudo docker run --gpus all --rm --interactive --tty lrsoenksen/aiml-stack:latest-gpu-jupyter /usr/bin/python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print("I love Lambda Stack with GPUs: ", end=""); print(torch.cuda.device_count())'
```
Enter bash of the image with GPU using the following commands and then load, where "home/aiml" can be change for whatever is your desired root folder.
```
sudo docker run -it --gpus all -p 8888:8888 -p 6006:6006 -v /home/aiml:/root/ -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root lrsoenksen/aiml-stack:latest-gpu-jupyter bash
```
And these commands can be used to test functionality
```
python3 -c 'import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))'
python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print("I love Lambda Stack with GPUs: ", end=""); print(torch.cuda.device_count())'
python3 -c 'import tensorflow as tf; print(tf.__version__)'
python3 -c 'from tensorflow import keras; print(keras.__version__)'
python3 -c 'import cv2; print(cv2.__version__)'
python3 -c 'import torch; print(torch.__version__)'
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --core-mode
```

### Automatically Run Jupyter Lab image
```
sudo docker run -it --gpus all -p 8888:8888 -p 6006:6006 -v /home/aiml:/root/ -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root lrsoenksen/aiml-stack:latest-gpu-jupyter bash -c "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --core-mode"
```
where the -p 6006 is the default port of TensorBoard. This will allocate a port for you to run one TensorBoard instance. If not needed, port 6006 that can be removed

### Accessing JupyterLab
Click on the provided URL, or at your browser just enter http://localhost:8888 and provide the token defined by you.
If Jupyter Lab is not working try reinstalling in bash:
```
pip install jupyter -U && pip install jupyterlab
```

-------------------------------------------------------------------------------------------------------------------------------------

### Reset everything (OPTIONAL - DON'T DO CARELESSLY)
The following is a radical solution. But if needed one can DELETES ALL YOUR DOCKER STUFF. INCLUDING VOLUMES like this:
```
docker container prune -f
docker image prune -f
docker volume prune -f
docker system prune -f

docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker image rm -f $(docker image ls -a -q) 
```
This removes images and containers

```
sudo su
service docker stop
cd /var/lib/docker
rm -rf *
service docker start
```
This resets all things Docker

```
sudo reboot
```
Reboot computer
