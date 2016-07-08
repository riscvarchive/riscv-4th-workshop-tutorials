set_device \
    -family  SmartFusion2 \
    -die     PA4M6000_N \
    -package fg484 \
    -speed   STD \
    -tempr   {COM} \
    -voltr   {COM}
set_def {VOLTAGE} {1.2}
set_def {VCCI_1.2_VOLTR} {COM}
set_def {VCCI_1.5_VOLTR} {COM}
set_def {VCCI_1.8_VOLTR} {COM}
set_def {VCCI_2.5_VOLTR} {COM}
set_def {VCCI_3.3_VOLTR} {COM}
set_def USE_TCGEN 1
set_def NETLIST_TYPE EDIF
set_name Top_Fabric_Master
set_workdir {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master}
set_log     {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master_sdc.log}
set_design_state pre_layout
