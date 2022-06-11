FROM carlasim/carla:0.9.12

USER root
# RUN packages='software-properties-common add-apt-repository ppa:deadsnakes/ppa python3.7 python3-pip libjpeg8-dev libtiff5-dev libpng-dev xdg-user-dirs xdg-utils'
# the following section is used to solve issue with nvidia or/and cuda while running apt-get update
RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-get update && apt-get install -y --no-install-recommends wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget 
#$packages  
# RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get install python3.7 -y \
&& apt-get install python3-pip -y
# RUN python3 -m pip install --upgrade pip
RUN pip3 install virtualenv

RUN apt-get install libjpeg8-dev -y \
&& apt-get install libtiff5-dev -y \
&& apt-get install libpng-dev -y

RUN apt-get install xdg-user-dirs -y \
&& apt-get install xdg-utils -y

RUN apt-get install python3-venv -y

WORKDIR /home/carla/PythonAPI
RUN virtualenv --python=/usr/bin/python3.7 venv

# solving import carla issue
ENV PYTHONPATH "${PYTHONPATH}:/home/carla/PythonAPI/carla/dist/carla-0.9.12-py3.7-linux-x86_64.egg" 

# to activate virtual environment while building docker (in dockerfile), we don't use the normal command
#RUN source venv/bin/activate
ENV VIRTUAL_ENV=/venv/bin/activate
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip3 --version #it should display (python 3.7)
RUN pip3 install pygame numpy
# RUN deactivate
USER carla
WORKDIR /home/carla

CMD /bin/bash