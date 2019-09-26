import os
import sys
import setup_lib

if os.getuid():
    sys.exit("You need root access to install!")

print("##### RaspiWiFi Initial Setup #####")

entered_ssid = "OSO ARI"
wpa_enabled_choice = "n"
wpa_entered_key = ""
auto_config_choice = "n"
auto_config_delay = "60"
server_port_choice = ""
ssl_enabled_choice = "n"

setup_lib.install_prereqs()
setup_lib.copy_configs("no_wpa")
setup_lib.update_main_config_file(
    entered_ssid,
    auto_config_choice,
    auto_config_delay,
    ssl_enabled_choice,
    server_port_choice,
    wpa_enabled_choice,
    wpa_entered_key,
)
