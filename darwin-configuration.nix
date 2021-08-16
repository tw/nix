{ config, lib, pkgs, ... }:

{
  imports = [ 
    <home-manager/nix-darwin>
  ];
  nix.package = pkgs.nixUnstable;

  environment.systemPackages = with pkgs; [];
  environment.shells = with pkgs; [ zsh ];

  environment.variables.EDITOR = "nvim";

  fonts.enableFontDir = true;
  fonts.fonts = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  users.users.tw.name = "tw";
  users.users.tw.home = "/Users/tw";

  programs.zsh.enable = true;

  system.defaults = {
    dock = { # run `killall Dock`
      autohide = true;
      show-recents = false;
    };
  };

  home-manager.useUserPackages = true;
  home-manager.users.tw = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (import ./overlays/applications.nix)
    ];

    home.packages = with pkgs; [
      awscli
      jdk16 # (from overlays/applications.nix)
      jq
      kbfs # keybase // git
      kubectl
      kubernetes-helm
      nodejs
      yubikey-manager
      slack
      stern
      terraform_0_13
      terragrunt
      tmux
      vscode

      # .app (from overlays/applications.nix)
      Docker
      iTerm2
      IntelliJ
      Keybase
    ];

    programs.git = {
      enable = true;

      userName = "Tobie Warburton";
      userEmail = "tobie.warburton@gmail.com";
      aliases = {
        co = "checkout";
        br = "branch";
        st = "status";
        cm = "commit";
      };
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        solarized 
        vim-nix
      ];

      extraConfig = ''
          set background=dark
          colorscheme solarized 
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = false;
	
	line_break = {
          disabled = true;
	};

	java = {
          disabled = true;
	};
      };
    };

    programs.gh = {
      enable = true;
      gitProtocol = "ssh";
    };

    programs.zsh = {
      enable = true;

      initExtra = ''
        export ACME_HOME=~/dev/flux/acme-tooling
        export MFEXEC_MUTATE_KUBECONFIG=1
        export PATH=$PATH:~/dev/flux/acme-tooling/bin
        export PATH=$PATH:~/dev/flux/acme-tooling/opt/bin
        export PATH=$PATH:/etc/profiles/per-user/tw/bin

        . $HOME/dev/tw/secrets/env
      '';
    };
  };

  nix.nixPath = lib.mkForce [
    "darwin-config=/Users/tw/.nixpkgs/darwin-configuration.nix"
    "/nix/var/nix/profiles/per-user/tw/channels"
    "/Users/tw/.nix-defexpr/channels"
  ];

  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages
      ++ config.home-manager.users.tw.home.packages;
    pathsToLink = "/Applications";
  });

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
