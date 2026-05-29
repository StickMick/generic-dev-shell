{
  description = "General development tools";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-beta.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-beta,
    nixpkgs-stable,
    nixpkgs-unstable,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgsUnstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

        pkgsBeta = import nixpkgs-beta {
          inherit system;
          config.allowUnfree = true;
        };

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pkgsStable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };


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

        dotnet-full =
          with pkgs.dotnetCorePackages;
            combinePackages [
              sdk_8_0
              sdk_10_0
            ];

        commonPackages = with pkgs; [
          # Interactive bash (with programmable completion support)
          bashInteractive

          # Shell
          zsh
          oh-my-zsh
          zsh-autosuggestions
          zsh-syntax-highlighting

          pkgsUnstable.neovim
          tree-sitter

          # Terminal multiplexer (pinned to nixos-24.11, zellij 0.41.1)
          pkgsBeta.zellij

          # Version control
          git
          lazygit
          git-credential-manager # cross-platform credential helper (GCM)
          git-credential-oauth

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

          # C Sharp
          omnisharp-roslyn
          roslyn-ls
          netcoredbg
          csharpier

          # Angular
          nodejs_22
          nodePackages.npm
          nodePackages."@angular/cli"
          angular-language-server

          # Utilities
          jq
          yq-go
          curl
          wget
          htop
          unzip
          direnv # per-directory env variables
        ] ++ [ dotnet-full ];

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
        devShells.default = mkDevShell {
          name = "devtools";
        };
      }
    );
}
