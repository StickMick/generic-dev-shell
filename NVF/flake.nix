{
  description = "NVF-based Neovim configuration (portable flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    flake-utils,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
  in
    flake-utils.lib.eachSystem systems (
      system: let
        # Import pkgs for the target system
        pkgs = import nixpkgs {inherit system;};

        neovimCfg = nvf.lib.neovimConfiguration {
          pkgs = pkgs;
          modules = [./nvf-configuration.nix];
        };
      in {
        # Expose the configured Neovim as the package for this system
        packages.default = neovimCfg.neovim;
        defaultPackage = neovimCfg.neovim;

        # Minimal dev shell with common developer tools useful for Neovim
        devShells = {
          default = pkgs.mkShell {
            name = "nvf-neovim-shell";
            buildInputs = [
              neovimCfg.neovim # the NVF-built Neovim
              pkgs.git
              pkgs.ripgrep
              pkgs.fd
              pkgs.nodejs
              pkgs.python3
              pkgs.python3Packages.pynvim
              pkgs."pkg-config"
              pkgs.gnumake
              pkgs.gcc
            ];
          };
        };
      }
    );
}
