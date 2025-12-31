function nrs
  set -l flake_dir "$HOME/nixdots"
  set -l host "my-nix-den"

  pushd $flake_dir > /dev/null

  git add .

  if sudo nixos-rebuild switch --flake .#$host
    if set -q argv[1]
      git commit -m "$argv"
      git push
      echo "✅ Rebuild successful and pushed."
    else
      echo "✅ Rebuild successful (no commit message)."
    end
  else
    echo "❌ Rebuild failed — changes remain staged."
    popd > /dev/null
    return 1
  end

  popd > /dev/null
end
