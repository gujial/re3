# reLCS - GTA LCS 源代码反编译项目

本项目旨在反编译 GTA Liberty City Stories。

## 如何尝试？

- reLCS 需要游戏资源才能运行。
- 构建 reLCS 或从上面的链接下载（调试或发布版本）。
- （可选）如果要使用可选功能，请将 /gamefiles 文件夹中的文件复制到游戏根文件夹。
- 将 reLCS.exe 移动到 GTA LCS 目录并运行。

## 从源代码构建  

您可能希望将 GTA_LCS_RE_DIR 环境变量指向 GTA LCS 根文件夹，如果要通过后构建脚本将可执行文件移动到那里。

使用 `git clone --recursive -b lcs https://github.com/GTAmodding/re3.git reLCS` 克隆仓库。然后 `cd reLCS` 进入克隆的仓库。

<details><summary>Linux</summary>

1. 确保已安装所需的依赖项
2. 运行 premake 以生成构建文件：
   ```bash
   ./premake5Linux --with-librw gmake2
   ```
3. 构建项目（选择其中之一）：
   ```bash
   cd build
   make -j5 config=debug_linux-amd64-librw_gl3_glfw-oal     # 调试构建
   make -j5 config=release_linux-amd64-librw_gl3_glfw-oal   # 发布构建
   ```

有关详细的设置说明，请参阅：[在 Linux 上构建](https://github.com/GTAmodding/re3/wiki/Building-on-Linux)

</details>

<details><summary>macOS</summary>

1. 确保已安装所需的依赖项
2. 运行 premake 以生成构建文件：
   ```bash
   premake5 --with-librw gmake2
   ```
3. 构建项目（选择其中之一）：
   ```bash
   cd build
   make -j5 config=debug_macosx-amd64-librw_gl3_glfw-oal     # 调试构建
   make -j5 config=release_macosx-amd64-librw_gl3_glfw-oal   # 发布构建
   ```

有关详细的设置说明，请参阅：[在 macOS 上构建](https://github.com/GTAmodding/re3/wiki/Building-on-MacOS)

</details>

<details><summary>Windows</summary>

假设您有 Visual Studio 2015/2017/2019：
- 使用参数 `--recursive` 克隆仓库。
- 在根文件夹上运行 `premake-vsXXXX.cmd` 变体之一。
- 使用 Visual Studio 打开 build/reLCS.sln 并编译解决方案。

Microsoft 最近已停止提供 DX9 SDK 下载。您可以从此处下载存档版本：https://archive.org/details/dxsdk_jun10

**如果在 Windows 上选择 OpenAL** 您必须阅读 [在 Windows 上运行 OpenAL 构建](https://github.com/GTAmodding/re3/wiki/Running-OpenAL-build-on-Windows)。

**如果您使用 64 位 D3D9**：我们不提供 64 位 Dx9 SDK。如果您没有，需要从 Microsoft 下载（尽管在某些 Windows 版本后应该是预装的）

</details>

<details><summary>Nix/NixOS</summary>

reLCS 提供了 `flake.nix` 用于使用 Nix 进行构建。您有两个选项：

**选项 1：在开发 shell 中构建：**
```bash
nix flake update  # 如果需要，更新 flake 输入
nix develop       # 进入开发 shell，包含所有依赖项
# 然后运行上面 Linux 部分中描述的构建命令
```

**选项 2：直接使用 Nix flakes 构建：**
```bash
nix build .#re3-lcs       # 构建 GTA Liberty City Stories（lcs 分支）
```

构建的二进制文件将在 `./result/bin/` 中

</details>

### 快速构建参考

**Linux 调试版本：**
```bash
./premake5Linux --with-librw gmake2 && cd build && make -j5 config=debug_linux-amd64-librw_gl3_glfw-oal verbose=1
```

**Linux 发布版本：**
```bash
./premake5Linux --with-librw gmake2 && cd build && make -j5 config=release_linux-amd64-librw_gl3_glfw-oal verbose=1
```

**macOS 调试版本：**
```bash
premake5 --with-librw gmake2 && cd build && make -j5 config=debug_macosx-amd64-librw_gl3_glfw-oal verbose=1
```

**macOS 发布版本：**
```bash
premake5 --with-librw gmake2 && cd build && make -j5 config=release_macosx-amd64-librw_gl3_glfw-oal verbose=1
```

### 构建选项

> :information_source: [config.h](https://github.com/GTAmodding/re3/tree/lcs/src/core/config.h) 的最底部有各种设置，您可能想查看一下。例如 FIX_BUGS 定义修复我们遇到的错误。

> :information_source: **注意到 librw 了吗？** reLCS 使用完全自制的 RenderWare 替代渲染引擎；[librw](https://github.com/aap/librw/)。librw 作为 reLCS 的子模块提供，但您也可以使用 LIBRW 环境变量来指定您自己的 librw 路径。

**如果在 Windows 上选择 OpenAL** 您必须阅读 [在 Windows 上运行 OpenAL 构建](https://github.com/GTAmodding/re3/wiki/Running-OpenAL-build-on-Windows)。
