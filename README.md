# xcd
CLI tool that lets you jump into recently opened Xcode projects.

## Install
### Swift Build
Clone this repository and build from source with swift build.
```sh
swift build -c release
```
Place the resulting `xcodecd` binary on your `PATH`.

### nest
Install via the [`nest`](https://github.com/mtj928/nest)
```sh
nest install mtj0928/xcd
```

### Shell init
- Fish: append `xcodecd init fish | source` to `~/.config/fish/config.fish`, then restart the shell.
- Bash: append `source <(xcodecd init bash)` or an equivalent wrapper to `~/.bashrc`, then restart the shell.

## Usage
Run `xcd` to pick a project and change directory.
```sh
xcd
```
