# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "pl_PL.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.domin = {
    isNormalUser = true;
    description = "Domin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
git 
wget
librewolf
kitty
foot
nautilus
dconf-editor
glib
pavucontrol
wl-clipboard
libnotify
mako
networkmanagerapplet
fastfetch
btop
grim
slurp
mpv
gnumake
cmake
ninja
waybar
swww
rofi
steam
discord
nerd-fonts.symbols-only
pkgs.apple-cursor
pkgs.numix-cursor-theme
vista-fonts
cava
bibata-cursors
adwaita-qt
adwaita-qt6
libsForQt5.qt5ct
kdePackages.qt6ct
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

#USTAWIENIA NIX
nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #NVIDIA
hardware.graphics.enable = true;

services.xserver.videoDrivers = ["nvidia"];

hardware.nvidia = {
	modesetting.enable  = true;
	powerManagement.enable = false;
	open = false;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
};

xdg.portal = {
	enable = true;
	extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
};

#Audio
services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
};

#SDDM
services.displayManager.sddm.enable = true;
services.displayManager.sddm.wayland.enable = true;

#Hyprland
programs.hyprland.enable = true;
environment.sessionVariables.NIXOS_OZONE_WL = "1";

#Bluetooth
services.blueman.enable = true;
hardware.bluetooth.enable = true;

#Alias
programs.bash.shellAliases = {
	conf = "sudo nano /etc/nixos/configuration.nix";
	reconf = "sudo nixos-rebuild switch";
	nix-clean = "sudo nix-collect-garbage -d";
};

#Zram
zramSwap = {
	enable = true;
	algorithm = "zstd";
	memoryPercent = 25;
	priority = 100;
};

#Czcionki
fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	vista-fonts
	font-awesome
];

#Pozostale services
services.fstrim.enable = true;
#Dyski
  
  fileSystems."/mnt/HDD1" = {
    device = "/dev/disk/by-uuid/e1f991e9-e75d-45da-9419-154402f7a396";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };

  fileSystems."/mnt/HDD2" = {
    device = "/dev/disk/by-uuid/f1a89909-99e5-4d35-ab12-9e45f2dcf034";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };

  fileSystems."/mnt/SSD" = {
    device = "/dev/disk/by-uuid/b857fd97-9e9b-4b3d-942c-86f6f62013d9";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };

  fileSystems."/mnt/HDD3" = {
    device = "/dev/disk/by-uuid/b0028442-6cba-49f8-b4da-10e17312ecd9";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };

#Darkmode
programs.dconf.enable = true;
services.dbus.enable = true;

qt = {
 enable = true;
 platformTheme = "qt5ct";
};

environment.variables = {
	ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
	GTK_THEME = "Adwaita-dark";
	QT_QPA_PLATFORMTHEME = "qt5ct";
	QT_QPA_PLATFORM = "wayland;xcb";
	ADW_DISABLE_PORTAL = "1";
};




}
