new_project \
         -name {Top_Fabric_Master} \
         -location {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S060} \
         -name {M2S060}
enable_device \
         -name {M2S060} \
         -enable {TRUE}
save_project
close_project
