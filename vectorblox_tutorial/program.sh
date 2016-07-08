rm JobManager/ -rf

jobmgr SCRIPT:update_envm.tcl

cp MyBItstreamFileENVM.stp FPExpress/Top_Fabric_Master/projectData/M2S010_1.stp
cp MyBItstreamFileENVM.stp FPExpress/Top_Fabric_Master/M2S010_1.stp

FPExpress SCRIPT:FPExpress.tcl
