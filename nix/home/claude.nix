{ lib, ... }:

let
  skills = builtins.attrNames (builtins.readDir ../../shared/claude/skills);
in
{
  home.file = lib.listToAttrs (map (skill: lib.nameValuePair ".claude/skills/${skill}" {
    source = ../../shared/claude/skills + "/${skill}";
  }) skills);
}
