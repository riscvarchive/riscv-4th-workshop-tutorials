create_clock -period 80.000 -name {my_mss_CCC_0_FCCC|GL0_net_inferred_clock} [get_pins {my_mss_top_0/my_mss_0/CCC_0/CCC_INST:GL0}] 
#create_clock -period 40.000 -name {my_mss_CCC_0_FCCC|GL1_net_inferred_clock} [get_pins {my_mss_top_0/my_mss_0/CCC_0/CCC_INST:GL1}] 
create_clock -period 80.000 -name {my_mss_MSS|FIC_2_APB_M_PCLK_inferred_clock} [get_pins {my_mss_top_0/my_mss_0/my_mss_MSS_0/MSS_ADLIB_INST:CLK_CONFIG_APB}] 

#set Inferred_clkgroup_0 [list my_mss_CCC_0_FCCC|GL0_net_inferred_clock]
#set Inferred_clkgroup_1 [list my_mss_CCC_0_FCCC|GL1_net_inferred_clock]
#set Inferred_clkgroup_2 [list my_mss_MSS|FIC_2_APB_M_PCLK_inferred_clock]
#set_clock_groups -asynchronous -group $Inferred_clkgroup_0
#set_clock_groups -asynchronous -group $Inferred_clkgroup_1
#set_clock_groups -asynchronous -group $Inferred_clkgroup_2
