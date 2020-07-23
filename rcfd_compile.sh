#!/bin/bash
set -e

source /usr/bin/rcfd
echo "WM_PROJECT DIR: $WM_PROJECT_DIR"
cd /root/RapidCFD/RapidCFD-dev
pwd
./Allwmake
echo "Compiled RapidCFD"
ls -l /root/RapidCFD/RapidCFD-dev
which icoFoam
