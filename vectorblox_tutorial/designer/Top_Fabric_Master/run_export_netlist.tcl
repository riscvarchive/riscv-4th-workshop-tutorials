set_device -fam SmartFusion2
read_edif  \
    -file {/nfs/home/ryan/orca_new_60/sf2plus/synthesis/Top_Fabric_Master.edn}
write_vhdl -file {/nfs/home/ryan/orca_new_60/sf2plus/synthesis/Top_Fabric_Master.vhd}
