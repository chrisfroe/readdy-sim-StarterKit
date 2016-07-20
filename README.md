### ReaDDy_java starter-kit
Welcome!
Glad you intend to use ReaDDy_java for your particle-based reaction-diffusion simulations.
This is a quick starting package that sets you up right away.

Run a simulation right away:

* Download or clone this repo to desired destination and run the configuration script

    `$ ./configure.sh`

* go into simulation folder

    `$ cd sim`

* run the simulation

    `$ ./run.sh`

* Look at the simulation (assuming you have VMD installed: http://www.ks.uiuc.edu/Research/vmd/ ) 

    `$ vmd -e output/out_traj.xml.VMD.tcl`

* Change the simulation parameters. You will find all simulation parameters in `sim/input`.
* To start a completely new simulation named `foo` you just need to have the `run.sh` script and the `input/` directory
  in the same place. Create a new directory `foo` and copy the run script and input files over. Note that `foo` can be located anywhere
  as long as the environment variable `J_READDY_KIT` points to the binaries (this is done in `configure.sh`).
```
└── foo/
    ├── input/
    │   ├── in_copyNumbers.csv
    │   ├── param_global.xml
    │   ├── param_groups.xml
    │   ├── param_particles.xml
    │   ├── param_reactions.xml
    │   └── tplgy_potentials.xml
    └── run.sh
```
#### Further notes
* The _bin_VMD-Visualizer automatically creates a vmd readable xyz trajectory from the readdy xml output and provides a VMD .tcl script to view it right away
* If you are on a mac: open the .tcl script differently: Open VMD, click on 'File' in the upper left corner of the screen, click 'source' in the dropdown menu, and choose the StarterKitPath/sim/output/out_traj.xml.VMD.tcl to view it.