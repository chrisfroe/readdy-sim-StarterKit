#!/bin/bash

# make sure all necessities are set, namely input dir, output dir and env-var J_READDY_KIT
if [ -z ${J_READDY_KIT+x} ]; then
    echo "The environment variable J_READDY_KIT is not set."
    exit 1
fi
if [ ! -D "input" ]; then
    echo "Directory 'input/' does not exist."
    echo "Make sure that 'run.sh' and 'input/' are in the same dir."
    exit 1
fi
mkdir -p output

# set common variables
INPUTFOLDER="input/"
OUTPUTFOLDER="output/"
PARAMGLOBAL=param_global.xml
PARAMGROUPS=param_groups.xml
PARAMPARTICLES=param_particles.xml
PARAMPOTENTIALTEMPLATES=param_potentialTemplates.xml
PARAMREACTIONS=param_reactions.xml
TPLGYCOORDINATES=tplgy_coordinates.xml
TPLGYGROUPS=tplgy_groups.xml
TPLGYPOTENTIALS=tplgy_potentials.xml

# create the topology file before running the simulation
function create_topology {
    echo "create tplgy coords..."
    PROGRAMPATH="$J_READDY_KIT/_bin_Tplgy-Generator/"
    PROGRAM="$PROGRAMPATH/ReaDDy-Topology-Generator.jar"

    INPUTCOPYNUMBERS=in_copyNumbers.csv
    OUTPUTTPLGYCOORDS=tplgy_coordinates.xml
    OUTPUTTPLGYGROUPS=tplgy_groups.xml

    LOGFILENAME=log_createTplgyCoords.log
    ERRLOGFILENAME=log_createTplgyCoords.err.log

    START=`date '+%s'`
    STARTDATE=`date`

    echo $STARTDATE > $OUTPUTFOLDER/$LOGFILENAME

    java -jar $PROGRAM \
        -input_copyNumbers $INPUTFOLDER/$INPUTCOPYNUMBERS \
        -param_global $INPUTFOLDER/$PARAMGLOBAL \
        -param_particles $INPUTFOLDER/$PARAMPARTICLES \
        -param_groups $INPUTFOLDER/$PARAMGROUPS \
        -param_potentialTemplates $INPUTFOLDER/$PARAMPOTENTIALTEMPLATES \
        -tplgy_potentials $INPUTFOLDER/$TPLGYPOTENTIALS \
        -output_tplgyCoords $INPUTFOLDER/$OUTPUTTPLGYCOORDS \
        -output_tplgyGroups $INPUTFOLDER/$OUTPUTTPLGYGROUPS \
     2>&1
    # output both sterr and stout to the logfile but split the error to a separate errorLogfile

    END=`date '+%s'`
    ENDDATE=`date`
    TIMEELAPSED=`echo "$END-$START" | bc`

    echo "\n" >> $OUTPUTFOLDER/$LOGFILENAME
    echo $ENDDATE >> $OUTPUTFOLDER/$LOGFILENAME
    echo "seconds elapsed $TIMEELAPSED" >> $OUTPUTFOLDER/$LOGFILENAME

    echo "done"
    echo $OUTPUTFOLDER/$OUTPUTTPLGYCOORDS 
    LOG=$OUTPUTFOLDER/$LOGFILENAME
    echo "see the log in $LOG"
}

# perform the actual simulation
function run_simulation {
    echo "start simulation..."
    # J_READDY_KIT should be set in configuration step
    # and points to the directory where the libraries are located
    PROGRAMPATH="$J_READDY_KIT/_bin_ReaDDy/"
    PROGRAM="$PROGRAMPATH/ReaDDy.jar"

    LOGFILENAME=log_runSimulation.log
    ERRLOGFILENAME=log_runSimulation.err.log

    START=`date '+%s'`
    STARTDATE=`date`

    echo $STARTDATE > $OUTPUTFOLDER/$LOGFILENAME

    java -Xmx2048m -jar $PROGRAM \
        -param_global $INPUTFOLDER/$PARAMGLOBAL \
        -param_groups $INPUTFOLDER/$PARAMGROUPS \
        -param_particles $INPUTFOLDER/$PARAMPARTICLES \
        -param_potentialTemplates $INPUTFOLDER/$PARAMPOTENTIALTEMPLATES \
        -param_reactions $INPUTFOLDER/$PARAMREACTIONS \
        -tplgy_coordinates $INPUTFOLDER/$TPLGYCOORDINATES \
        -tplgy_groups $INPUTFOLDER/$TPLGYGROUPS \
        -tplgy_potentials $INPUTFOLDER/$TPLGYPOTENTIALS \
        -output_path $OUTPUTFOLDER \
    2>&1
    # output both sterr and stout to the logfile but split the error to a separate errorLogfile                         

    END=`date '+%s'`
    ENDDATE=`date`
    TIMEELAPSED=`echo "$END-$START" | bc`

    echo $ENDDATE >> $OUTPUTFOLDER/$LOGFILENAME
    echo "seconds elapsed $TIMEELAPSED" >> $OUTPUTFOLDER/$LOGFILENAME
    echo "done"
    LOG=$OUTPUTFOLDER/$LOGFILENAME
    echo "see the log in $LOG"
}

# postprocess output trajectory for vmd
function prepare_vmd {
    echo "prepare VMD output from traj.xml ..."

    PROGRAMPATH="$J_READDY_KIT/_bin_VMD-Visualizer/"
    PROGRAM="$PROGRAMPATH/ReaDDy-VMD-Visualizer.jar"

    OUTFILE=out_traj.xml
    PARAM_PARTICLES_FILE=param_particles.xml

    # Parameters of the invisibility-cloak-particle, behind which we are hiding dummy particles,
    # that have to be in there because of VMD's way of parsing xyz files (every frame has
    # to have the same number of lines).
    # The parameters are the cartesian coords of the cloak particle
    INVISIBILITY_CLOAK_PARTICLE_PARAMETERS=0,0,0
    java -Xmx2048m -jar $PROGRAM $OUTPUTFOLDER/$OUTFILE $INPUTFOLDER/$PARAM_PARTICLES_FILE $INVISIBILITY_CLOAK_PARTICLE_PARAMETERS
    echo "done"
}

# ------ MAIN ------- 
# Create topology (optional step).
# Just comment out and write your own tplgy_groups.xml and tplgy_coordinates.xml if wanted.
# In this case in_copyNumbers.csv will be ignored.
create_topology

# Run simulation
run_simulation

# Prepare vmd. Process output trajectories to be displayable in xyz format.
# look at the results, when not on a mac: vmd -e output/out_traj.xml.VMD.tcl
prepare_vmd
