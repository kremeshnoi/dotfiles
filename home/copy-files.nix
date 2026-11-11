{ config, lib, pkgs, ... }:

let
  deploy = pkgs.writeShellScript "copy-home-files" ''
    ${config.lib.bash.initHomeManagerLib}
    set -eo pipefail
    export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.findutils pkgs.diffutils ]}:$PATH

    mode="$1"
    newFiles="$(readlink -e "$2/home-files")"
    oldFiles=""
    if [[ -n "''${3:-}" && -e "$3/home-files" ]]; then
      oldFiles="$(readlink -e "$3/home-files")"
    fi
    manifest="''${XDG_STATE_HOME:-$HOME/.local/state}/home-manager/copied-files"

    leaves() {
      find "$1" \( -type f -o -type l \) -printf '%P\n' | sort
    }

    declare -A wanted owned
    mapfile -t newPaths < <(leaves "$newFiles")
    for p in "''${newPaths[@]}"; do wanted["$p"]=1; done
    if [[ -f "$manifest" ]]; then
      while IFS= read -r p; do [[ -n "$p" ]] && owned["$p"]=1; done < "$manifest"
    fi

    same() {
      [[ ! -L "$2" ]] || return 1
      diff -rq "$1" "$2" >/dev/null 2>&1 || return 1
      [[ -d "$1" ]] && return 0
      local a=0 b=0
      [[ -x "$1" ]] && a=1
      [[ -x "$2" ]] && b=1
      [[ $a == "$b" ]]
    }

    if [[ "$mode" == check ]]; then
      errors=()
      for p in "''${newPaths[@]}"; do
        target="$HOME/$p"
        [[ -e "$target" || -L "$target" ]] || continue
        [[ -n "''${owned[$p]:-}" || -L "$target" ]] && continue
        same "$newFiles/$p" "$target" && continue
        if [[ -z "''${HOME_MANAGER_BACKUP_EXT:-}" ]]; then
          errors+=("Existing file '$target' would be clobbered")
        elif [[ -e "$target.$HOME_MANAGER_BACKUP_EXT" ]]; then
          errors+=("Existing file '$target.$HOME_MANAGER_BACKUP_EXT' would be clobbered by backing up '$target'")
        else
          warnEcho "Existing file '$target' will be moved to '$target.$HOME_MANAGER_BACKUP_EXT'"
        fi
      done
      if (( ''${#errors[@]} )); then
        for e in "''${errors[@]}"; do errorEcho "$e"; done
        exit 1
      fi
      exit 0
    fi

    declare -A stale
    for p in "''${!owned[@]}"; do stale["$p"]=1; done
    if [[ -n "$oldFiles" ]]; then
      while IFS= read -r p; do
        [[ -L "$HOME/$p" ]] && stale["$p"]=1
      done < <(leaves "$oldFiles")
    fi

    for p in "''${!stale[@]}"; do
      [[ -n "''${wanted[$p]:-}" ]] && continue
      target="$HOME/$p"
      [[ -e "$target" || -L "$target" ]] || continue
      run rm -rf $VERBOSE_ARG "$target"
      dir="$(dirname "$p")"
      if [[ "$dir" != . ]]; then
        (cd "$HOME" && run rmdir -p --ignore-fail-on-non-empty "$dir" 2>/dev/null) || true
      fi
    done

    for p in "''${newPaths[@]}"; do
      source="$newFiles/$p"
      target="$HOME/$p"
      same "$source" "$target" && continue
      if [[ -e "$target" && ! -L "$target" && -z "''${owned[$p]:-}" ]]; then
        run mv $VERBOSE_ARG "$target" "$target.$HOME_MANAGER_BACKUP_EXT"
      fi
      dir="$(dirname "$target")"
      tmp="$dir/.hm-copy.$$.$(basename "$target")"
      run mkdir -p "$dir"
      run cp -RL "$source" "$tmp"
      run chmod -R u+w "$tmp"
      run rm -rf "$target"
      run mv -T "$tmp" "$target"
    done

    if [[ ! -v DRY_RUN ]]; then
      mkdir -p "$(dirname "$manifest")"
      printf '%s\n' "''${newPaths[@]}" > "$manifest"
    fi
  '';
in
{
  home.activation.checkLinkTargets = lib.mkForce (
    lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      bash ${deploy} check "$newGenPath" "''${oldGenPath:-}"
    ''
  );

  home.activation.linkGeneration = lib.mkForce (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      _i "Copying home files into %s" "$HOME"
      bash ${deploy} apply "$newGenPath" "''${oldGenPath:-}"
    ''
  );
}
