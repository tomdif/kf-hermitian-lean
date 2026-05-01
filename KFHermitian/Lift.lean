/-
  KFHermitian/Lift.lean — The rational-to-complex lift lemma.

  A rational symmetric matrix becomes Hermitian after entry-wise inclusion
  ℚ ↪ ℂ. The proof relies on:
    1. Complex conjugation is the identity on the image of ℚ (since ℚ ⊂ ℝ ⊂ ℂ).
    2. `IsHermitian` (`Aᴴ = A`) reduces to `IsSymm` (`Aᵀ = A`) when conjugation
       is the identity entry-wise.

  This is the bridge used in Phase 2 (concrete cube cases) and Phase 3
  (general K_F over an arbitrary preorder).

  Zero sorry. Zero custom axioms.
-/

import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.LinearAlgebra.Matrix.Symmetric
import Mathlib.Data.Complex.Basic

/-- The complex conjugate of `((q : ℚ) : ℂ)` equals itself. -/
@[simp]
lemma KFHermitian.star_ratCast_complex (q : ℚ) : star ((q : ℂ)) = ((q : ℂ)) := by
  rw [show ((q : ℂ)) = ((q : ℝ) : ℂ) from by push_cast; ring]
  exact Complex.conj_ofReal _

namespace Matrix.IsSymm

/-- **A symmetric ℚ-matrix lifts to a Hermitian ℂ-matrix.**

    Given `A : Matrix n n ℚ` with `A.IsSymm`, the entry-wise coercion
    `A.map ((↑) : ℚ → ℂ)` satisfies `IsHermitian`. The proof: complex
    conjugation fixes the rational image in ℂ (`star_ratCast_complex`),
    so `Aᴴ` reduces to `Aᵀ`, which equals `A` by hypothesis. -/
theorem isHermitian_complexLift {n : Type*} {A : Matrix n n ℚ}
    (h : A.IsSymm) : (A.map (fun q : ℚ => (q : ℂ))).IsHermitian := by
  unfold Matrix.IsHermitian
  ext i j
  simp only [Matrix.conjTranspose_apply, Matrix.map_apply,
             KFHermitian.star_ratCast_complex]
  have hsymm : A j i = A i j := by
    have := congr_fun (congr_fun h i) j
    simpa [Matrix.transpose_apply] using this
  rw [hsymm]

end Matrix.IsSymm
