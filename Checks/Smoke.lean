module

import HugeNumbers
public meta import HugeNumbers.Basic
public meta import HugeNumbers.DFAConstruction

/-! 验证真实 DFA 的边界样例、陷阱状态和核心定理公理依赖。 -/

#check DFA
#check HugeNumbers.DFAState

open HugeNumbers

-- 直接计算构造，不调用正确性定理，独立检查边界样例。
example : unaryWord 0 ∈ (exactLengthDFA 0).accepts := by
  change ((exactLengthDFA 0).eval (unaryWord 0)).val = 0
  decide

example : unaryWord 1 ∉ (exactLengthDFA 0).accepts := by
  change ¬ ((exactLengthDFA 0).eval (unaryWord 1)).val = 0
  decide

example : unaryWord 2 ∉ (exactLengthDFA 3).accepts := by
  change ¬ ((exactLengthDFA 3).eval (unaryWord 2)).val = 3
  decide

example : unaryWord 3 ∈ (exactLengthDFA 3).accepts := by
  change ((exactLengthDFA 3).eval (unaryWord 3)).val = 3
  decide

example : unaryWord 4 ∉ (exactLengthDFA 3).accepts := by
  change ¬ ((exactLengthDFA 3).eval (unaryWord 4)).val = 3
  decide

-- 长输入仍然停在陷阱状态，不回绕到接受状态。
set_option maxRecDepth 4096 in
example : ((exactLengthDFA 3).eval (unaryWord 100)).val = 4 := by decide

example : Fintype.card (DFAState 0) = 2 := by decide
example : Fintype.card (DFAState 3) = 5 := by decide

-- 验证可供下界模块导入的任意 n 接口。
example (n k : ℕ) : unaryWord k ∈ (exactLengthDFA n).accepts ↔ k = n := by simp

#eval ([0, 1].map fun k => ((exactLengthDFA 0).eval (unaryWord k)).val)
#eval ((List.range 7).map fun k => ((exactLengthDFA 3).eval (unaryWord k)).val)

#print axioms HugeNumbers.exactLengthDFA_step_sink
#print axioms HugeNumbers.exactLengthDFA_sink_not_accept
#print axioms HugeNumbers.exactLengthDFA_evalFrom_val
#print axioms HugeNumbers.exactLengthDFA_eval_val
#print axioms HugeNumbers.exactLengthDFA_mem_accepts
#print axioms HugeNumbers.exactLengthDFA_accepts
#print axioms HugeNumbers.dfaState_card
#print axioms HugeNumbers.exactLengthDFA_upperBound
