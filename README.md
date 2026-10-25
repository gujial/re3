# reVC-Improved

**Languages:** [English] | [中文 (Chinese)](docs/README.zh_CN.md)

<img src="res/images/logo.svg" width="128px"></img>

## Introduction

This repository makes the following changes to the original re3 repository:

- Removed canon build
- Added nix flake build and packaging
- Fixed workflows to make them work properly

For easy installation and running on NixOS, a Nix wrapper has been written in [re3-flake](https://github.com/gujial/re3-flake).

> The wrapper can automatically configure re3, reVC, reLCS, but you still need the original game files. By default, it uses Steam's default installation path to find the original game files (except for reLCS).

Compared to other branches, the reVC branch has made more changes:

- Built-in Chinese support
- Added related tools for unpacking, translating, and packing text
- Added tool for automatically generating character tables
- Added tool for generating Chinese font texture maps based on character tables and custom fonts
- Support for rendering Emoji
- Enabled Japanese and Polish settings options, but not yet fully implemented
- Modified the poster when exiting
- Fix some bugs
   - Wrong cursor position when use functional scale multiplier in wayland
   - Can't delete save file in Linux
- Some new features
   - Save game in pause menu
   - Save game after mission complete in standalone slot
   - Press `F10` to turn on/off framerate limiter
   - Reduce the sensitivity in first person view. The multiplier can be adjusted in settings.
   - After picking up the phone. press pick-up key again to skip it
- Some improvments
   - Unified vertical and horizontal sensitivity
   - Increase follow speed of free cam

> Can't save game in mission or vehicle. Auto save will start after Tommy leave the vehicle.

> This branch modified the script of game. Can't load original save!

The following tools/code were used during game modification, thanks to:

- Chinese text is based on the Unnamed Chinese patch (WMHHZ) 1.0 official version, modified, adapted and supplemented
- Chinese text rendering code comes from [Ova1122/Revc_Chs](https://github.com/Ova1122/Revc_Chs)
- Chinese mapping table generator `dat_generator` referred to the code of Unnamed Chinese group [WMHHZ/VC.SA.Plugin](https://github.com/WMHHZ/VC.SA.Plugin/blob/master/VCGXTBuilder/VCGXT.cpp)
- GXT file packing and unpacking tools used modules from [Lzh102938/III.VC.SAGXTExtracter](https://github.com/Lzh102938/III.VC.SAGXTExtracter/blob/main/builder/VCGXT.PY)
- Used [Magic.TXD](https://www.gtagarage.com/mods/show.php?id=27862) when packing Chinese character png files into txd files
- Used pillow and pilmoji modules to render Chinese character png files
- Used wqy-zenhei and tegaki_zatsu_normal as Chinese fonts. May be changed later.

Subsequent modifications will continue to focus on the miami branch.

## Installation

### For non-NixOS systems

Prepare the original game files, then find the required version archive in Actions, and copy all files to the original game folder.

### For NixOS and other systems using Nix package manager

Refer to [re3-flake](https://github.com/gujial/re3-flake) for installation, binaries have been uploaded to Nix Cache.

## Mods

Current compatibility is the same as the original reVC, may consider extending the script system in the future.

## Building from Source

Clone this branch and initialize the upstream submodules:

```bash
git clone --recurse-submodules -b miami-improve https://github.com/gujial/re3.git
cd re3
# For an existing checkout:
git submodule update --init --recursive
```

On Nix/NixOS, run `nix develop` to get the compiler and dependencies before
using either local build method below. On other systems, install a C/C++
compiler, Make, CMake, pkg-config, OpenGL, GLFW, GLEW, OpenAL, mpg123 and
libsndfile development packages (plus X11 development dependencies on Linux).

### CMake (Linux/macOS)

```bash
cmake -S . -B build-cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DREVC_VENDORED_LIBRW=ON \
  -DREVC_AUDIO=OAL \
  -DLIBRW_PLATFORM=GL3 \
  -DLIBRW_GL3_GFXLIB=GLFW
cmake --build build-cmake --parallel 8
```

The executable is `build-cmake/src/reVC-Improved`. Set
`CMAKE_BUILD_TYPE=Release` for a release build. Keep the CMake build directory
separate from Premake's `build/`. For clangd, see [the configuration guide](docs/clangd.zh_CN.md);
`bash utils/configure-clangd.sh` configures the same backend in `build-clangd/`.

### Premake (Linux/macOS)

On Linux:

```bash
./premake5Linux --with-librw gmake2
make -C build -j8 config=debug_linux-amd64-librw_gl3_glfw-oal
# Release:
make -C build -j8 config=release_linux-amd64-librw_gl3_glfw-oal
```

The debug executable is
`bin/linux-amd64-librw_gl3_glfw-oal/Debug/reVC-Improved`;
the release executable is in the corresponding `Release/` directory.
On macOS, use `premake5` instead of `./premake5Linux` and choose the generated
platform configuration (for Intel Macs, replace `linux-amd64` with `macosx-amd64`).
The Premake project name remains `reVC`, but the executable is `reVC-Improved`.
Regenerate build files after updating this repository. When upgrading from the
old X11 input configuration, add `-B` to the first `make` command to rebuild
objects with the new compiler flags. The Git version source
is generated automatically, including during the first parallel build.
Both build methods use GLFW keyboard callbacks for X11 and Wayland.

`--with-lto` enables link-time optimization. `--no-git-hash` disables the
embedded commit identifier. `GTA_VC_RE_DIR` can select the game's output
location through Premake's post-build configuration.

### Nix package build

```bash
nix build .#reVC-Improved
# Or build the debug package:
nix build .#reVC-Improved-debug
```

The executable is `result/bin/reVC-Improved`; bundled resources are in
`result/share/reVC-Improved/`. Nix uses the upstream commits pinned in
`flake.lock`, aligned with the Git submodules. Updating dependencies is optional;
do not run `nix flake update` just to build.

### Running the game

You need the original GTA Vice City game assets. Copy the contents of this
repository's `gamefiles/` into your game directory, merging directories and
replacing the corresponding files (back up existing files first). For a Nix
package, use `result/share/reVC-Improved/` as the source of these bundled files.

Launch with the game directory as the working directory. For example, with
assets prepared in `local_gamefiles/`, choose one executable:

```bash
cd local_gamefiles
../build-cmake/src/reVC-Improved
# Or:
../bin/linux-amd64-librw_gl3_glfw-oal/Debug/reVC-Improved
# Or:
../result/bin/reVC-Improved
```

The engine does not automatically search the repository's `gamefiles/` or the
Nix package's share directory. Build settings can be customized in
[`src/core/config.h`](src/core/config.h).

## Contributing

This repository is dedicated to improving the original game experience and implementing cross-platform synchronization. It can also serve as a base version for modified games. Compared to the original re3 repository, the requirements for contributions are lower.

## License

Keeping the requirements of the original re3 repository, no license is used. The code is for educational, documentation and modification purposes only. Piracy and commercial use are not supported.

## Additional Documentation

- [Original Repository README](docs/README.origin.md)
- [Localization Workflow](docs/localization.en.md)
