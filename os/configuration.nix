# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, meta, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = meta.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  virtualisation.docker.logDriver = "json-file";

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = /var/lib/rancher/k3s/server/token;
    extraFlags = toString ([
	    "--write-kubeconfig-mode \"0644\""
	    "--cluster-init"
	    "--disable servicelb"
      "--disable traefik"
	    "--disable local-storage"
    ] ++ (if meta.isclusterinit then [] else [
	      "--server https://homelab-0:6443"
    ]));
    clusterInit = meta.isclusterinit;
  };
    
  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${meta.hostname}";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.davinci = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$6$5Te9TQZpxSOjTyb5$D6/pfbSbleB2PzCUGZE.29ZpHSX4RY9oa33ESGFL6STmsgv8GSL2LOedWBzX1BQ38zRg/LFxNkJBSeuXOoEM11";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/U570W09a/k+lcXQbC0dfJSyS8z8JzVvGSa0qdTMU/37g3EVBSQlyPHeHnOLxxPF67vqb8zZ8OwoWIm6SEomzeHwCGKSnLhF2HEsXiKFbaUv18myJp9hHnSQ2hWWRTHu8dC04g0y5GK98LUu1j7LotGxj2KOKckV8Oz3Ag2gkfLvqG7en8GmaOzDQP/TvBuRQg51OFmzHlySBj0Mf/mITWod42uGshItxX7PaJrf5Stj4EGl7/DFMEw9VxG4HPlLZcbpjMs+Y5pFd9VAZfSm6Cs3u0+eARceNLCV+TGYUH+ri3XDxBakBkeVOgMu5QIHEYXGKBMJiMm9yJp35v3GqowAeV8mFCp8HLodd7P4midREchGiMha8ktEGRCpFDgez07fVS/c41UofUMpzbl4LJrJRusDM+Vl2IK4egD2qZKEMGR4hx3os5Jg1OTsyJLkcOpAHLZ7ne4Kc18nvEZmvw0aYxdK1qLScRNf1I4s2O/savlWadKDQWZ8dCOJ6LIN10npO67lg9A3FLGbs+IiZIxt6mdHIfe/N1+KZ1Z9UMzCaCJyMiOq19P2mbOQ/ESZOXFrdD/fpazQ77QZIdwFkGhaNN3JJWlXwG7D+mo9V0mn9V/d/lQjk4uvEgjnp0cFn2z4orj0r2PCBDsJb+AI1Uf2n/eqsa0ACsTt+vXSdjQ== davinci"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # neovim
    k3s
    cifs-utils
    nfs-utils
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "davinci" "root" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = false;
    # enable = true;
    # allowedTCPPorts = [
	  #   22
    #   53
    #   80
    #   443
    # ] ++ (if meta.isclusterinit then [
    #   6443
    # ] else []);
    # networking.firewall.allowedUDPPorts = [ ... ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}