# clangd 开发环境

在仓库根目录执行：

```sh
git submodule update --init --recursive
nix develop
bash utils/configure-clangd.sh
```

在该开发环境中启动编辑器，使 clangd 和 GCC 继承 Nix 的依赖环境。
VS Code 安装仓库推荐的 clangd 扩展；微软 C/C++ 扩展仍可用于调试，
其 IntelliSense 已在工作区禁用，避免重复诊断。
其他编辑器应使用 PATH 中的 clangd，并传入
`--query-driver=/nix/store/*-gcc-wrapper-*/bin/*`。

`.clangd` 指向 `build-clangd/compile_commands.json`。更新 Nix 环境或
CMake 配置后重新运行配置脚本，无需先完整编译游戏。

验证：

```sh
clangd --check=src/core/main.cpp --compile-commands-dir=build-clangd \
  '--query-driver=/nix/store/*-gcc-wrapper-*/bin/*'
```

Git 子模块使用 aap/librw 和 xiph 上游仓库。Nix 构建通过 flake inputs
获取相同提交，因此无需依赖本地子模块是否初始化。更新依赖时应同步
`flake.lock` 与对应子模块的提交，避免两种构建使用不同源码。
