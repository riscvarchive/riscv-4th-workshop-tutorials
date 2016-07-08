set_device -fam SmartFusion2
read_edif  \
    -file {/nfs/home/ryan/orca_new_60/sf2plus/synthesis/Top_Fabric_Master.edn}
write_adl -file {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master.adl}
