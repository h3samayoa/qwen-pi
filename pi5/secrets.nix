{ config, pkgs, lib, ... }:

{
  age.identityPaths = [
    "/etc/nixos/secrets/age_rpi5.txt"
  ];

  age.secrets.hostapd_pass = {
    file = ../secrets/hostapd_pass.txt.age;
    owner = config.services.hostapd.user;
    group = config.services.hostapd.group;
    mode = "0400";
  };
}
