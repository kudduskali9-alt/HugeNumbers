module

public import Mathlib.Computability.DFA

/-! 全组共用的一元字母表和目标语言。 -/

@[expose] public section

namespace HugeNumbers

abbrev Alphabet := Unit

/-- 长度为 n 的一元串。 -/
def unaryWord (n : ℕ) : List Alphabet := List.replicate n ()

/-- 只包含长度恰好为 n 的一元串的语言。 -/
def exactLengthLanguage (n : ℕ) : Language Alphabet :=
  {w | w.length = n}

@[simp] theorem unaryWord_length (n : ℕ) : (unaryWord n).length = n := by
  simp [unaryWord]

@[simp] theorem mem_exactLengthLanguage (n : ℕ) (w : List Alphabet) :
    w ∈ exactLengthLanguage n ↔ w.length = n := Iff.rfl

end HugeNumbers
