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
    "git-delta": "delta",
    "phpantom-lsp": "phpantom",
    "zsh-syntax-highlighting": "programs.zsh.syntaxHighlighting",
    "glzr-io/tap/glazewm": "cask:glazewm",
    "swiftbar": "cask:swiftbar",
    "ghostty": "cask:ghostty",
    "font-jetbrains-mono-nerd-font": "cask:font-jetbrains-mono-nerd-font",
}

nix_only = {"nh", "nvd", "nix-tree", "nil"}

work_mac_only = {"cask:ghostty"}

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
    return found


def nix_casks():
    text = read("nix/darwin/configuration.nix")
    body = text[text.index("casks = ["):]
    body = body[:body.index("];")]
    return {"cask:" + name.split("/")[-1] for name in re.findall(r'"([^"]+)"', body)}


packages = "home.packages = with pkgs; ["
system = "environment.systemPackages = with pkgs; ["
home_modules = sorted(str(p.relative_to(root)) for p in (root / "nix/home").glob("*.nix"))
home = (
    nix_list("nix/home/default.nix", packages)
    | nix_list("nix/home/helix.nix", "languageServers = with pkgs; [")
    | {name for name in programs(home_modules) if name not in {"ssh", "nh", "nix-index-database"}}
)
darwin = (
    home
    | nix_list("nix/home/darwin/default.nix", packages)
    | nix_list("nix/darwin/configuration.nix", system)
    | nix_casks()
)

brewfile = read("mac/Brewfile")
brew = set()
for kind, name in re.findall(r'^(brew|cask) "([^"]+)"', brewfile, re.M):
    mapped = brew_to_nix.get(name, name)
    if kind == "cask" and not mapped.startswith("cask:"):
        mapped = "cask:" + mapped
    brew.add(mapped)
if "uv tool install --quiet sqlit-tui" in read("mac/install.sh"):
    brew.add("sqlit-tui")

darwin.discard("zsh")

problems = []


def compare(label, left, right):
    for name in sorted(left - right):
        problems.append(f"{label}: {name}")


compare("on the Mac with Nix, missing on the Mac without Nix", darwin - nix_only, brew)
compare("on the Mac without Nix, missing on the Mac with Nix", brew - work_mac_only, darwin)

if problems:
    print("package lists out of sync:")
    for line in problems:
        print("  " + line)
    sys.exit(1)
print("package lists in sync")
