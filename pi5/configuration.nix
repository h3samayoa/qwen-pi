# nixos-modules/common.nix
{ config, pkgs, lib, ... }:

let
  username = "vain";
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0CtnqTxdtavGbrqipZ6SPsXQlKVkXcQCNSs3yrOWIm h3samayoa@gmail.com";
in
{
  networking.hostName = lib.mkDefault "rpi5-llm";
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "C.UTF-8/UTF-8" ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    openssh.authorizedKeys.keys = [ sshPublicKey ];
  };
  security.sudo.wheelNeedsPassword = false;

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  environment.systemPackages = with pkgs; [
    git
    htop
    vim
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    # memoryPercent = 50; run `zramctl` to test for how good compressed memory is and modify
  };

  documentation.enable = false;

  # hard link identical files 
  nix.settings.auto-optimise-store = true;
}
