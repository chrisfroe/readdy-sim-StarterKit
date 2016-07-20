#!/bin/bash
# Export the current directory as an environment variable to the bashrc in $HOME

# DIR is the location of this script.
# See http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
# Note that this does NOT work in other shells.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Assuming that the binaries are in DIR as well, append the env J_READDY_KIT
# to the bashrc file.
if [ -s "$HOME/.bashrc" ] && [ -z ${J_READDY_KIT+x} ]; then
    echo "# Set directory of readdy_java starter-kit binaries" >> $HOME/.bashrc
    echo "# To remove, simply delete the directory given below and delete these 3 lines" >> $HOME/.bashrc
    echo "export J_READDY_KIT=$DIR" >> $HOME/.bashrc
    echo "environment variable J_READDY_KIT=$DIR has been appended to your bashrc."
    echo "Restart shell or do 'source ~/.bashrc' for this to take effect."
else
    echo "There is no ~/.bashrc or J_READDY_KIT is already set."
fi
