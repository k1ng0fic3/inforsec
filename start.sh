#!/usr/bin/env bash
# start.sh - 仓库启动/解密脚本（位于仓库根目录）
#
# 作用：检测环境 -> 调用 src/infosec.py 解密源码 -> 给出后续提示
# 用法：./start.sh [--check-only]
#
# 注意：实际加解密逻辑在 ./src/infosec.py，不在本目录。
#       本脚本只负责环境检查与调用，便于 AI/审计者用一个入口完成解密。

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

TOOL="src/infosec.py"
PYTHON_BIN="${PYTHON_BIN:-}"

log()  { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

# --- 1. 选择 python 解释器 -------------------------------------------------
if [[ -z "$PYTHON_BIN" ]]; then
  for cand in python3 python; do
    if command -v "$cand" >/dev/null 2>&1; then
      PYTHON_BIN="$cand"
      break
    fi
  done
fi
if [[ -z "$PYTHON_BIN" ]]; then
  err "未找到 python3 / python，请先安装 Python 3。"
  exit 1
fi
log "使用解释器: $PYTHON_BIN ($($PYTHON_BIN --version 2>&1))"

# --- 2. 检查加解密脚本是否存在 --------------------------------------------
if [[ ! -f "$TOOL" ]]; then
  err "未找到 $TOOL，无法解密。"
  err "请确认已完整克隆仓库（该文件位于 src/ 目录下）。"
  exit 1
fi

# --- 3. 安装依赖（若存在） ------------------------------------------------
if [[ -f requirements.txt ]]; then
  log "检测到 requirements.txt，安装依赖..."
  "$PYTHON_BIN" -m pip install --quiet --disable-pip-version-check -r requirements.txt \
    || warn "依赖安装失败；若解密时报 ModuleNotFoundError，请手动安装后重试。"
fi

# --- 4. 判断当前是否已解密 -------------------------------------------------
# 启发式：找第一个 .py/.php，若不含明文特征则视为加密。
is_encrypted() {
  local f
  f="$(find . -type f \( -name '*.py' -o -name '*.php' \) \
        -not -path './.git/*' -not -path '*/__pycache__/*' \
        -not -path '*/venv/*' -not -path '*/.venv/*' \
        -not -path '*/node_modules/*' -not -path '*/vendor/*' \
        -not -path "./$TOOL" | head -n 1)"
  [[ -z "$f" ]] && return 1
  if grep -qE '(^|[^A-Za-z])(def |class |import |<?php|function )' "$f" 2>/dev/null; then
    return 1   # 有明文特征 -> 已解密
  fi
  return 0     # 否则 -> 加密
}

if [[ "${1:-}" == "--check-only" ]]; then
  if is_encrypted; then log "仓库当前为加密状态。"; else log "仓库当前为明文状态。"; fi
  exit 0
fi

# --- 5. 调用 src/infosec.py 解密 ------------------------------------------
if is_encrypted; then
  log "检测到加密源码，调用 $TOOL 进行解密..."
  "$PYTHON_BIN" "$TOOL" decrypt
  log "解密完成，源码已恢复为明文。"
else
  warn "源码看起来已是明文，跳过解密以避免重复操作。"
fi

# --- 6. 收尾提示 ----------------------------------------------------------
cat <<'EOF'

下一步：
  - 开发/审计完成后、提交前，运行: ./start.sh encrypt   （见下方说明）
  - 切勿把解密后的明文源码提交到 Git。
  - 解密口令请通过安全渠道获取，不要写入脚本或提交信息。

EOF