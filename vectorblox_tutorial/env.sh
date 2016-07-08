#!/bin/bash

#libero path
export LD_LIBRARY_PATH=/usr/lib/i386-linux-gnu/
LIBERO_INSTALLED_DIR=/usr/local/microsemi/Libero_v11.7; export LIBERO_INSTALLED_DIR

PATH=$LIBERO_INSTALLED_DIR/Libero/bin:$PATH;

PATH=$LIBERO_INSTALLED_DIR/Synplify/bin:$PATH;

PATH=$LIBERO_INSTALLED_DIR/Model/modeltech/linuxacoem:$PATH; export PATH

LM_LICENSE_FILE=1702@localhost; export LM_LICENSE_FILE
SNPSLMD_LICENSE_FILE=1702@localhost; export SNPSLMD_LICENSE_FILE

/home/$USER/lmgrd/Linux_Licensing_Daemon/lmgrd -c /home/$USER/lmgrd/License.dat -l /home/$USER/lmgrd/license.log

#FPExpress
PATH=$HOME/FPExpress/release/stg/bin:$PATH

#risc-v
PATH=/opt/riscv/nfs/opt/riscv/bin:$PATH
