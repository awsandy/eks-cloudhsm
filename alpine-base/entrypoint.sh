#!/bin/sh
###
#The values for the SSM parameters have been removed for security 
###

# Install cloudhsm client and JCE Provider downloaded in the base image, this is done here as a volume needs to first be attached.

echo "install"
#bsdtar -xvf hsmc.rpm




tail -f /dev/null