# re3 - GTA III 源代码反编译项目

## 简介

本仓库包含 GTA III（[master](https://github.com/GTAmodding/re3/tree/master/) 分支）和 GTA VC（[miami](https://github.com/GTAmodding/re3/tree/miami/) 分支）的完整反编译源代码。

项目已在 Windows、Linux、macOS 和 FreeBSD 上进行测试，支持 x86、amd64、arm 和 arm64 架构。\
渲染引擎可使用原始 RenderWare (D3D8) 或其重新实现版本 [librw](https://github.com/aap/librw) (D3D9、OpenGL 2.1 或更高版本、OpenGL ES 2.0 或更高版本)。\
音频支持 MSS（使用原始 GTA 中的 dll）或 OpenAL。

项目还被移植到了 [Nintendo Switch](https://github.com/AGraber/re3-nx/)、
[PlayStation Vita](https://github.com/Rinnegatamante/re3) 和
[Nintendo Wii U](https://github.com/GaryOderNichts/re3-wiiu/)。

目前无法为 PS2 或 Xbox 构建。如果您有兴趣参与，请与我们联系。

## 安装

- re3 需要 PC 游戏资源才能运行，因此您**必须**拥有 [GTA III 的复制品](https://store.steampowered.com/app/12100/Grand_Theft_Auto_III/)。
- 构建 re3 或下载最新版本：
  - [Windows D3D9 MSS 32bit](https://nightly.link/GTAmodding/re3/workflows/re3_msvc_x86/master/re3_Release_win-x86-librw_d3d9-mss.zip)
  - [Windows D3D9 64bit](https://nightly.link/GTAmodding/re3/workflows/re3_msvc_amd64/master/re3_Release_win-amd64-librw_d3d9-oal.zip)
  - [Windows OpenGL 64bit](https://nightly.link/GTAmodding/re3/workflows/re3_msvc_amd64/master/re3_Release_win-amd64-librw_gl3_glfw-oal.zip)
  - [Linux 64bit](https://nightly.link/GTAmodding/re3/workflows/build-cmake-conan/master/ubuntu-18.04-gl3.zip)
  - [MacOS 64bit x86-64](https://nightly.link/GTAmodding/re3/workflows/build-cmake-conan/master/macos-latest-gl3.zip)
- 将下载的 zip 文件解压到您的 GTA 3 目录并运行 re3。zip 包含二进制文件、更新和其他游戏文件以及 OpenAL 所需的 dll。

## 截图

![re3 2021-02-11 22-57-03-23](https://user-images.githubusercontent.com/1521437/107704085-fbdabd00-6cbc-11eb-8406-8951a80ccb16.png)
![re3 2021-02-11 22-43-44-98](https://user-images.githubusercontent.com/1521437/107703339-cbdeea00-6cbb-11eb-8f0b-07daa105d470.png)
![re3 2021-02-11 22-46-33-76](https://user-images.githubusercontent.com/1521437/107703343-cd101700-6cbb-11eb-9ccd-012cb90524b7.png)
![re3 2021-02-11 22-50-29-54](https://user-images.githubusercontent.com/1521437/107703348-d00b0780-6cbb-11eb-8afd-054249c2b95e.png)

## 改进特性

我们已实现了许多对原始游戏的改进和优化。
这些可以在 `core/config.h` 中进行配置。
有些可以在运行时切换，有些则不能。

* 修复了许多大小和大的错误
* 用户文件（保存和设置）存储在 GTA 根目录中
* 设置存储在 re3.ini 文件中而不是 gta3.set
* 调试菜单，可做和更改各种事项（Ctrl-M 打开）
* 调试摄像机（Ctrl-B 切换）
* 可旋转的摄像机
* XInput 控制器支持（Windows）
* 岛屿之间无加载屏幕（菜单中的"地图内存使用"）
* 皮肤模型支持（来自 Xbox 或移动版本的模型）
* 渲染
  * 宽屏支持（正确缩放的 HUD、菜单和视角）
  * PS2 MatFX（车辆反射）
  * PS2 alpha 测试（更好的透明度渲染）
  * PS2 粒子
  * Xbox 车辆渲染
  * Xbox 世界光照贴图渲染（需要 Xbox 地图）
  * Xbox 模型边缘光
  * Xbox 屏幕雨滴
  * 更可自定义的颜色过滤
* 菜单
  * 地图
  * 更多选项
  * 控制器配置菜单
  * ...
* 可以加载来自其他平台的 DFF 和 TXD，可能会有性能损失
* ...

## 待做事项

以下事项将很好做/待做：

* 修复高 FPS 下的物理问题
* 改进低端设备的性能，尤其是 Raspberry Pi 上的 OpenGL 层（如果您有相关经验，请与我们联系）
* 与 PS2 代码进行比较（繁琐，没有好的反编译器）
* [PS2 移植](https://github.com/GTAmodding/re3/wiki/PS2-port)
* Xbox 移植（不太重要）
* 反编译剩余的未使用/调试函数
* 将 CodeWarrior 构建与原始二进制文件进行比较以获得更准确的代码（非常繁琐）

## 模组

资源修改（模型、纹理、处理、脚本等）应以与原始 GTA 基本相同的方式工作。

CLEO 脚本可与 [CLEO Redux](https://github.com/cleolibrary/CLEO-Redux) 兼容。

修改代码的模组（dll/asi、限制调整器）**不会**工作。
这些模组的某些功能已在 re3 中实现（SkyGFX、GInput、SilentPatch、宽屏修复的大部分内容），
其他可以轻松实现（增加限制，参见 `config.h`），
其他则必须重新编写并直接集成到代码中。
对于给您带来的不便，我们深表歉意。

## 从源代码构建  

使用 premake 时，如果要将可执行文件通过后构建脚本移动到那里，您可能希望将 GTA_III_RE_DIR 环境变量指向 GTA3 根文件夹。

使用 `git clone --recursive https://github.com/GTAmodding/re3.git` 克隆仓库。然后 `cd re3` 进入克隆的仓库。

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

<details><summary>Nix/NixOS</summary>

re3 提供了 `flake.nix` 用于使用 Nix 进行构建。您有两个选项：

**选项 1：在开发 shell 中构建：**
```bash
nix flake update  # 如果需要，更新 flake 输入
nix develop       # 进入开发 shell，包含所有依赖项
# 然后运行上面 Linux 部分中描述的构建命令
```

**选项 2：直接使用 Nix flakes 构建：**
```bash
nix build .#re3          # 构建 GTA III（master 分支）
nix build .#re3-vc       # 构建 GTA Vice City（miami 分支）
nix build .#re3-lcs      # 构建 GTA Liberty City Stories（lcs 分支）
```

构建的二进制文件将在 `./result/bin/` 中

</details>

### 构建选项

> :information_source: premake 有一个 `--with-lto` 选项，如果您想用链接时优化编译项目。

> :information_source: [config.h](https://github.com/GTAmodding/re3/tree/master/src/core/config.h) 中有各种设置，您可能想查看一下。

> :information_source: re3 使用完全自制的 RenderWare 替代渲染引擎；[librw](https://github.com/aap/librw/)。librw 作为 re3 的子模块提供，但您也可以使用 LIBRW 环境变量来指定您自己的 librw 路径。

如果您愿意，您也可以使用 CodeWarrior 7 使用提供的 codewarrior/re3.mcp 项目来编译 re3 - 这需要原始的 RW33 库和 DX8 SDK。与 MSVC 构建相比，此构建不稳定，主要用作参考。

## 贡献

只要不是 linux/跨平台骨架/兼容层，仓库中未在预处理器条件（如 FIX_BUGS）后面的所有代码都**完全**是从原始二进制文件反编译的代码。

我们**不**接受自定义代码，除非它由预处理器条件包装，或者它是 linux/跨平台骨架/兼容层。

我们只接受这些类型的 PR：

- 存在于至少一个 GTA 中的新特性（如果它不在 III/VC 中，则不必是反编译）
- 游戏、UI 或 UX 错误修复（如果是对原始代码的修复，应该在 FIX_BUGS 后面）
- 尚未反编译的平台特定和/或未使用的代码
- 使反编译代码更易理解/准确，如"哪个代码会产生这个汇编"
- 新的跨平台骨架/兼容层或对其的改进
- 翻译修复，用于原始游戏支持的语言
- 增加可维护性的代码

我们有一个[编码风格](https://github.com/GTAmodding/re3/blob/master/CODING_STYLE.md)文档，但没有很好地遵循或强制执行。

不要使用 C++11 或更高版本的功能。

## 历史

re3 始于 2018 年春季，
最初是一种测试反编译碰撞和物理代码的方式
在游戏内。
这是通过将游戏的单个函数替换为
它们的 dll 反编译对应物来完成的。

经过一些工作后，项目休眠了大约一年
并在 2019 年 5 月再次被接取并推送到 github。
当时我（aap）已反编译了大约 10k 行代码，并估计
最终游戏有大约 200-250k。
其他人很快加入了这项工作（Fire_Head、shfil、erorcun 和 Nick007J
按时间顺序，Serge 稍后），我们取得了非常快的进展
在 2019 年夏季
之后步伐放缓了一些。

由于每个人都在新冠疫情开始期间待在家里
每个人都有大量时间再次参与 re3 工作
我们终于在 2020 年 4 月获得了独立的 exe（当时大约 180k 行）。

在最初的兴奋和进一步修复和抛光代码之后，
reVC 在 2020 年 5 月初由从 re3 代码开始
而不是通过用 dll 替换函数从头开始。
经过几个月的大部分稳定进展，我们认为 reVC
在 12 月完成。

从那时起，我们已经开始了 reLCS，目前正在进行中。

## 许可证

我们不认为我们有地位为此代码给予许可证。\
该代码应仅用于教育、文档和修改目的。\
我们不鼓励盗版或商业使用。\
请保持衍生作品开源并提供适当的鸣名。
