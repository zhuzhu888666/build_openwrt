#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 禁用 OpenWrt/immortalwrt Rust 包的 download-ci-llvm
# 用于规避 rust-dev-*.tar.xz 的 CI 产物 404 导致的构建失败
# ============================================================

RUST_MAKEFILE="feeds/packages/lang/rust/Makefile"

if [[ ! -f "$RUST_MAKEFILE" ]]; then
  echo "[ERROR] 未找到 $RUST_MAKEFILE"
  echo "        请确认当前目录是 OpenWrt/immortalwrt 源码根目录，且已执行 feeds update/install。"
  exit 1
fi

echo "[INFO] 目标文件: $RUST_MAKEFILE"

# 备份一次，方便对比或回滚
if [[ ! -f "${RUST_MAKEFILE}.bak" ]]; then
  cp "$RUST_MAKEFILE" "${RUST_MAKEFILE}.bak"
  echo "[INFO] 已备份到 ${RUST_MAKEFILE}.bak"
fi

# 显示修改前相关行
echo "[INFO] 修改前 download-ci-llvm 相关配置："
grep -n "download-ci-llvm" "$RUST_MAKEFILE" || echo "        (未找到 download-ci-llvm 字样)"

# 执行替换：true -> false
# 兼容 --set=llvm.download-ci-llvm=true 以及 download-ci-llvm = true 等写法
sed -i -E \
  -e 's/(download-ci-llvm[[:space:]]*=[[:space:]]*)true/\1false/g' \
  -e 's/(download-ci-llvm[[:space:]]*=[[:space:]]*)1/\1false/g' \
  "$RUST_MAKEFILE"

# 如果完全没有 download-ci-llvm 配置，则尝试在 CONFIGURE_ARGS 中追加禁用参数
if ! grep -q "download-ci-llvm" "$RUST_MAKEFILE"; then
  echo "[WARN] 未发现 download-ci-llvm 配置，尝试追加 --set=llvm.download-ci-llvm=false"
  # 在 CONFIGURE_ARGS 行后追加；若没有该变量则给出提示
  if grep -q "^[[:space:]]*CONFIGURE_ARGS" "$RUST_MAKEFILE"; then
    sed -i -E '/^[[:space:]]*CONFIGURE_ARGS/a\  --set=llvm.download-ci-llvm=false \\' "$RUST_MAKEFILE"
  else
    echo "[ERROR] 未找到 CONFIGURE_ARGS，无法自动追加。请手动检查 Makefile。"
    exit 1
  fi
fi

echo "[INFO] 修改后 download-ci-llvm 相关配置："
grep -n "download-ci-llvm" "$RUST_MAKEFILE" || echo "        (仍未找到，请手动检查)"

# 清理 Rust 构建目录，避免旧配置/缓存干扰
echo "[INFO] 清理 Rust host 构建目录..."
rm -rf build_dir/target-*/host/rustc-* 2>/dev/null || true
rm -rf build_dir/host/rustc-* 2>/dev/null || true

echo "[DONE] 已完成 download-ci-llvm 禁用与构建目录清理。"
echo "       建议重新执行 make package/feeds/packages/rust/host/compile V=s 验证。"
