{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, alsa-lib
, openssl
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "youtui";
  version = "0.0.35"; # Check github for the latest tag

  src = fetchFromGitHub {
    owner = "nick42d";
    repo = "youtui";
    rev = "youtui/v${version}";
    # Step 1: Set this to a fake hash, run rebuild, copy error hash, replace here.
    hash = "sha256-eYRMlIABpHfMgLq+PRZ7zh0JGbJoPHVmMmwwYccVFP4=";
  };

  # Step 2: Once 'hash' is fixed, rebuild again. Copy error hash, replace here.
  cargoHash = "sha256-fO/YPvhEbd8CwzY9pUUqSIjEvhklrBAMENUbFktchrI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    openssl
    python3
  ];

  # Tests sometimes require network or audio devices not available in build sandbox
  doCheck = false;

  meta = with lib; {
    description = "A TUI for YouTube Music";
    homepage = "https://github.com/nick42d/youtui";
    license = licenses.mit;
    maintainers = [];
  };
}
