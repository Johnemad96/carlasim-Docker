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
&& apt-get install python3-pip -y \
&& apt-get install python3.7-dev -y
# RUN python3 -m pip install --upgrade pip
RUN pip3 install virtualenv

RUN apt-get install libjpeg8-dev -y \
&& apt-get install libtiff5-dev -y \
&& apt-get install libpng-dev -y 
# && apt-get install libxerces-c-de -y

RUN apt-get install xdg-user-dirs -y \
&& apt-get install xdg-utils -y

WORKDIR /home/carla
RUN wget "https://github.com/carla-simulator/scenario_runner/archive/refs/tags/v0.9.12.tar.gz"
RUN tar -xf v0.9.12.tar.gz 
RUN rm v0.9.12.tar.gz 
WORKDIR /home/carla/scenario_runner-0.9.12

# solving import carla issue
ENV CARLA_ROOT=/home/carla
ENV SCENARIO_RUNNER_ROOT=/home/carla/scenario_runner-0.9.12
ENV PYTHONPATH "${PYTHONPATH}:/home/carla/PythonAPI/carla/dist/carla-0.9.12-py3.7-linux-x86_64.egg" 
ENV PYTHONPATH "${PYTHONPATH}:/home/carla/PythonAPI/carla"

# solution to scenario runner "no module named import"
ENV PYTHONPATH "${PYTHONPATH}:/home/carla/PythonAPI"

# solution to scenario runner UnicodeEncodeError: 'ascii' codec can't encode character '\u2713' in position 58: ordinal not in range(128)
ENV PYTHONIOENCODING=utf-8

# install virtual environment for pygame and xmlschema
RUN apt-get install python3-venv -y

WORKDIR /home/carla/PythonAPI
RUN virtualenv --python=/usr/bin/python3.7 venv

# to activate virtual environment while building docker (in dockerfile), we don't use the normal command
#RUN source venv/bin/activate
ENV VIRTUAL_ENV=/venv/bin/activate
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# RUN pip3 --version 
RUN pip3 install pygame numpy 
RUN pip3 install wheel
RUN pip3 install py_trees==0.8.3 networkx==2.2 six==1.14.0 psutil==5.7.0 shapely==1.7.0 xmlschema==1.1.3 ephem==3.7.6.0 tabulate==0.8.7 simple_watchdog_timer
RUN pip3 install matplotlib scipy

USER carla
WORKDIR /home/carla
RUN mkdir scripts

CMD /bin/bash