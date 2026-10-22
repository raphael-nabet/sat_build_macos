# SAT BUILD MACOS

Welcome SAT BUILD MACOS, the main purpose of this repository is to create an easy
interface to build SALOME using SAT and SAT SALOME.

## How to setup the project ?

```bash
git clone https://github.com/raphael-nabet/sat_build_macos.git ~/sat_build_macOS
```

WARNING : I recommend you to create an alias to use this project
```bash
alias build="~/sat_build_salome/src/main.sh"
# You can export it to your zshrc if you want
echo 'alias build="~/sat_build_salome/src/main.sh"' >> ~/.zshrc
source ~/.zshrc
```

First you need to set up your workspace. It’s in this workspace that you are going to build SALOME
```bash
mkdir salome-workspace
cd salome-workspace
export MY_WORKSPACE=$(PWD)
```

Now clone my fork of SAT and SAT SALOME in your workspace
```bash
cd $MY_WORKSPACE
git clone https://github.com/raphael-nabet/sat.git SAT
git clone https://github.com/raphael-nabet/sat_salome.git SAT_SALOME
```

WARNING: this project is still in development; make sure you are in the right branch.
```bash
cd $MY_WORKSPACE/SAT_SALOME
git switch support-for-macos-platform
cd $MY_WORKSPACE/SAT_SALOME
git switch support-for-macos-platform
```

Setup your installation parameters. For this example we are going to build SALOME-9.16.0
```bash
build -v # create a virtual environment for Python
source $MY_WORKSPACE/.venv/bin/activate
build -w "$MY_WORKSPACE" -z "9.16.0"
```

## How to use it ?

Now your project is set up.
You can start building SALOME
```bash
build -i # Init the project
build -f -a # Start building the project
```

Now, if everything goes well you may have a SALOME build correctly.
You can test it by generating a launcher.
```bash
SAT/sat launcher SALOME-9.16.0-macOS
```

If SALOME starts successfully, congratulations you have built SALOME on macOS

## How to package it ?

You can package SALOME using the following command:
```bash
build package --dmg # To create a dmg installer
# or
build package --tar # To create a tar.gz archive
```

WARNING: the tar.gz archive works only on the build machine, the archive is not portable.

## Some Tools

```bash
build --help
OVERVIEW: Script to build SALOME on macOS

    USAGE: build <args> -- [<filenames>]

    OPTIONS:
      -t | --interactive            Enable interactive mode
      -i | --init                   Expose SAT_SALOME to SAT
      -p | --package                Build a specific package
      -s | --show-progress-bar      Show the current progress of the installation
      -n | --no-prepare             Disable prepare step
      -w | --set-workspace          Set SALOME_WORKSPACE
      -z | --set-version            Set version of SALOME
      -f | --fresh-install          Enable fresh install with prepare step
      -v | --virtual-env            Enable python virtual environement
      -a | --all                    Build all packages
      -d | --display                Show all the installation that have succeeded and failed
      -u | --update                 Update the SAT and SAT_SALOME repositories and execute the build command
      -h | --help                   Display available options

    build commands:
        package     --  Use to create an archive for SALOME  --
            -d | --dmg              To package SALOME using the dmg extension
            -t | --tar              To package SALOME using the tar.gz extension
```
