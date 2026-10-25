# reVC-Improved

**Languages:** [English](README.md) | [中文 (Chinese)]

<img src="../res/images/logo.svg" width="128px"></img>

## 简介

本仓库在 re3 原仓库上做出以下改动：

- 移除了 canon 构建
- 增加了 nix flake 构建和打包
- 修复 workflows 使它们可以正常工作
- 尽可能启用 ps2 特性和移动版特性

为了方便在 NixOS 上安装和运行游戏，在 [re3-falke](https://github.com/gujial/re3-flake) 中编写了对应的 Nix 包装器。

> 包装器可以做到自动配置 re3、reVC、reLCS，但仍然需要有原版游戏文件，默认使用 Steam 的默认安装路径寻找原版游戏文件（除reLCS之外）。

相比其他分支，reVC 分支做出了更多改动：

- 内置的中文支持
- 添加了用于解包、翻译、打包文本的相关工具
- 添加了用于自动生成字符表的工具
- 添加了基于字符表和自定义字体生成中文字体贴图的工具
- 支持渲染 Emoji
- 启用了日文和波兰文的设置选项，但是并未实装
- 修改了退出时的海报
- 修复一些错误
  - wayland 下使用分数缩放比例时鼠标位置不正确
  - Linux 下无法删除存档
- 一些新功能
  - 在暂停菜单中保存游戏
  - 任务完成后自动保存存档到单独的自动保存槽位
  - 按下 `F10` 启用或关闭帧数限制
  - 减小第一人称鼠标灵敏度，倍率在设置中调整
  - 接听电话后再次按下跳过电话
- 一些改进
  - 统一水平和垂直灵敏度
  - 增加载具内自由视角跟随速度

> 在任务中或在载具中无法保存，自动保存会等待汤米离开载具后执行。

> 相比 reVC 分支，reVC-Improved 改动了游戏脚本文件 `main.scm`，不兼容原版存档。如果需要兼容原版存档，使用原版的 `main.scm` 即可。

修改游戏的过程中使用到了以下工具/代码，在此致谢：

- 中文文本基于无名汉化补丁 1.0 正式版修改、适配和补充
- 中文文字渲染代码来自 [Ova1122/Revc_Chs](https://github.com/Ova1122/Revc_Chs)
- 中文映射表生成器`dat_generator`实现时参考了无名汉化组 [WMHHZ/VC.SA.Plugin](https://github.com/WMHHZ/VC.SA.Plugin/blob/master/VCGXTBuilder/VCGXT.cpp) 的代码
- GXT 文件打包和解包工具实现时使用了 [Lzh102938/III.VC.SAGXTExtracter](https://github.com/Lzh102938/III.VC.SAGXTExtracter/blob/main/builder/VCGXT.PY) 的模块
- 将中文字符 png 文件打包为 txd 文件时使用了 [Magic.TXD](https://www.gtagarage.com/mods/show.php?id=27862)
- 渲染中文字符 png 文件使用了 pillow 和 pilmoji 模块
- 中文字体暂时使用的是 wqy-zenhei 和 tegaki_zatsu_normal，后续可能会调整

后续的修改依然集中于 miami 分支。

## 安装

### 非 Nixos 的情况

准备好原版游戏文件，之后在 Actions 或 Releases 中找到需要的版本压缩包，将全部文件覆盖到原版游戏文件夹。

### Nixos 和其他使用 Nix 软件包管理器的情况

参考 [re3-falke](https://github.com/gujial/re3-flake) 安装，二进制文件已上传至 Nix Cache。

## 模组

目前兼容情况与原版 reVC 相同，后续可能考虑扩展脚本系统。

## 从源代码构建

克隆本分支并初始化上游子模块：

```bash
git clone --recurse-submodules -b miami-improve https://github.com/gujial/re3.git
cd re3
# 已有仓库使用：
git submodule update --init --recursive
```

Nix/NixOS 用户先执行 `nix develop` 获取编译器和依赖，再选择下方的本地构建方式。
其他系统需要安装 C/C++ 编译器、Make、CMake、pkg-config，以及 OpenGL、GLFW、
GLEW、OpenAL、mpg123、libsndfile 的开发包；Linux 还需要 X11 开发依赖。

### CMake（Linux/macOS）

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

产物为 `build-cmake/src/reVC-Improved`。发布构建将 `CMAKE_BUILD_TYPE` 改为
`Release`。CMake 构建目录应与 Premake 的 `build/` 分开。
clangd 使用方式见[配置说明](clangd.zh_CN.md)；执行
`bash utils/configure-clangd.sh` 会用相同后端配置 `build-clangd/`。

### Premake（Linux/macOS）

Linux 下执行：

```bash
./premake5Linux --with-librw gmake2
make -C build -j8 config=debug_linux-amd64-librw_gl3_glfw-oal
# 发布构建：
make -C build -j8 config=release_linux-amd64-librw_gl3_glfw-oal
```

调试产物为 `bin/linux-amd64-librw_gl3_glfw-oal/Debug/reVC-Improved`，
发布产物位于对应的 `Release/` 目录。
macOS 使用 `premake5` 替代 `./premake5Linux`，并选择生成的平台配置；
Intel Mac 将配置名中的 `linux-amd64` 改成 `macosx-amd64`。
Premake 项目名仍为 `reVC`，可执行文件名统一为 `reVC-Improved`。
更新仓库后请重新生成构建文件。从旧版 X11 输入配置升级时，首次 `make`
添加 `-B`，强制按新编译参数重建对象文件。Git 版本源文件会自动生成，支持首次并行构建。
两种构建方式均使用 GLFW 通用键盘回调，兼容 X11 和 Wayland。

`--with-lto` 启用链接时优化，`--no-git-hash` 禁用嵌入的提交标识。
可通过 `GTA_VC_RE_DIR` 设置 Premake 构建后使用的游戏输出位置。

### Nix 软件包构建

```bash
nix build .#reVC-Improved
# 或构建调试包：
nix build .#reVC-Improved-debug
```

产物为 `result/bin/reVC-Improved`，附带资源位于
`result/share/reVC-Improved/`。Nix 使用 `flake.lock` 锁定的上游提交，
与 Git 子模块版本对齐。正常构建不需要先运行 `nix flake update`。

### 运行游戏

需要自行准备原版 GTA Vice City 资源。将本仓库 `gamefiles/` 的内容合并到
游戏目录并替换对应文件，操作前备份已有文件。使用 Nix 软件包时，
附带资源来源为 `result/share/reVC-Improved/`。

启动时必须以游戏目录为工作目录。例如资源已准备在 `local_gamefiles/` 时，
选择以下任意一种产物运行：

```bash
cd local_gamefiles
../build-cmake/src/reVC-Improved
# 或：
../bin/linux-amd64-librw_gl3_glfw-oal/Debug/reVC-Improved
# 或：
../result/bin/reVC-Improved
```

引擎不会自动搜索仓库的 `gamefiles/` 或 Nix 包的 share 目录。
其他编译选项可查看 [`src/core/config.h`](../src/core/config.h)。

## 贡献

本仓库致力于完善原版游戏体验，并实现多平台同步，也可作为改版游戏的基础版本，相比于原 re3 仓库对贡献的要求更低。

## 许可证

保留原 re3 仓库的要求，不使用许可证，代码仅用于教育、文档和修改目的，不支持盗版和商业使用。

## 文档补充

- [原仓库自述文件](./README.origin.md)
- [本地化工作流程](./localization.zh_CN.md)
