# reLCS

**Languages:** [English] | [中文 (Chinese)](docs/README.zh_CN.md)

## Intro

The aim of this project is to reverse GTA Liberty City Stories.

## How can I try it?

- reLCS requires game assets to work.
- Build reLCS or download it from one of the above links (Debug or Release).
- (Optional) If you want to use optional features, copy the files in /gamefiles folder to your game root folder.
- Move reLCS.exe to GTA LCS directory and run it.

## Building from Source

You may want to point GTA_LCS_RE_DIR environment variable to GTA LCS root folder if you want executable to be moved there via post-build script.

Clone the repository with `git clone --recursive -b lcs https://github.com/GTAmodding/re3.git reLCS`. Then `cd reLCS` into the cloned repository.

<details><summary>Linux</summary>

1. Ensure you have the required dependencies installed
2. Run premake to generate build files:
   ```bash
   ./premake5Linux --with-librw gmake2
   ```
3. Build the project (choose one):
   ```bash
   cd build
   make -j5 config=debug_linux-amd64-librw_gl3_glfw-oal     # Debug build
   make -j5 config=release_linux-amd64-librw_gl3_glfw-oal   # Release build
   ```

For detailed setup instructions, see: [Building on Linux](https://github.com/GTAmodding/re3/wiki/Building-on-Linux)

</details>

<details><summary>macOS</summary>

1. Ensure you have the required dependencies installed
2. Run premake to generate build files:
   ```bash
   premake5 --with-librw gmake2
   ```
3. Build the project (choose one):
   ```bash
   cd build
   make -j5 config=debug_macosx-amd64-librw_gl3_glfw-oal     # Debug build
   make -j5 config=release_macosx-amd64-librw_gl3_glfw-oal   # Release build
   ```

For detailed setup instructions, see: [Building on macOS](https://github.com/GTAmodding/re3/wiki/Building-on-MacOS)

</details>

<details><summary>Windows</summary>

Assuming you have Visual Studio 2015/2017/2019:
- Clone the repo using the argument `--recursive`.
- Run one of the `premake-vsXXXX.cmd` variants on root folder.
- Open build/reLCS.sln with Visual Studio and compile the solution.

Microsoft recently discontinued its downloads of the DX9 SDK. You can download an archived version here: https://archive.org/details/dxsdk_jun10

**If you choose OpenAL on Windows** You must read [Running OpenAL build on Windows](https://github.com/GTAmodding/re3/wiki/Running-OpenAL-build-on-Windows).

**If you use 64-bit D3D9**: We don't ship 64-bit Dx9 SDK. You need to download it from Microsoft if you don't have it (although it should come pre-installed after some Windows version)

</details>

<details><summary>Nix/NixOS</summary>

reLCS provides a `flake.nix` for building with Nix. You have two options:

**Option 1: Build in a development shell:**
```bash
nix flake update  # Update flake inputs if needed
nix develop       # Enter development shell with all dependencies
# Then run the build commands as described in Linux section above
```

**Option 2: Build directly with Nix flakes:**
```bash
nix build .#re3-lcs       # Build GTA Liberty City Stories (lcs branch)
```

The built binaries will be in `./result/bin/`

</details>

### Quick Build Reference

**Linux Debug:**
```bash
./premake5Linux --with-librw gmake2 && cd build && make -j5 config=debug_linux-amd64-librw_gl3_glfw-oal verbose=1
```

**Linux Release:**
```bash
./premake5Linux --with-librw gmake2 && cd build && make -j5 config=release_linux-amd64-librw_gl3_glfw-oal verbose=1
```

**macOS Debug:**
```bash
premake5 --with-librw gmake2 && cd build && make -j5 config=debug_macosx-amd64-librw_gl3_glfw-oal verbose=1
```

**macOS Release:**
```bash
premake5 --with-librw gmake2 && cd build && make -j5 config=release_macosx-amd64-librw_gl3_glfw-oal verbose=1
```

### Build Options

> :information_source: There are various settings at the very bottom of [config.h](https://github.com/GTAmodding/re3/tree/lcs/src/core/config.h), you may want to take a look there. i.e. FIX_BUGS define fixes the bugs we've come across.

> :information_source: **Did you notice librw?** reLCS uses completely homebrew RenderWare-replacement rendering engine; [librw](https://github.com/aap/librw/). librw comes as submodule of reLCS, but you also can use LIBRW enviorenment variable to specify path to your own librw.

**If you choose OpenAL on Windows** You must read [Running OpenAL build on Windows](https://github.com/GTAmodding/re3/wiki/Running-OpenAL-build-on-Windows).

## Contributing
Please read the [Coding Style](https://github.com/GTAmodding/re3/blob/master/CODING_STYLE.md) Document

