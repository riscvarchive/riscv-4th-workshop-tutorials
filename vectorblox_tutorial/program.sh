#!/bin/sh
if [ $# -eq 1 ]
then
	 ENVM=FABRIC
else
	 ENVM=ENVM
fi


if [ $ENVM = "ENVM" ]
then
	 echo
	 echo =========== UPDATING ENVM ===========
	 echo
	 jobmgr SCRIPT:update_envm.tcl
else
	 echo
	 echo =========== UPDATING FABRIC AND ENVM ===========
	 echo
	 jobmgr SCRIPT:update_fabric_envm.tcl
fi

cp MyBItstreamFileENVM.stp FPExpress/Top_Fabric_Master/projectData/M2S060_1.stp
cp MyBItstreamFileENVM.stp FPExpress/Top_Fabric_Master/M2S060_1.stp

FPExpress SCRIPT:FPExpress.tcl

rm JobManager/ -rf
