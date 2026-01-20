{ pkgs, inputs, ... }: {
  # 1. Use 'linuxPackagesFor' to wrap the Bore kernel from the flake
  # This automatically handles all your modules/drivers (Nvidia, etc.)
  boot.kernelPackages = pkgs.linuxPackagesFor inputs.nix-cachyos-kernel.packages.${pkgs.system}.linux-cachyos-bore;

  # 2. Binary cache settings
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
    trusted-users = [ "root" "tbear" ];
  };
}
