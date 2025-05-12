{ config, pkgs, lib, ... }:

let
  apInterface = "wlan0";
  apSSID = "RPi5-LLM-AP";
  apIPAddress = "192.168.42.1";
  apSubnetPrefix = 24;
  dhcpRangeStart = "192.168.42.10";
  dhcpRangeEnd = "192.168.42.50";
  dhcpLeaseTime = "12h";
in
{
  networking.wireless.enable = true;
  networking.interfaces.${apInterface} = {
    useDHCP = false;
    ipv4.addresses = [{
      address = apIPAddress;
      prefixLength = apSubnetPrefix;
    }];
  };

  services.hostapd = {
    enable = true;
    interface = apInterface;
    hwMode = "a";
    channel = "36";  # Check 'iw list' on RPi for supported channels & restrictions.
    countryCode = countryCode;
    ssid = apSSID;
    wpaPassphraseFile = config.age.secrets.hostapd_pass.path;

    extraConfig = ''
      wpa=2
      wpa_key_mgmt=WPA-PSK
      rsn_pairwise=CCMP

      # Enable 802.11n (High Throughput)
      ieee80211n=1

      # Enable 802.11ac (Very High Throughput) - for 5GHz
      ieee80211ac=1

      ht_capab=[HT40+][SHORT-GI-20][SHORT-GI-40]

      vht_oper_chwidth=1

      vht_oper_centr_freq_seg0_idx=42

      vht_capab=[SHORT-GI-80]

      wmm_enabled=1
    '';
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = apInterface;
      bind-interfaces = true;
      dhcp-range = "${dhcpRangeStart},${dhcpRangeEnd},${dhcpLeaseTime}";
      server = "1.1.1.1";
      server = "8.8.8.8";
    };
  };

  networking.ipForwarding = lib.mkDefault true;

  networking.firewall.interfaces.${apInterface}.allowedUDPPorts = [
    53
    67
  ];

  networking.firewall.interfaces.${apInterface}.allowedTCPPorts = [ 22 ];
}
