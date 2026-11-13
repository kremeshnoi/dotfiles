{ lib, pkgs, ... }:

let
  zsh = ../../shared/zsh;
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-helix-mode";
        src = "${zsh}/zsh-helix-mode";
        file = "zsh-helix-mode.plugin.zsh";
      }
    ];

    syntaxHighlighting.enable = true;

    envExtra = ''
      source ${zsh}/env.zsh
    '';

    initContent = lib.mkMerge [
      (lib.mkOrder 510 ''
        source ${zsh}/startup.zsh
      '')
      ''
        source ${zsh}/rc.zsh
      ''
      (lib.mkAfter ''
        zhm-add-update-region-highlight-hook
      '')
    ];
  };
}
