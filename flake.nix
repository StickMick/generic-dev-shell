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
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        neovimCfg = nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [./NVF/nvf-configuration.nix];
        };

        customNeovim = neovimCfg.neovim;

        zshrcContent =
          builtins.replaceStrings
          ["@OH_MY_ZSH@" "@ZSH_AUTOSUGGESTIONS@" "@ZSH_SYNTAX_HIGHLIGHTING@"]
          [
            "${pkgs.oh-my-zsh}/share/oh-my-zsh"
            "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
            "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
          ]
          (builtins.readFile ./zsh/devshell.zsh);

        commonShellHook = ''
          # Generate a per-session Zsh config
          export ZDOTDIR=$(mktemp -d)
          cat > "$ZDOTDIR/.zshrc" << 'ZSHEOF'
          ${zshrcContent}
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
          customNeovim

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

        mkDevShell = {
          name,
          additionalPackages ? [],
        }:
          pkgs.mkShell {
            inherit name;
            shellHook = commonShellHook;
            buildInputs = commonPackages ++ additionalPackages;
          };
      in {
        packages.neovim = customNeovim;

        devShells.default = mkDevShell {
          name = "devtools";
        };

        devShells.dotnet = mkDevShell {
          name = "dotnet-dev";
          additionalPackages = with pkgs; [
            dotnet-sdk_8
            omnisharp-roslyn
            netcoredbg
            csharpier
          ];
        };

        devShells.angular = mkDevShell {
          name = "angular-dev";
          additionalPackages = with pkgs; [
            nodejs_22
            nodePackages.npm
            nodePackages."@angular/cli"
          ];
        };

        formatter = pkgs.alejandra;
      }
    );
}
