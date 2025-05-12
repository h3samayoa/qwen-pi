{ config, pkgs, lib, ... }:

{
  services.tailscale = {
    enable = true;
    # Optional:
    # useRoutingFeatures = "both"; # If you want to advertise the AP subnet later
    # package = pkgs.tailscale; # Usually not needed, uses default fine
  };

  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
}
