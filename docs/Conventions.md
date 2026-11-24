# 巨数的表达边界共同约定

## DFA

- 字母表：`HugeNumbers.Alphabet`，即 `Unit`。
- 长度为 N 的一元串：`HugeNumbers.unaryWord N`，即 `List.replicate N ()`。
- 目标语言：`HugeNumbers.exactLengthLanguage N`，成员条件为串长等于 N。
- 使用 mathlib 的完整 DFA 定义 `DFA`，每个状态和输入符号都有转移。
- 构造状态类型：`HugeNumbers.DFAState N = Fin (N + 2)`。
- 初态为 0；唯一接受状态为 N；N + 1 为拒绝陷阱状态。
- 最小性目标：恰好需要 N + 2 个状态。该目标尚未在本工程中证明。
- 2 号负责构造和正确性；3 号负责下界与最小性拼接。
- 已实现构造：`HugeNumbers.exactLengthDFA N`；语言等式：`HugeNumbers.exactLengthDFA_accepts N`；状态数：`HugeNumbers.dfaState_card N`。完整交接接口见 `DFAHandoff.md`。

## 忙海狸

- 二符号、全零初始纸带；n 只统计工作状态。
- 写入并移动后进入停机状态的最后一次转移也计一步。
- Lean 模型与算术编码应共用转移表格式，由相关负责人确认。

## 比较表

输入编码、描述长度单位、缩写计费规则尚需全组确定。本文件不预设这些待定细节。

## 协作

- 每人使用自己的分支，合并前提供复跑命令、预期结果和复核人。
- Lean 命名空间统一为 `HugeNumbers`。
- 新增模块应在 `HugeNumbers.lean` 中导入，再运行 `lake build`。
- 提交 `lean-toolchain`、`lakefile.toml` 和 `lake-manifest.json`；不提交 `.lake`。
- 不以 `sorry`、`admit` 或自加公理替代完成的证明。
