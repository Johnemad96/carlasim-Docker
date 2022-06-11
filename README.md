# carlasim-Docker

this Dockerfile creates a ready to go Carla Simulator Image by pulling the official (0.9.12) Dockerhub image of Carla Simulator (carlasim/carla:0.9.12)
and fixing the most missing dependencies issues (with the links to the solution of each issue I faced).
Official Carla 0.9.12 Documentation and Github
https://carla.readthedocs.io/en/0.9.12/
https://github.com/carla-simulator/carla/tree/0.9.12


# Commands Needed 
## To Build The Docker image
```sh
# go to the directory of the Dockerfile
# docker build -t <image_name> .
docker build -t carladockertest .
```
## to run carlasim
```sh
# To run the container (add sudo if needed)
$ docker run --privileged --gpus all --net=host -it -e DISPLAY=$DISPLAY --name carla_docker_full carladockertest:latest

# To run Carla 0.9.12 (Within the Container ofc)
$ ./CarlaUE4.sh

# to open another shell for the same container (to run scripts, etc...)
$ docker exec -it carla_docker_full bash
```

## Noteslinks used while solving issues/error faced
### Quick code fix (DYI)
When facing the following issue issue, in manual_control.py (found in ~/PythonAPI/examples/) or other scripts. 
Open the code with the issue by attaching vscode to the running container and edit the code.
This issue is a font list issue, not important. We can just set it to any default known fonts.
```
File "./manual_control.py", line 611, in <listcomp> 
fonts = [x for x in pygame.font.get_fonts() if font_name in x] 
TypeError: argument of type 'NoneType' is not iterable 
```
open the code file at the line (here, it is 611)
change the following code to the latter code
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
### Dockerfile image-related issues
#### To edit and install as root
https://stackoverflow.com/questions/32576928/how-to-install-new-packages-into-non-root-docker-container 
https://stackoverflow.com/questions/32486779/apt-add-repository-command-not-found-error-in-dockerfile 

#### display issues ("xdg-user-dir" and "XDG_RUNTIME_DIR")
https://github.com/carla-simulator/carla/issues/1892#issuecomment-717263547 
### Carla-related issues
#### "no import named carla":
https://stackoverflow.com/a/3402176 

#### "pygame isn't installed", needed virtual environment
https://antc2lt.medium.com/carla-on-ubuntu-20-04-with-docker-5c2ccdfe2f71 

#### Some missing dependencies are mention here
https://github.com/carla-simulator/carla/issues/3164#issuecomment-669894623
