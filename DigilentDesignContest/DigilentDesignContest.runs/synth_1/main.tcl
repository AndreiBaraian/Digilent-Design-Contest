# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/FPGA/DigilentDesignContest/DigilentDesignContest.cache/wt [current_project]
set_property parent.project_path E:/FPGA/DigilentDesignContest/DigilentDesignContest.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
set_property ip_output_repo e:/FPGA/DigilentDesignContest/DigilentDesignContest.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/clk_4KHz.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/trigger_generator.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/echo_period.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/clk_100KHz.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/servo_door5.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/servo_door4.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/servo_door3.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/servo_door2.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/servo_door1.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/ultrasonic.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/weight_hx711.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/servo_control.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/mono_pulse_generator.vhd
  E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/sources_1/new/main.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/constrs_1/new/constraints_zybo.xdc
set_property used_in_implementation false [get_files E:/FPGA/DigilentDesignContest/DigilentDesignContest.srcs/constrs_1/new/constraints_zybo.xdc]


synth_design -top main -part xc7z010clg400-1


write_checkpoint -force -noxdef main.dcp

catch { report_utilization -file main_utilization_synth.rpt -pb main_utilization_synth.pb }
