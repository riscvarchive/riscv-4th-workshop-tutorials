# Microsemi Tcl Script
# flashpro
# Date: Thu Jul  7 12:41:08 2016
# Directory /nfs/home/joel/Documents/orca_sf2/sf2plus
# File /nfs/home/joel/Documents/orca_sf2/sf2plus/FPExpress.tcl


open_project -project {./FPExpress/Top_Fabric_Master/Top_Fabric_Master.pro} -connect_programmers 1
set_programming_action -name {M2S060} -action {PROGRAM}
run_selected_actions
