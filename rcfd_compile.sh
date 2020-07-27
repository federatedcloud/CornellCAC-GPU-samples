#!/bin/bash
set -e

source /usr/bin/rcfd
echo "WM_PROJECT DIR: $WM_PROJECT_DIR"
echo "FOAM_MPI check 1: : $FOAM_MPI"

export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# mkdir -p /root/RapidCFD/RapidCFD-dev/wmake/rules/linuxPPC64Nvcc
# mv /root/RapidCFD/RapidCFD-dev/wmake/rules/linux64Nvcc /root/RapidCFD/RapidCFD-dev/wmake/rules/linuxPPC64Nvcc

cd /root/RapidCFD/RapidCFD-dev/etc/config
cat settings.sh | sed -e 's/FOAM_MPI=openmpi-4.0.2/FOAM_MPI=openmpi-1.4.3/' > settings.sh
cat settings.csh | sed -e 's/FOAM_MPI openmpi-1.8.4/FOAM_MPI openmpi-1.4.3/' > settings.csh

cd ..
cat bashrc | sed -e '/#- Clean LD_PRELOAD/r add.txt' > bashrc

cd /root/RapidCFD/RapidCFD-dev/wmake/rules/linux64Nvcc
teslat4='sm_75'
cat c | sed -e '/arch/s/sm_30/sm_75/g' > c
# substitute "sm_30" for the Tesla T4's "sm_75" in all lines containing "arch"
cat c++ | sed -e '/arch/s/sm_30/sm_75/g' > c++
cat c
cat c++
echo "Changed to sm_75"

echo $WM_MPLIB
echo "FOAM_MPI check 2: $FOAM_MPI"

export WM_MPLIB=SYSTEMOPENMPI

cd /root/RapidCFD/RapidCFD-dev/src/Pstream
#wclean
echo "Start src/Pstream"
# ./Allwmake
echo "src/Pstream worked"

# nvidia-smi
# which cuda
# nvcc --version
echo "CUDA versioning"

echo "WMAKE_BIN: $WMAKE_BIN"
echo "Trying Applications"
cd /root/RapidCFD/RapidCFD-dev/applications
./Allwmake
echo "Ending Applications"

echo "Start RCFD"
cd /root/RapidCFD/RapidCFD-dev
./Allwmake
echo "Compiled RapidCFD"
ls -l /root/RapidCFD/RapidCFD-dev
which icoFoam
