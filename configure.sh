#!/bin/bash
# Export the current directory as an environment variable to the bashrc in $HOME

# DIR is the location of this script.
# See http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
# Note that this does NOT work in other shells.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Assuming that the binaries are in DIR as well, append the env J_READDY_KIT
# to the bashrc file.
if [ -s ~/.bashrc && -z ${J_READDY_KIT+x} ]; then
    echo "# Set directory of readdy_java starter-kit binaries" >> ~/.bashrc
    echo "# To remove, simply delete the directory given below and delete these 3 lines" >> ~/.bashrc
    echo "export J_READDY_KIT=$DIR" >> ~/.bashrc
else
    echo "There is no ~/.bashrc or J_READDY_KIT is already set."
fi
