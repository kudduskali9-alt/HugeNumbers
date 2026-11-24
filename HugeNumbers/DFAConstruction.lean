module

public import HugeNumbers.Basic

/-!
# 长度恰好为 n 的一元语言的 DFA

状态 0 至 n 记录已读长度；状态 n + 1 为拒绝陷阱状态。
先对任意起点证明饱和计数不变量，再推出初态读串结果和接受语言。
本文件给出 n + 2 个状态的构造及正确性；最小性的下界由 3 号负责。
-/

@[expose] public section

namespace HugeNumbers

abbrev DFAState (n : ℕ) := Fin (n + 2)

/-- 超长输入到达的拒绝陷阱状态。 -/
def dfaSink (n : ℕ) : DFAState n := ⟨n + 1, by omega⟩

/-- 每读一个符号将编号加一，最多增加到 n + 1。 -/
def exactLengthDFA (n : ℕ) : DFA Alphabet (DFAState n) where
  step q _ := ⟨min (q.val + 1) (n + 1), by
    have := Nat.min_le_right (q.val + 1) (n + 1)
    omega⟩
  start := ⟨0, by omega⟩
  accept := {q | q.val = n}

@[simp] theorem exactLengthDFA_start_val (n : ℕ) :
    (exactLengthDFA n).start.val = 0 := rfl

@[simp] theorem exactLengthDFA_step_val (n : ℕ) (q : DFAState n) (a : Alphabet) :
    ((exactLengthDFA n).step q a).val = min (q.val + 1) (n + 1) := rfl

/-- 陷阱状态读入任意符号后仍停留在原处。 -/
@[simp] theorem exactLengthDFA_step_sink (n : ℕ) (a : Alphabet) :
    (exactLengthDFA n).step (dfaSink n) a = dfaSink n := by
  apply Fin.ext
  simp [exactLengthDFA_step_val, dfaSink]

/-- 陷阱状态不是接受状态，包括 n = 0 的情形。 -/
theorem exactLengthDFA_sink_not_accept (n : ℕ) :
    dfaSink n ∉ (exactLengthDFA n).accept := by
  change ¬ n + 1 = n
  omega

/-- 从任意状态 q 读串，编号为起点编号加串长并截断到 n + 1。 -/
theorem exactLengthDFA_evalFrom_val (n : ℕ) (q : DFAState n) (w : List Alphabet) :
    ((exactLengthDFA n).evalFrom q w).val = min (q.val + w.length) (n + 1) := by
  induction w generalizing q with
  | nil =>
      simp only [DFA.evalFrom_nil, List.length_nil, Nat.add_zero]
      have hq := q.isLt
      omega
  | cons a w ih =>
      rw [DFA.evalFrom_cons, ih]
      simp only [exactLengthDFA_step_val, List.length_cons]
      omega

/-- 从初态读完整个串后，状态编号等于串长与 n + 1 的较小值。 -/
theorem exactLengthDFA_eval_val (n : ℕ) (w : List Alphabet) :
    ((exactLengthDFA n).eval w).val = min w.length (n + 1) := by
  change ((exactLengthDFA n).evalFrom (exactLengthDFA n).start w).val = _
  rw [exactLengthDFA_evalFrom_val, exactLengthDFA_start_val, Nat.zero_add]

/-- 正确性：接受一个串，当且仅当其长度恰好为 n。 -/
@[simp] theorem exactLengthDFA_mem_accepts (n : ℕ) (w : List Alphabet) :
    w ∈ (exactLengthDFA n).accepts ↔ w.length = n := by
  change ((exactLengthDFA n).eval w).val = n ↔ w.length = n
  rw [exactLengthDFA_eval_val]
  omega

/-- 供 3 号拼接下界使用的语言等式。 -/
theorem exactLengthDFA_accepts (n : ℕ) :
    (exactLengthDFA n).accepts = exactLengthLanguage n := by
  apply Set.ext
  intro w
  exact exactLengthDFA_mem_accepts n w

/-- 构造使用的状态总数恰为 n + 2；这不是最小性下界。 -/
@[simp] theorem dfaState_card (n : ℕ) : Fintype.card (DFAState n) = n + 2 := by
  simp [DFAState]

/-- 显式给出一个拥有 n + 2 个状态的目标语言识别器。 -/
theorem exactLengthDFA_upperBound (n : ℕ) :
    ∃ M : DFA Alphabet (Fin (n + 2)), M.accepts = exactLengthLanguage n :=
  ⟨exactLengthDFA n, exactLengthDFA_accepts n⟩

end HugeNumbers
