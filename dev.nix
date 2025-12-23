{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # -- Languages --
    python3
    go

    # -- IDEs --
    zed-editor
    vscodium
    jetbrains.pycharm

    # -- Productivity --
    direnv         # Auto-load envs
    lazygit        # Git UI
    bat            # Better cat
    eza            # Better ls
    jq             # JSON processor (useful for API debugging)
  ];
}
