# Add to /etc/nixos/configuration.nix (or a module it imports).
# `pkgs` must be in the module arguments: { config, pkgs, ... }:
{
  boot.plymouth = {
    enable = true;
    theme = "ayaka";                      # must match the dir/.plymouth name
    themePackages = [
      (pkgs.callPackage ./plymouth/default.nix { })
      # Smoother-but-bigger variant:
      # (pkgs.callPackage ./plymouth/default.nix { filter = "Lanczos"; })
    ];
  };

  # Your existing quiet-boot settings stay as they are.
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=auto"
  ];
}
