function git-safe
  if not git diff --quiet --exit-code || not git diff --staged --quiet
    git $argv
  else
    echo "No changes detected — nothing to do."
  end
end
