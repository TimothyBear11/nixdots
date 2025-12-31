function fupdate-safe
  if not nix flake update
    echo "❌ Flake update failed — stopping here."
    return 1
  end
end
