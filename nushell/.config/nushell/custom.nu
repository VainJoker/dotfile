$env.RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env.RUSTUP_DIST_SERVER = "https://mirrors.ustc.edu.cn/rust-static"
$env.PATH = ($env.PATH | split row (char esep) | append '~/.cargo/bin')
$env.PATH = ($env.PATH | split row (char esep) | append '~/.local/bin')

$env.GDK_SCALE = 2

use ~/.config/nushell/starship.nu
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/carapace.nu
source ~/.config/nushell/atuin.nu
