#-----------------------------------------------------------------------------
# This module is used to call the appropriate firewall parser based on the 
# config type. The code for each parser should be in separate ruby file within 
# lib/parse folder and should be 'required' below. An appropriate config file 
# check and a call to the associated parser should be added to the 
# parse_firewall method below. Each parser is expected to take a configuration 
# file and return a FWFWConfig::FirewallConfig object.
#-----------------------------------------------------------------------------
require 'parse/sonic'
require 'parse/cisco'
require 'parse/ec2'

##
# Input: A firewall configuration file
# 
# Output: A FWConfig::FirewallConfig object
#
# Action: Ensures the configuration file is an existing, non-empty file, 
# checks the config to determine the firewall type, and then calls the 
# appropriate parsing function.
def parse_firewall(config_file)

	
##
# Check the config file for an indication of the firewall type then call 
	# the appropriate parser.
	if config =~ /ASA Version/m
		print_status("Parsing ASA configuration file.")
		return parse_cisco_config(config)
	elsif config =~ /PIX Version/m
		print_status("Parsing PIX configuration file.")
		return parse_cisco_config(config)
	elsif config =~ /Sonic/m
		print_status("Parsing SonicWALL configuration.")
		return parse_sonic_config(config)
	elsif config =~ /GROUP\sId\sOwner\sName\sDescription\sVpcID/
		print_status("Parsing Amazon EC2 configuration.")
		return parse_ec2_config(config)
	else
		raise ParseError.new("Unknown firewall type.")
	end

end
