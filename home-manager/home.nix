{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "asterlusnce";
  home.homeDirectory = "/home/asterlusnce";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  wayland.windowManager.hyprland = {
  enable = false; 

  #xdg.configFile."niri/config.kdl".source = ./config.kdl;
  
  # Pass your desired plugins here
  plugins = [
    # Example using standard nixpkgs plugins
    #pkgs.hyprlandPlugins.gloview
  ];
  
  settings = {
    # Your regular hyprland settings go here
   
   };
};

xdg.configFile = {
  "hypr/hyprland.lua".source = ./hypr/hyprland.lua;
  "hypr/hypr_windowrule.lua".source = ./hypr/hypr_windowrule.lua;
  "hypr/monitor.lua".source = ./hypr/monitor.lua;
  "hypr/powermonitor.lua".source = ./hypr/powermonitor.lua;
};
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
      pkgs.mpdris2-rs
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  services.hyprpaper = {
  enable = false;
  settings = {
    preload = [
      "~/wallpapers/wallpaper2.jpg"
      "~/wallpapers/wallpaper.jpg"
    ];
    wallpaper = [
      # By display
      # {
      #   monitor = "DP-2";
      #   path = "~/wallpapers/wallpaper2.jpg";
      # }
      # By default/fallback
      {
        monitor = "";
        path = "~/Wallpapers/Sakura desktop.jpg"; 
      }
    ];
  };
};

  # Hypridle
  services.hypridle.enable = false;

  xdg.configFile."hypr/hypridle.conf".text = ''
  general {
    ignore_dbus_inhibit = false
  }

  listener {
    timeout = 600
    on-timeout = hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
    on-resume = hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
  }

  listener {
    timeout = 1800
    on-timeout = systemctl suspend
  }
'';
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/asterlusnce/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
