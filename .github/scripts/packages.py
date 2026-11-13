import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parents[2]

brew_to_nix = {
    "python": "python3",
    "coreutils": "coreutils-prefixed",
    "jdtls": "jdt-language-server",
    "docker-compose-langserver": "docker-compose-language-service",
    "rust-analyzer": "rust-analyzer-unwrapped",
    "libpq": "postgresql",
    "phpantom-lsp": "phpantom",
    "zsh-syntax-highlighting": "programs.zsh.syntaxHighlighting",
    "glzr-io/tap/glazewm": "cask:glazewm",
    "swiftbar": "cask:swiftbar",
    "ghostty": "cask:ghostty",
    "font-jetbrains-mono-nerd-font": "cask:font-jetbrains-mono-nerd-font",
}

nix_only = {"nh", "nvd", "nix-tree", "nil"}

darwin_only = {"coreutils-prefixed"}

nixos_only = {
    "autoconf", "automake", "bison", "clojure", "cmake", "curl", "docker-compose",
    "dos2unix", "dotnet-sdk", "fastfetch", "file", "gcc", "gettext", "gh-dash",
    "gnumake", "hxOpenTab", "jdk17", "k9s", "leiningen", "lsof", "php", "pkg-config",
    "railway", "re2c", "rlwrap", "rsync", "sox", "sqlite", "unzip", "yt-dlp", "zip",
}


def read(path):
    return (root / path).read_text()


def nix_list(path, opener):
    text = read(path)
    start = text.index(opener) + len(opener)
    body = text[start:text.index("];", start)]
    return {word for word in re.findall(r"[A-Za-z][\w.-]*", body)}


def programs(paths):
    found = set()
    for path in paths:
        text = read(path)
        for name in re.findall(r"programs\.([a-z-]+)", text):
            found.add(name)
        if re.search(r"syntaxHighlighting\.enable\s*=\s*true", text):
            found.add("programs.zsh.syntaxHighlighting")
        found.update(re.findall(r"src = pkgs\.([\w-]+);", text))
        if re.search(r"lfs\.enable\s*=\s*true", text):
            found.add("git-lfs")
    return found


def nix_casks():
    text = read("nix/darwin/configuration.nix")
    body = text[text.index("casks = ["):]
    body = body[:body.index("];")]
    return {"cask:" + name.split("/")[-1] for name in re.findall(r'"([^"]+)"', body)}


home_modules = sorted(str(p.relative_to(root)) for p in (root / "nix/home").glob("*.nix"))
home = (
    nix_list("nix/home/default.nix", "home.packages = with pkgs; [")
    | nix_list("nix/home/helix.nix", "languageServers = with pkgs; [")
    | {name for name in programs(home_modules) if name not in {"ssh", "nh", "nix-index-database"}}
)
darwin = nix_list("nix/darwin/configuration.nix", "environment.systemPackages = with pkgs; [") | home | nix_casks()
nixos = nix_list("nix/nixos/configuration.nix", "environment.systemPackages = with pkgs; [") | home

brewfile = read("mac/Brewfile")
brew = set()
for kind, name in re.findall(r'^(brew|cask) "([^"]+)"', brewfile, re.M):
    mapped = brew_to_nix.get(name, name)
    if kind == "cask" and not mapped.startswith("cask:"):
        mapped = "cask:" + mapped
    brew.add(mapped)
if "github.com/kremeshnoi/pgf" in read("mac/install.sh"):
    brew.add("pgf")

darwin.discard("zsh")
nixos.discard("zsh")

problems = []


def compare(label, left, right):
    for name in sorted(left - right):
        problems.append(f"{label}: {name}")


compare("on the Mac with Nix, missing on the Mac without Nix", darwin - nix_only, brew)
compare("on the Mac without Nix, missing on the Mac with Nix", brew, darwin)

shared = {name for name in darwin if not name.startswith("cask:")} - darwin_only - nix_only
compare("on the Macs, missing on NixOS", shared, nixos)
compare("on NixOS only, not listed as NixOS-only", nixos - shared - nix_only - nixos_only, set())
compare("listed as NixOS-only, gone from NixOS", nixos_only, nixos)

if problems:
    print("package lists out of sync:")
    for line in problems:
        print("  " + line)
    sys.exit(1)
print("package lists in sync")
