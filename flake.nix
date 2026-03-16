{
  description = "General development tools";

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
  }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        neovimCfg = nvf.lib.neovimConfiguration {
          pkgs = pkgs;
          modules = [./NVF/nvf-configuration.nix];
        };

        commonShellHook = ''
                    # Generate a per-session Zsh config
                    export ZDOTDIR=$(mktemp -d)
                    cat > "$ZDOTDIR/.zshrc" << 'ZSHEOF'
          export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
          ZSH_THEME="ys"
          plugins=(git)
          source "$ZSH/oh-my-zsh.sh"
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          eval "$(zoxide init zsh)"
          eval "$(direnv hook zsh)"
          alias cd=z
          ZSHEOF

                    export SHELL="${pkgs.zsh}/bin/zsh"

                    if [ -z "$ZELLIJ" ]; then
                      exec zellij --config ${./zellij/config.kdl}
                    fi
                    exec "$SHELL"
        '';

        commonPackages = with pkgs; [
          # Interactive bash (with programmable completion support)
          bashInteractive

          # Shell
          zsh
          oh-my-zsh
          zsh-autosuggestions
          zsh-syntax-highlighting

          # Editor (NVF-configured Neovim)
          neovimCfg.neovim

          # Terminal multiplexer
          zellij

          # Version control
          git
          lazygit
          git-credential-manager # cross-platform credential helper (GCM)

          # Fuzzy finder
          fzf

          # Search & navigation
          ripgrep
          fd
          bat # better cat
          eza # better ls
          zoxide # smarter cd

          # Key management
          keychain # SSH/GPG agent manager
          gnupg
          openssh
          pass # password-store for credential backend

          github-copilot-cli

          # Utilities
          jq
          yq-go
          curl
          wget
          htop
          direnv # per-directory env variables
        ];
      in {
        devShells.default = pkgs.mkShell {
          name = "devtools";
          shellHook = commonShellHook;
          packages = commonPackages;
        };

        devShells.dotnet = pkgs.mkShell {
          name = "dotnet-dev";
          shellHook = commonShellHook;
          packages =
            commonPackages
            ++ (with pkgs; [
              dotnet-sdk_8
              omnisharp-roslyn
              netcoredbg
              csharpier
            ]);
        };

        devShells.angular = pkgs.mkShell {
          name = "angular-dev";
          shellHook = commonShellHook;
          packages =
            commonPackages
            ++ (with pkgs; [
              nodejs_22
              nodePackages.npm
              nodePackages."@angular/cli"
            ]);
        };
      }
    );
}
