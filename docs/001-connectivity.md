# Connectivity

If you are working on a laptop that has only wireless connectivity you will need to activate that as NixOS will need to dowload several packages to complete the installation.  You could, of course, use a USB Ethernet adapter as well, but just in case that is not an option.  Booting from the minimal ISO, once you are at a command prompt, run the following commands:

```bash
sudo systemctl start wpa_supplicant
wpa_cli
```

This will drop you into the CLI for configuring wireless.  If you do not see `0` or `OK` after executing a command, be sure you have entered everything correctly.

```bash
add_network
set_network 0 ssid "Your SSID"
set_network 0 psk "Your WiFi Password"
# set_network 0 key_managment WPA-PSK
enable_network
```

You should see some kind of confirmation that wireless is now connected.  You can type `quit` to exit the CLI.  Once back at the command prompt you can run the command `ifconfig` to make sure you have obtained an IP address.  If so, once you have an IP address you can use SSH to reach the machine.  However, you have to set a password first.  When booting from the minimal ISO the default user is `nixos`.  You can type the command `passwd`, set a password to use for SSH then go to the machine you want to connect from and run the command `ssh -l nixos [ip address]`.  Accept the fingerprint then enter the password you set.

It makes life easier being able to remotely connect to the device you want to set up as you can copy and paste, lookup information, etc. 