set_device \
    -fam SmartFusion2 \
    -die PA4M6000_N \
    -pkg fg484
set_input_cfg \
	-path {/nfs/home/ryan/orca_new_60/sf2plus/component/work/my_mss_MSS/ENVM.cfg}
set_output_efc \
    -path {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master.efc}
set_proj_dir \
    -path {/nfs/home/ryan/orca_new_60/sf2plus}
gen_prg -use_init false
