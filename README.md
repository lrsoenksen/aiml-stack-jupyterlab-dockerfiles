# AIML Docker Container 
## with Ubuntu:22.04 Jammy and GPU enabled Tensorflow, Keras, PyTorch, Jupyter Lab
### Author: Luis Soenksen

Dockerfile with rolling-release based on official LambdaStack docker support, designed for use with nvidia-container-toolkit. Check [LambdaStack Docker's installation instructions](https://github.com/lambdal/lambda-stack-dockerfiles) and [LambdaStack Docker GPU tutorial](https://lambdalabs.com/blog/set-up-a-tensorflow-gpu-docker-container-using-lambda-stack-dockerfile) for more information. This is all optimized to work on the LambdaLabs Tensorbook, which comes with a recovery [ISO Recovery image based on Ubuntu 22.04 LTS jammy](https://files.lambdalabs.com/recovery/tensorbook-jammy-20230704.iso), which means using also Ubuntu 22.04 LTS jammy for  docker containers may prevent local and global dependency issues later. If installing from iso, the image already comes with lambda'stack and can skip step A.

### Installing foundational stuff for Lambdabook (lambda-stack & nvidia-container-toolkit)
A) Install Lambda Stack from Lambdalabs.com (always updated AI software stack)
```
wget -nv -O- https://lambdalabs.com/install-lambda-stack.sh | I_AGREE_TO_THE_CUDNN_LICENSE=1 sh -
sudo reboot
```
B) Ensure Lmbda Stack software is up-to-date with the following simple command (make sure to be present in case the system asks for licence agreement):
```
sudo apt-get update && sudo apt-get dist-upgrade
```
C) After you've installed Lambda Stack, install GPU accelerated Docker with this command:
```
sudo apt-get install docker.io nvidia-container-toolkit
sudo systemctl daemon-reload
sudo systemctl restart docker
```
D) Add your user to the docker group by running:
```
sudo adduser "$(id -un)" docker
```
Note:
Ensure that you have a docker version > 19.03. On Ubuntu, you can simply run `sudo apt-get install docker.io`. On a different OS, or if you prefer to use upstream docker, follow [Docker's installation instructions](https://docs.docker.com/engine/install/ubuntu/). If using Lambda Stack on your host machine, install nvidia-container-toolkit with `sudo apt-get install nvidia-container-toolkit`. Otherwise, follow [NVIDIA's installation instructions](https://github.com/NVIDIA/nvidia-docker)


### Download Dockerfile from repo
```
git clone https://github.com/lrsoenksen/aiml-stack-jupyterlab-dockerfiles.git
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
sudo docker run -it --user $(id -u):$(id -g) --volume $(pwd):$(pwd) --workdir $(pwd) --rm --init --shm-size=32g --gpus all -e GRANT_SUDO=yes -e HOME=$(pwd)/.home -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -p 6006:6006 lrsoenksen/aiml-stack:latest-gpu-jupyter /usr/bin/python3 -c 'import tensorflow as tf; print(tf.config.list_physical_devices())'
```
```
sudo docker run -it --user $(id -u):$(id -g) --volume $(pwd):$(pwd) --workdir $(pwd) --rm --init --shm-size=32g --gpus all -e GRANT_SUDO=yes -e HOME=$(pwd)/.home -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -p 6006:6006 lrsoenksen/aiml-stack:latest-gpu-jupyter /usr/bin/python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print("I love Lambda Stack with GPUs: ", end=""); print(torch.cuda.device_count())'
```
Enter bash of the image with GPU using the following commands and then load, where "home/aiml" can be change for whatever is your desired root folder.
```
sudo docker run -it --user $(id -u):$(id -g) --volume $(pwd):$(pwd) --workdir $(pwd) --rm --init --shm-size=32g --gpus all -e GRANT_SUDO=yes -e HOME=$(pwd)/.home -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -p 6006:6006 lrsoenksen/aiml-stack:latest-gpu-jupyter bash 
```
And these commands can be used to test functionality
```
python3 -c 'import tensorflow as tf; print(tf.config.list_physical_devices())'
python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print("I love Lambda Stack with GPUs: ", end=""); print(torch.cuda.device_count())'
python3 -c 'import tensorflow as tf; print(tf.__version__)'
python3 -c 'import keras; print(keras.__version__)'
python3 -c 'import cv2; print(cv2.__version__)'
python3 -c 'import torch; print(torch.__version__)'
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --core-mode
```
or

### Automatically Run Jupyter Lab image
```
sudo docker run -it --user $(id -u):$(id -g) --volume $(pwd):$(pwd) --workdir $(pwd) --rm --init --shm-size=32g --gpus all -e GRANT_SUDO=yes -e HOME=$(pwd)/.home -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -p 6006:6006 lrsoenksen/aiml-stack:latest-gpu-jupyter bash -c "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --core-mode --log-level='CRITICAL'"
```
where the -p 6006 is the default port of TensorBoard. This will allocate a port for you to run one TensorBoard instance. If not needed, port 6006 that can be removed.

### Accessing JupyterLab
Click on the provided URL, or at your browser just enter http://localhost:8888 and provide the token defined by you.
If Jupyter Lab is not working try reinstalling from bash:
```
pip install jupyter -U && pip install jupyterlab
```

### Test AIML packages inside dockerized JupyterLab
To test the upyter lab in docker one can execute the following code
```
import tensorflow as tf; print(tf.config.list_physical_devices())
import torch; print(torch.rand(5, 5).cuda()); print("I love Lambda Stack with GPUs: ", end=""); print(torch.cuda.device_count())
import tensorflow as tf; print(tf.__version__)
import keras; print(keras.__version__)
import cv2; print(cv2.__version__)
import torch; print(torch.__version__)
```

-------------------------------------------------------------------------------------------------------------------------------------

### Reset everything (OPTIONAL - DON'T DO CARELESSLY)
The following is a radical solution. But if needed one can DELETES ALL YOUR DOCKER STUFF. INCLUDING VOLUMES like this:
```
docker container prune -f
docker image prune -f
docker volume prune -f
docker system prune -f
docker builder prune -f

docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker image rm -f $(docker image ls -a -q) 
```
This removes images and containers

```
sudo su
service docker stop
cd /var/lib/docker
rm -rf buildkit  containers  engine-id  image  network  overlay2  plugins  runtimes  swarm  tmp  volumes
service docker start
```
This resets all things Docker

```
sudo reboot
```
Reboot computer



-------------------------------------------------------------------------------------------------------------------------------------

### Useful Lambdastack recovery code (OPTIONAL - DON'T DO CARELESSLY)

Removing and reinstalling Lambda Stack
To remove and reinstall Lambda Stack, first uninstall (purge) the existing Lambda Stack by running:
```
sudo rm -f /etc/apt/sources.list.d/{graphics,nvidia,cuda}* && \
dpkg -l | \
awk '/cuda|lib(accinj64|cu(blas|dart|dnn|fft|inj|pti|rand|solver|sparse)|magma|nccl|npp|nv[^p])|nv(idia|ml)|tensor(flow|board)|torch/ { print $2 }' | \
sudo xargs -or apt -y remove --purge
```
Then, re-install the latest Lambda Stack by running:
```
wget -nv -O- https://lambdalabs.com/install-lambda-stack.sh | I_AGREE_TO_THE_CUDNN_LICENSE=1 sh -
```

-------------------------------------------------------------------------------------------------------------------------------------

### Useful pieces of code (OPTIONAL - DON'T DO CARELESSLY)

Give root permissions to aiml - The following is a command to give full root permissions to user (aiml). [WARNING DON'T EXECUTE CARELESSLY] like this:
```
sudo usermod -aG sudo $(whoami)
sudo visudo
```
At the bottom of the file that opens (really at the end, after all text), add this line for every user you want to give passwordless sudo permissions to aiml:
```
aiml  ALL=(ALL) NOPASSWD:ALL
```

MAC .dot files (hidden) removal - The following is a command to recursively delete only hidden files and hidden folders in current directory [WARNING DON'T EXECUTE CARELESSLY] like this:
```
cd myfolder
dot_clean -mv "/target_folder"
```
This removes the lock symbol in files because they are now also owned by user

Remove hidden files - The following is a command to recursively delete only hidden files and hidden folders in current directory [WARNING DON'T EXECUTE CARELESSLY] like this:
```
cd myfolder
find -name '.*' ! -name '.' ! -name '..' -delete
```
This removes the lock symbol in files because they are now also owned by user

To give read, write and execute permissions for a file or folder to all who wants to access it you can use the following command in terminal:
```
sudo chmod a+rwx '/path/file_or_dir'
```
Note: a=All (u=User, g=Group) and rwx is Read, Write and eXecute. + means add permission, - means remove permission.

At times jupyter and python in docker will complain that .local/bin folder is innaccessible due to permissions in path, to add such folder to path execute the following command in terminal:
```
# First go to edit the .bashrc file with Vim 
vim .bashrc

# Add this test to the very end of the file to permanently add that folder to PATH
export PATH=$HOME/.home/.local/bin:$PATH

# Press Escape and then write :wq to write and save in Vim.

```


