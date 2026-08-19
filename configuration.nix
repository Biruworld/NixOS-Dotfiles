# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
  # this is for sddm themes
  let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";  # or any other theme
  themeConfig = {
      Font = "JetBrains Mono";
    };
};
in
{ 
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    wayland.enable = true;
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia # Required for video backgrounds/audio
    ];
  };
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Makassar";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # polkit
  security.polkit.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."asterlusnce" = {
    isNormalUser = true;
    description = "asterlusnce";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
      fastfetch
      btop
      neovim
      wget
      git
      gcc
      pciutils
      usbutils
      nvme-cli
      openssh
      vesktop
      mpv

      #hyprland
      kitty
      waybar
      rofi
      dunst
      grim
      brightnessctl
      slurp
      wl-clipboard
    ];
  };

# Hyprland Utilities LMAOO XDDD
  programs.hyprland.enable = true;

# fish shell
  programs.fish.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   sddm-astronaut
   inputs.helium.packages.${pkgs.system}.default
   pkgs.strawberry
   pkgs.obsidian
   pkgs.bluetuith
   pkgs.pavucontrol
   pkgs.hyprpaper
   pkgs.swaynotificationcenter
   pkgs.vscode
   pkgs.playerctl
   kdePackages.polkit-kde-agent-1
   pkgs.anki-bin
  ];
	
	systemd.user.services.polkit-kde-authentication-agent-1 = {
  description = "KDE PolicyKit Authentication Agent";
  wantedBy = [ "graphical-session.target" ];
  wants = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];

  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
    Restart = "on-failure";
    RestartSec = 1;
  };
};
	
  fonts.packages = with pkgs; [
  jetbrains-mono
  nerd-fonts.jetbrains-mono # If you need the Nerd Font icons
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

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
  system.stateVersion = "26.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # For offloading, `modesetting` is needed additionally,
  # otherwise the X-server will be running permanently on nvidia,
  # thus keeping the GPU always on (see `nvidia-smi`).
  services.xserver.videoDrivers = [
    "modesetting"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.nvidia.open = true;

 hardware.nvidia.prime = {
  offload = {
    enable = true;
    enableOffloadCmd = true;
  };
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
    # amdgpuBusId = "PCI:5@0:0:0"; # If you have an AMD iGPU
  };

}
