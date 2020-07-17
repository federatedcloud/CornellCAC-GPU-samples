FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04

# Author Priyanka Dilip
# assisted by Bennett Wineholt - Cornell CAC

USER root

RUN apt-get update

# Getting OpenFOAM 2.3.1
# https://openfoamwiki.net/index.php/Installation/Linux/OpenFOAM-2.3.1/Ubuntu#Ubuntu_16.04
RUN apt-get install build-essential cmake flex bison zlib1g-dev qt4-dev-tools libqt4-dev libqtwebkit-dev gnuplot \
libreadline-dev libncurses5-dev libxt-dev libopenmpi-dev openmpi-bin libboost-system-dev libboost-thread-dev libgmp-dev \
libmpfr-dev python python-dev libcgal-dev

RUN apt-get install libglu1-mesa-dev libqt4-opengl-dev
RUN mkdir -p /opt/OpenFOAM && cd /opt/OpenFOAM
RUN wget "http://downloads.sourceforge.net/foam/OpenFOAM-2.3.1.tgz?use_mirror=mesh" -O OpenFOAM-2.3.1.tgz && \
    wget "http://downloads.sourceforge.net/foam/ThirdParty-2.3.1.tgz?use_mirror=mesh" -O ThirdParty-2.3.1.tgz && \
    tar -xzf OpenFOAM-2.3.1.tgz && \
    tar -xzf ThirdParty-2.3.1.tgz

# not doing OpenMPI symbolic links
RUN sed -i -e 's/\(cgal_version=\)CGAL-4.3/\1cgal-system/' OpenFOAM-2.3.1/etc/config/CGAL.sh
RUN source /opt/OpenFOAM/OpenFOAM-2.3.1/etc/bashrc WM_NCOMPPROCS=4 WM_MPLIB=SYSTEMOPENMPI
#RUN echo "alias of231='source /opt/OpenFOAM/OpenFOAM-2.3.1/etc/bashrc WM_NCOMPPROCS=4 WM_MPLIB=SYSTEMOPENMPI'" >> $HOME/.bashrc

# compile
# todo check vars
RUN cd $WM_THIRD_PARTY_DIR
RUN export QT_SELECT=qt4
RUN sed -i -e 's|\(^if.*CGAL_ARCH_PATH.*\)]|\1 -a "${CGAL_ARCH_PATH##*/}" != "cgal-system" ]|' Allwmake
RUN ./Allwmake -j 4 2>&1 >log.make
RUN wmSET $FOAM_SETTINGS
# not building ParaView 4.1.0
RUN cd $WM_PROJECT_DIR
RUN find src applications -name "*.L" -type f | xargs sed -i -e 's=\(YY\_FLEX\_SUBMINOR\_VERSION\)=YY_FLEX_MINOR_VERSION < 6 \&\& \1='

RUN echo icoFoam -help
