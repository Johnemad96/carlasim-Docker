# carlasim-Docker

This Dockerfile creates a ready to go Carla Simulator Image by pulling the official (0.9.12) Dockerhub image of Carla Simulator (carlasim/carla:0.9.12)
and fixing most missing dependencies issues (with the links to the solution of each issue I faced).

Official Carla 0.9.12 Documentation and Github:

https://carla.readthedocs.io/en/0.9.12/

https://github.com/carla-simulator/carla/tree/0.9.12

Docker Version: 20.10.12

# Commands Needed 
## To Build The Docker image
```sh
# go to the directory of the Dockerfile
# docker build -t <image_name> .
$ docker build -t carladockertest:latest .
```
## To run carlasim
```sh
# To run the container (add sudo if needed)
# there is an empty scripts folder if you want to mount it to a local folder by adding the following flag before --name flag
#            -v <folder/on/your/local/machine:/home/carla/scripts>
$ docker run --privileged --gpus all --net=host -it -e DISPLAY=$DISPLAY --name carla carladockertest:latest

# To run Carla 0.9.12 (Within the Container ofc)
$ ./CarlaUE4.sh

# to open another shell for the same container (to run scripts, etc...)
$ docker exec -it carla bash

```
## To test scenario runner
```sh
# in a new shell for the same container (after runnung ./CarlaUE4.sh)
$ cd scenario_runner-0.9.12/

# run scenario runner test (from the documentation)
$ python3 scenario_runner.py --scenario FollowLeadingVehicle_1 --reloadWorld

# run manual_control.py (from the same folder)
$ python3 manual_control.py
```

## Notes and links used while solving issues/errors faced
### Quick code fix (DIY)
When facing the following issue , in manual_control.py or other scripts (found in ~/PythonAPI/examples/). 
Open the code with the issue by attaching vscode to the running container and edit the code.
This issue is a font list issue, not important. We can just set it to any default known fonts.
```
File "./manual_control.py", line 611, in <listcomp> 
fonts = [x for x in pygame.font.get_fonts() if font_name in x] 
TypeError: argument of type 'NoneType' is not iterable 
```
open the code file at the line (here, it is 611).
Modify the following code to match the latter code
```python
fonts = [x for x in pygame.font.get_fonts() if font_name in x] 
default_font = 'ubuntumono' 
mono = default_font if default_font in fonts else fonts[0] 
```
```python
#fonts = [x for x in pygame.font.get_fonts() if font_name in x] 
default_font = 'ubuntumono' 
mono = default_font #if default_font in fonts else fonts[0] 
```
source: 
https://github.com/carla-simulator/carla/issues/1475#issuecomment-568145522
### Dockerfile image-related issues
#### To edit and install as root
https://stackoverflow.com/questions/32576928/how-to-install-new-packages-into-non-root-docker-container 
https://stackoverflow.com/questions/32486779/apt-add-repository-command-not-found-error-in-dockerfile 

#### Dockerfile nvidia / cuda error
When running "```$ apt-get update```" inside Dockerfile (while building), it gives a "GPG error" related to nvidia and cuda "missing key"
https://github.com/NVIDIA/nvidia-docker/issues/1631#issuecomment-1112682423

#### display issues ("xdg-user-dir" and "XDG_RUNTIME_DIR")
https://github.com/carla-simulator/carla/issues/1892#issuecomment-717263547 

#### Add python path to environment in Dockerfile
https://stackoverflow.com/questions/49631146/how-do-you-add-a-path-to-pythonpath-in-a-dockerfile 

#### Activate Virtual Environment in Dockerfile
https://pythonspeed.com/articles/activate-virtualenv-dockerfile/ 

### Carla-related issues
#### "import carla. no module named carla":
https://stackoverflow.com/a/3402176 

#### "pygame isn't installed", needed virtual environment
https://antc2lt.medium.com/carla-on-ubuntu-20-04-with-docker-5c2ccdfe2f71 

#### Some missing dependencies are mentioned here
https://github.com/carla-simulator/carla/issues/3164#issuecomment-669894623


### Scenario Runner issues
#### Unicode error
"UnicodeEncodeError: 'ascii' codec can't encode character '\u2713' in position 58: ordinal not in range(128)"

https://github.com/carla-simulator/scenario_runner/blob/master/Docs/FAQ.md

#### No module named examples.manual_control
getting the following error "Traceback (most recent call last): File "manual_control.py", line 58, in <module> from examples.manual_control import (World, HUD, KeyboardControl, CameraManager, ImportError: No module named examples.manual_control" 
When running manual_control.py, but the one inside the scenario runner folder

https://github.com/carla-simulator/scenario_runner/issues/717#issuecomment-800070859


### Other Issues
#### Matplotlib plotting windows (plot/draw/scatter) haults/blocks the rest of the code
https://stackoverflow.com/a/15720891/9593159
