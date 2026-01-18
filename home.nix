{ config, pkgs, lib, ... }:

let
  # Unstable nixpkgs pinned to specific commit for reproducibility
  # Updated by: nix-update-unstable
  unstableTarball = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/61db79b0c6b838d9894923920b612048e1201926.tar.gz";
    sha256 = "1zihs797ra009jl5knx7p4qk38wa1rmarfy286y8ywjv5wbx35l7"; # unstable
  };
  unstable = import unstableTarball {};
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "austinkeller";
  home.homeDirectory = "/Users/austinkeller";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    bun
    calc
    unstable.claude-code
    codex
    coreutils-full
    diff-so-fancy
    direnv
    fd
    ffmpeg
    fzf
    gemini-cli
    git
    git-filter-repo
    git-lfs
    gnupg
    jq
    nix-direnv
    nixpkgs-fmt
    nmap
    neovim
    perl
    poetry
    pyenv
    qemu
    ripgrep
    shellcheck
    socat
    tfswitch
    tmux
    tree
    uv
    vim
    wakeonlan
    wget
    yt-dlp
  ]
  # macOS-specific packages
  ++ lib.optionals stdenv.isDarwin [
    pinentry_mac
  ]
  # Linux-specific packages
  ++ lib.optionals stdenv.isLinux [
    pinentry-gtk2  # or pinentry-gnome3, pinentry-curses, etc.
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/austinkeller/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
