{ config, pkgs, lib, ... }:

let
  apInterface = "wlan0";
  apSSID = "RPi5-LLM-AP";
  apIPAddress = "192.168.42.1";
  apSubnetPrefix = 24;
  dhcpRangeStart = "192.168.42.10";
  dhcpRangeEnd = "192.168.42.50";
  dhcpLeaseTime = "12h";
  countryCode = "US";
  networkName = "wlan0";
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
    radios.${apInterface} = {
      band = "5g";
      channel = 36;
      countryCode = countryCode;
      
      settings = lib.mkDefault {
        ieee80211n = 1;
        ieee80211ac = 1;
        ht_capab = "[HT40+][SHORT-GI-20][SHORT-GI-40]";
        vht_oper_chwidth = 1;
        vht_oper_centr_freq_seg0_idx = 42;
        vht_capab = "[SHORT-GI-80]";
        wmm_enabled = 1;
        wpa_key_mgmt = "WPA-PSK";
        rsn_pairwise = "CCMP";
      };

      networks.${networkName} = {
        ssid = apSSID;
        authentication = {
          mode = "wpa2-sha256";
          wpaPasswordFile = config.age.secrets.hostapd_pass.path;
        };
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = apInterface;
      bind-interfaces = true;
      dhcp-range = "${dhcpRangeStart},${dhcpRangeEnd},${dhcpLeaseTime}";
      server = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      # only use specified srvrs
      no-resolv = true;

      # debugging
      # log-queries = true;
      # log-dhcp = true; 
    };
  };

  networking.firewall.interfaces.${apInterface}.allowedUDPPorts = [
    53
    67
  ];

  #networking.firewall.interfaces.${apInterface}.allowedTCPPorts = [ 22 ];
}