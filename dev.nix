{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # -- Languages --
    python3
    go

    # -- IDEs --
    
    vscodium
    jetbrains.pycharm
    zed-editor
    positron-bin
    helix
    antigravity

    # -- Productivity --
    direnv         # Auto-load envs
    lazygit        # Git UI
    bat            # Better cat
    eza            # Better ls
    jq             # JSON processor (useful for API debugging)
    devtoolbox
    file
  ];
}
