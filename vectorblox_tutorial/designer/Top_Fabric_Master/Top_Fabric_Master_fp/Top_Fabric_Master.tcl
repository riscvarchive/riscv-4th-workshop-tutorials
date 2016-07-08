open_project -project {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master_fp/Top_Fabric_Master.pro}
set_programming_file -name {M2S060} -file {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master.ipd}
enable_device -name {M2S060} -enable 1
set_programming_action -action {PROGRAM} -name {M2S060} 
run_selected_actions
set_programming_file -name {M2S060} -no_file
save_project
close_project
