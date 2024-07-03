# docker_file_imx8_micledore

based on ubuntu22.04

# fixed permission error
cd ~/

sudo chown -R builder:sudo Workspace/

# how to Start Build Server
MACHINE=imx8mp-var-dart DISTRO=fsl-imx-xwayland . var-setup-release.sh build_xwayland

# how to build 
bitbake fsl-image-gui