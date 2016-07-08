set inst ""
set cells [ list_objects [ get_cells "*" ] ]
foreach cell $cells \
{
    if { [regexp -nocase {(.*CoreResetP_0)/.*} $cell -> inst] } \
    {
        break
    }
}

if { [string length $inst] != 0 } \
{
    set false_paths \
    {
        {/ddr_settled:CLK                   /ddr_settled_q1:D}
        {/release_sdif0_core:CLK            /release_sdif0_core_q1:D}
        {/release_sdif1_core:CLK            /release_sdif1_core_q1:D}
        {/release_sdif2_core:CLK            /release_sdif2_core_q1:D}
        {/release_sdif3_core:CLK            /release_sdif3_core_q1:D}
        {/MSS_HPMS_READY_int:CLK            /sm0_areset_n_rcosc_q1:ALn}
        {/MSS_HPMS_READY_int:CLK            /sm0_areset_n_rcosc:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif0_areset_n_rcosc_q1:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif0_areset_n_rcosc:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif1_areset_n_rcosc_q1:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif1_areset_n_rcosc:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif2_areset_n_rcosc_q1:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif2_areset_n_rcosc:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif3_areset_n_rcosc_q1:ALn}
        {/MSS_HPMS_READY_int:CLK            /sdif3_areset_n_rcosc:ALn}
        {/SDIF0_PERST_N_re:CLK              /sdif0_areset_n_rcosc_q1:ALn}
        {/SDIF0_PERST_N_re:CLK              /sdif0_areset_n_rcosc:ALn}
        {/SDIF1_PERST_N_re:CLK              /sdif1_areset_n_rcosc_q1:ALn}
        {/SDIF1_PERST_N_re:CLK              /sdif1_areset_n_rcosc:ALn}
        {/SDIF2_PERST_N_re:CLK              /sdif2_areset_n_rcosc_q1:ALn}
        {/SDIF2_PERST_N_re:CLK              /sdif2_areset_n_rcosc:ALn}
        {/SDIF3_PERST_N_re:CLK              /sdif3_areset_n_rcosc_q1:ALn}
        {/SDIF3_PERST_N_re:CLK              /sdif3_areset_n_rcosc:ALn}
        {/count_sdif0_enable:CLK            /count_sdif0_enable_q1:D}
        {/count_sdif1_enable:CLK            /count_sdif1_enable_q1:D}
        {/count_sdif2_enable:CLK            /count_sdif2_enable_q1:D}
        {/count_sdif3_enable:CLK            /count_sdif3_enable_q1:D}
        {/count_ddr_enable:CLK              /count_ddr_enable_q1:D}
        {/SDIF0_CORE_RESET_N_0:CLK          /SDIF0_HR_FIX_INCLUDED.sdif0_phr/reset_n_q1:ALn}
        {/SDIF0_CORE_RESET_N_0:CLK          /SDIF0_HR_FIX_INCLUDED.sdif0_phr/reset_n_clk_ltssm:ALn}
        {/SDIF1_CORE_RESET_N_0:CLK          /SDIF1_HR_FIX_INCLUDED.sdif1_phr/reset_n_q1:ALn}
        {/SDIF1_CORE_RESET_N_0:CLK          /SDIF1_HR_FIX_INCLUDED.sdif1_phr/reset_n_clk_ltssm:ALn}
        {/SDIF2_CORE_RESET_N_0:CLK          /SDIF2_HR_FIX_INCLUDED.sdif2_phr/reset_n_q1:ALn}
        {/SDIF2_CORE_RESET_N_0:CLK          /SDIF2_HR_FIX_INCLUDED.sdif2_phr/reset_n_clk_ltssm:ALn}
        {/SDIF3_CORE_RESET_N_0:CLK          /SDIF3_HR_FIX_INCLUDED.sdif3_phr/reset_n_q1:ALn}
        {/SDIF3_CORE_RESET_N_0:CLK          /SDIF3_HR_FIX_INCLUDED.sdif3_phr/reset_n_clk_ltssm:ALn}
        {/SDIF0_HR_FIX_INCLUDED.sdif0_phr/hot_reset_n:CLK /SDIF0_HR_FIX_INCLUDED.sdif0_phr/sdif_core_reset_n_q1:ALn}
        {/SDIF0_HR_FIX_INCLUDED.sdif0_phr/hot_reset_n:CLK /SDIF0_HR_FIX_INCLUDED.sdif0_phr/sdif_core_reset_n:ALn}
        {/SDIF1_HR_FIX_INCLUDED.sdif1_phr/hot_reset_n:CLK /SDIF1_HR_FIX_INCLUDED.sdif1_phr/sdif_core_reset_n_q1:ALn}
        {/SDIF1_HR_FIX_INCLUDED.sdif1_phr/hot_reset_n:CLK /SDIF1_HR_FIX_INCLUDED.sdif1_phr/sdif_core_reset_n:ALn}
        {/SDIF2_HR_FIX_INCLUDED.sdif2_phr/hot_reset_n:CLK /SDIF2_HR_FIX_INCLUDED.sdif2_phr/sdif_core_reset_n_q1:ALn}
        {/SDIF2_HR_FIX_INCLUDED.sdif2_phr/hot_reset_n:CLK /SDIF2_HR_FIX_INCLUDED.sdif2_phr/sdif_core_reset_n:ALn}
        {/SDIF3_HR_FIX_INCLUDED.sdif3_phr/hot_reset_n:CLK /SDIF3_HR_FIX_INCLUDED.sdif3_phr/sdif_core_reset_n_q1:ALn}
        {/SDIF3_HR_FIX_INCLUDED.sdif3_phr/hot_reset_n:CLK /SDIF3_HR_FIX_INCLUDED.sdif3_phr/sdif_core_reset_n:ALn}
        {*                                  /SDIF0_HR_FIX_INCLUDED.sdif0_phr/ltssm_q1[0]:D}
        {*                                  /SDIF0_HR_FIX_INCLUDED.sdif0_phr/ltssm_q1[1]:D}
        {*                                  /SDIF0_HR_FIX_INCLUDED.sdif0_phr/ltssm_q1[2]:D}
        {*                                  /SDIF0_HR_FIX_INCLUDED.sdif0_phr/ltssm_q1[3]:D}
        {*                                  /SDIF0_HR_FIX_INCLUDED.sdif0_phr/ltssm_q1[4]:D}
        {*                                  /SDIF0_HR_FIX_INCLUDED.sdif0_phr/psel_q1:D}
        {*                                  /SDIF0_HR_FIX_INCLUDED.sdif0_phr/pwrite_q1:D}
        {*                                  /SDIF1_HR_FIX_INCLUDED.sdif1_phr/ltssm_q1[0]:D}
        {*                                  /SDIF1_HR_FIX_INCLUDED.sdif1_phr/ltssm_q1[1]:D}
        {*                                  /SDIF1_HR_FIX_INCLUDED.sdif1_phr/ltssm_q1[2]:D}
        {*                                  /SDIF1_HR_FIX_INCLUDED.sdif1_phr/ltssm_q1[3]:D}
        {*                                  /SDIF1_HR_FIX_INCLUDED.sdif1_phr/ltssm_q1[4]:D}
        {*                                  /SDIF1_HR_FIX_INCLUDED.sdif1_phr/psel_q1:D}
        {*                                  /SDIF1_HR_FIX_INCLUDED.sdif1_phr/pwrite_q1:D}
        {*                                  /SDIF2_HR_FIX_INCLUDED.sdif2_phr/ltssm_q1[0]:D}
        {*                                  /SDIF2_HR_FIX_INCLUDED.sdif2_phr/ltssm_q1[1]:D}
        {*                                  /SDIF2_HR_FIX_INCLUDED.sdif2_phr/ltssm_q1[2]:D}
        {*                                  /SDIF2_HR_FIX_INCLUDED.sdif2_phr/ltssm_q1[3]:D}
        {*                                  /SDIF2_HR_FIX_INCLUDED.sdif2_phr/ltssm_q1[4]:D}
        {*                                  /SDIF2_HR_FIX_INCLUDED.sdif2_phr/psel_q1:D}
        {*                                  /SDIF2_HR_FIX_INCLUDED.sdif2_phr/pwrite_q1:D}
        {*                                  /SDIF3_HR_FIX_INCLUDED.sdif3_phr/ltssm_q1[0]:D}
        {*                                  /SDIF3_HR_FIX_INCLUDED.sdif3_phr/ltssm_q1[1]:D}
        {*                                  /SDIF3_HR_FIX_INCLUDED.sdif3_phr/ltssm_q1[2]:D}
        {*                                  /SDIF3_HR_FIX_INCLUDED.sdif3_phr/ltssm_q1[3]:D}
        {*                                  /SDIF3_HR_FIX_INCLUDED.sdif3_phr/ltssm_q1[4]:D}
        {*                                  /SDIF3_HR_FIX_INCLUDED.sdif3_phr/psel_q1:D}
        {*                                  /SDIF3_HR_FIX_INCLUDED.sdif3_phr/pwrite_q1:D}
    }

    foreach false_path $false_paths \
    {
        set from_pin [lindex $false_path 0]
        set to_pin   [lindex $false_path 1]

        if { ${from_pin} == "*" } then \
        {
            set pins [ list_objects [ get_pins "$inst${to_pin}" ] ]
            if { [ llength $pins ] == 1 } then \
            {
                set_false_path -to [ get_pins ${pins} ]
            }
        } \
        else \
        {
            set from_pins [ list_objects [ get_pins "$inst${from_pin}" ] ]
            set to_pins   [ list_objects [ get_pins "$inst${to_pin}" ] ]
            if { ([llength $from_pins] == 1) && ([llength $to_pins] == 1)} then \
            {
                set_false_path -from [ get_pins ${from_pins} ] \
                               -to   [ get_pins ${to_pins} ]
            }
        }
    }
}

#puts [list_false_paths]


save
set has_violations {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master_pre_layout_has_violations}
set fp [open $has_violations w]
puts $fp [has_violations -short]
close $fp
report -type combinational_loops -format xml {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/Top_Fabric_Master_combinational_loops.xml}
if { [catch "file delete -force -- {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/pinslacks.txt}"] } {
   ;
}
report -type slack {/nfs/home/ryan/orca_new_60/sf2plus/designer/Top_Fabric_Master/pinslacks.txt}
