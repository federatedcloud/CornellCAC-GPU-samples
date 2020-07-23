#!/bin/bash
set -e

source /usr/bin/ofoam231
echo "WM_PROJECT DIR: $WM_PROJECT_DIR"
cd /root/OpenFOAM/OpenFOAM-2.3.1
pwd
find src applications -name "*.L" -type f | xargs sed -i -e 's=\(YY\_FLEX\_SUBMINOR\_VERSION\)=YY_FLEX_MINOR_VERSION < 6 \&\& \1= '
# building OF 2.3.1
cd $WM_PROJECT_DIR
export QT_SELECT=qt4
./Allwmake > log.make 2>&1
./Allwmake -j 4 2>&1 > log.make
echo "SUCCESS OF 2.3.1"

# check OFoam install works
ls -l /root/OpenFOAM/OpenFOAM-2.3.1
echo icoFoam -help
