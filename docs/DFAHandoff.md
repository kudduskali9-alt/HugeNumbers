# DFA 构造与正确性交接说明

2 号的模块位于 `HugeNumbers/DFAConstruction.lean`，命名空间为 `HugeNumbers`。本模块给出 N + 2 个状态的构造及其正确性。3 号仍需证明任意有限完整 DFA 的状态数下界，随后拼接最小性结论。

## 构造

字母表为 `Unit`，状态类型为 `DFAState N = Fin (N + 2)`。初态编号为 0，接受状态的编号为 N。读入任意符号时，状态 q 转移到 `min (q.val + 1) (N + 1)`。因此 N + 1 是不接受任何串的陷阱状态。

当 N = 3 时，转移依次为 `0 → 1 → 2 → 3 → 4 → 4`，仅状态 3 接受。N = 0 时初态本身接受，读入第一个符号后进入拒绝陷阱状态 1。

## 核心接口

以下名称都位于 `HugeNumbers` 命名空间。

| 名称 | 结论或用途 |
| --- | --- |
| `exactLengthDFA N` | 类型为 `DFA Alphabet (DFAState N)` 的构造 |
| `dfaSink N` | 编号为 N + 1 的陷阱状态 |
| `exactLengthDFA_step_sink N a` | 陷阱状态读取 a 后保持不变 |
| `exactLengthDFA_sink_not_accept N` | 陷阱状态不属于接受状态集合 |
| `exactLengthDFA_evalFrom_val N q w` | 从 q 读 w 后的编号为 `min (q.val + w.length) (N + 1)` |
| `exactLengthDFA_eval_val N w` | 从初态读 w 后的编号为 `min w.length (N + 1)` |
| `exactLengthDFA_mem_accepts N w` | `w ∈ (exactLengthDFA N).accepts ↔ w.length = N` |
| `exactLengthDFA_accepts N` | `(exactLengthDFA N).accepts = exactLengthLanguage N` |
| `dfaState_card N` | `Fintype.card (DFAState N) = N + 2` |
| `exactLengthDFA_upperBound N` | 存在状态类型为 `Fin (N + 2)` 且识别目标语言的 DFA |

3 号可使用以下导入和语言假设：

```lean
module

import HugeNumbers.DFAConstruction

open HugeNumbers

-- 下界模块的对象：
-- M : DFA Alphabet σ
-- [Fintype σ]
-- hM : M.accepts = exactLengthLanguage N
-- 目标：N + 2 ≤ Fintype.card σ
```

mathlib 的 `DFA` 类型本身允许无限状态，因此下界定理要显式加入 `[Fintype σ]`。读串拼接可使用 `DFA.evalFrom_of_append`；对初态求值时可展开 `DFA.eval`。

## 证明思路

先对输入串 w 归纳，证明从任意起点 q 读串后的编号为 `min (q.val + w.length) (N + 1)`。空串不改变状态；非空串先进行一次饱和递增，再使用归纳假设，剩余自然数等式由 `omega` 证明。

将起点取为初态 0，即得 `min w.length (N + 1)`。接受条件要求该编号等于 N，而截断上限为 N + 1，严格大于 N，因此这一条件等价于 `w.length = N`。最后用集合外延性得到接受语言等式，用 `Fintype.card_fin` 的化简得到状态总数。

## 复跑与公理检查

在工程根目录执行：

```powershell
lake build
lake env lean HugeNumbers/DFAConstruction.lean
lake env lean Checks/Smoke.lean
```

也可双击 `Verify.cmd`。检查覆盖 N = 0 的空串和长度 1；N = 3 的长度 2、3、4；长度 100 的输入仍停在编号 4；以及 N = 0、3 时的状态数量。边界样例用 `decide` 直接计算构造，不借助正确性定理。

两组 `#eval` 输出应分别为 `[0, 1]` 和 `[0, 1, 2, 3, 4, 4, 4]`。检查文件还打印核心定理的公理依赖，以排查 `sorryAx` 或意外加入的公理。

2026-11-24 本机验证：工程构建、构造文件的直接检查和全部算例均已通过。核心定理的公理依赖仅涉及 Lean 的标准 `propext`、`Classical.choice` 和 `Quot.sound`，没有 `sorryAx` 或自定义公理。此记录对应本模块验证，不替代其他成员后续的独立复跑。
