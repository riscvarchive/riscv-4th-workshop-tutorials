# Create new project
set PROJECT_NAME JobManager

new_project -location {.} -name ${PROJECT_NAME}

# Load design data from the JDC file into the new Programming Data entry

new_prog_data -data_name {MyProgData} -import_file {Top_Fabric_Master.jdc}

# Set eNVM update for the client named "MyClient1" - this can be repeated for any number of clients.
set_envm_update -data_name {MyProgData} -client_name {IMEM}\
	-file {./software/test.hex} -overwrite {YES}

# Init master bitstream that uses Auth code protocol to program initial security, eNVM and FABRIC. Generate CoC.
# Note: that this bitstream will program all eNVM clients available in design.
#       If you need to program only specific client(s), use "-envm_clients" option
init_bitstream -data_name {MyProgData} -bitstream_name {MyBitstreamENVM}\
	 -bitstream_type {TRUSTED_FACILITY} -features {ENVM}

# Export STAPL bitstream into specified path
export_bitstream_file -data_name {MyProgData} -bitstream_name {MyBitstreamENVM} -formats {STAPL} -export_path {./MyBItstreamFileENVM}


# Done with the project
close_project -save {TRUE}
