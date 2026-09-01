# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, vars, ... }:
  # this is for sddm themes
  let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";  # or any other theme

  themeConfig = {
      Font = "JetBrains Mono";
    };
};

# TLP, Power Configure
cfg = config.custom;
in
{
  imports = [
# include the results of the hardware scan.
  ./hardware-configuration.nix
  ];

config = {
  #TLP Config
    powerManagement.powertop.enable = false; # enable powertop auto tuning on startup.
    services.system76-scheduler.settings.cfsProfiles.enable = true; # Better scheduling for CPU cycles - thanks System76!!!
    services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
    services.power-profiles-daemon.enable = false; # Disable GNOMEs power management
    services.tlp = {
      enable = true; # Enable TLP (better than gnomes internal power manager)
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "balanced";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "powersave";
        CPU_MAX_PERF_ON_BAT = 30;
        CPU_MAX_PERF_ON_AC = 100;
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 81; 
        };
    };
      


  # sddm-astronaut-theme
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    wayland.enable = true;
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia # Required for video backgrounds/audio
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Use Stable or Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_7_1;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Steam 
  programs.steam = {
  enable = true;
  };


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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
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
      spotify
      codeblocks
      nautilus
      python3
      cpio
      cmake
      docker
      appimage-run
      freerdp

      #hyprland
      kitty
      #waybar
      rofi
      grim
      #brightnessctl
      slurp
      wl-clipboard
      #impala
      power-profiles-daemon
    ];
  };

nixpkgs.config.permittedInsecurePackages = [
  "electron-40.10.5"
];

# Hyprland Utilities LMAOO XDDD
  programs.hyprland.enable = true;

# iwd for Impala WIFI TUI
#networking.wireless.iwd.enable = true;

# Minecraft Java  
 programs.java = {
    enable = true;
    package = pkgs.jdk; # Or specify a version like pkgs.jdk21, pkgs.openjdkunstable, etc.
  };

# fish shell
  programs.fish.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  #services.blueman.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   sddm-astronaut
   pkgs.strawberry
   pkgs.obsidian
   pkgs.bluetuith
   pkgs.pavucontrol
   #pkgs.hyprpaper
   #pkgs.swaynotificationcenter
   pkgs.vscode
   pkgs.playerctl
   kdePackages.polkit-kde-agent-1
   pkgs.anki-bin
   pkgs.lm_sensors
   pkgs.gum
   #pkgs.wiremix
   pkgs.obs-studio
   inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default # Noctalia
   pkgs.pulseaudio
   pkgs.chromium
   pkgs.libnotify
   inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default #zen
   pkgs.libreoffice
   pkgs.winboat
     

    # NVIDIA minecraft?
    (pkgs.writeShellScriptBin "nvidia-offload-max" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export OGL_DEDICATED_HW_STATE_PER_CONTEXT=ENABLE_ROBUST_ACCESS
    export SDL_VIDEODRIVER=x11
    exec "$@"
  '')  
  ];

  # Zram configuration
  zramSwap = {
  enable = true;
  algorithm = "zstd";
  memoryPercent = 100; # 200% dari 12GB = 24GB ukuran virtual swap (uncompressed)
};
  # Docker
  virtualisation.docker.enable = true;

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

  # XDG applications
  xdg.portal = {
  enable = true;

  extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];

  config = {
    common.default = [ "gtk" ];

    KDE.default = [ "kde" "gtk" ];
    Hyprland.default = [ "hyprland" "gtk" ];
  };
};

  # No password for this certain applications.
  security.sudo.extraRules = [
  {
    users = [ "asterlusnce" ];
    commands = [
      {
        command = "/home/asterlusnce/.local/bin/powerctl";
        options = [ "NOPASSWD" ];
      }
    ];
  }
];

  # NixOS home.nix
  home-manager = {
  useGlobalPkgs = true;
  useUserPackages = true;

  users.asterlusnce = import ./home-manager/home.nix;
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
  # Before changing this value read the documentation for config.boot.kernelPackages.nvidiaPackages.beta;this option
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

  # Nvidia-Beta (Closed Source)
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

 hardware.nvidia.prime = {
  offload = {
    enable = true;
    enableOffloadCmd = true;
  };
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
    # amdgpuBusId = "PCI:5@0:0:0"; # If you have an AMD iGPU
  };
};
}
