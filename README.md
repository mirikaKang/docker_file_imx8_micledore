# docker_file_imx8_micledore

# how to Start Build Server
MACHINE=imx8mp-var-dart DISTRO=fsl-imx-xwayland . var-setup-release.sh build_xwayland

# how to build 
bitbake fsl-image-gui