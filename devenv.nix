{pkgs, ...}: {
  packages = with pkgs; [
    probe-rs-tools
    cargo-nextest
    cargo-expand
    cargo-criterion
  ];

  languages.rust = {
    enable = true;
    toolchainFile = ./rust-toolchain.toml;
  };

  scripts.miri = let
    # Miri is only available from nightly
    miriToolchain = pkgs.rust-bin.nightly."2026-10-08".minimal.override {
      extensions = ["miri" "rust-src"];
    };
  in {
    exec = ''PATH=${miriToolchain}/bin:$PATH cargo miri "$@"'';
    description = "Run cargo miri with the pinned nightly (e.g. `miri test`)";
  };
  git-hooks.hooks = {
    rustfmt.enable = true;
    # clippy = {
    #   enable = true;
    #   settings.denyWarnings = true;
    # };
  };
}
