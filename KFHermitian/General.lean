/-
  KFHermitian/General.lean — Phase 3: K_F is Hermitian on tuple-indexings
  in any finite preorder.

  The headline result of this repository: for any preorder `α` with decidable
  order and finite carrier, the K_F operator

      K_F(P, Q) := det(ζ[P, Q]) + det(ζ[Q, P]) − δ_{P,Q}

  on d-tuples in α, viewed as a matrix `Matrix (Fin d → α) (Fin d → α) ℚ`,
  is symmetric — and consequently Hermitian over ℂ via `Lift`.

  The Phase 0 pencil note showed the symmetry argument depends only on the
  formula's invariance under (P, Q) ↦ (Q, P): commutativity of `+` and the
  symmetry of the Kronecker delta. No grading, rank, or `[m]^d`-specific
  structure is needed for Hermitian-ness; all those concerns belong to
  Phase 4 (spectral gap, functoriality).

  Specializing α to `Fin m` and projecting to chains-of-length-d (the
  chamber points of `[m]^d`) recovers the Phase 1/2 cube cases.

  Zero sorry. Zero custom axioms.
-/

import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import KFHermitian.Lift

namespace KFHermitian.General

open Matrix

/-! ## The order kernel and K_F as a function -/

/-- The order kernel of a preorder: `ζ(i, j) = 1 if i ≤ j else 0`. -/
def orderKernel {α : Type*} [LE α] [DecidableLE α] (i j : α) : ℚ :=
  if i ≤ j then 1 else 0

/-- The K_F operator on pairs of d-tuples in a preorder.

    `K_F(P, Q) = det(ζ[P, Q]) + det(ζ[Q, P]) − δ_{P, Q}`

    where `ζ[P, Q]` is the d × d matrix with (a, b) entry `ζ(P[a], Q[b])`. -/
noncomputable def K_F {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α] {d : ℕ}
    (P Q : Fin d → α) : ℚ :=
  (Matrix.of (fun a b : Fin d => orderKernel (P a) (Q b))).det
  + (Matrix.of (fun a b : Fin d => orderKernel (Q a) (P b))).det
  - (if P = Q then 1 else 0)

/-! ## Symmetry of K_F as a function -/

/-- **K_F is symmetric in its arguments:** `K_F(P, Q) = K_F(Q, P)` for any
    d-tuples P, Q in any preorder.

    The proof is essentially the formula's invariance under swapping P and
    Q: the two determinant terms swap places (commutativity of `+`), and
    the Kronecker delta is symmetric in (P, Q). -/
theorem K_F_symm {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α] {d : ℕ}
    (P Q : Fin d → α) : K_F P Q = K_F Q P := by
  unfold K_F
  have hδ : (if P = Q then (1 : ℚ) else 0) = (if Q = P then (1 : ℚ) else 0) := by
    by_cases h : P = Q
    · subst h; rfl
    · have h' : ¬ Q = P := fun heq => h heq.symm
      rw [if_neg h, if_neg h']
  rw [hδ]
  ring

/-! ## K_F as a matrix on a finite preorder -/

/-- The K_F matrix on `Fin d → α` when α is a finite preorder.

    Indexing by `Fin d → α` (rather than the strict-monotone subtype) keeps
    the construction maximally general; specializing to chains of length d
    recovers the chamber-points construction of `UnifiedTheory.LayerA.KFComputable`. -/
noncomputable def K_F_matrix {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α]
    [Fintype α] (d : ℕ) : Matrix (Fin d → α) (Fin d → α) ℚ :=
  Matrix.of (fun P Q : Fin d → α => K_F P Q)

/-- **K_F as a matrix on a finite preorder is symmetric.**

    Direct corollary of `K_F_symm`. -/
theorem K_F_matrix_isSymm {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α]
    [Fintype α] (d : ℕ) : (K_F_matrix (α := α) d).IsSymm := by
  ext P Q
  simp only [Matrix.transpose_apply, K_F_matrix, Matrix.of_apply]
  exact (K_F_symm P Q).symm

/-! ## Hermitian over ℂ — the headline result -/

/-- The K_F matrix lifted from ℚ to ℂ. -/
noncomputable def K_F_matrix_C {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α]
    [Fintype α] (d : ℕ) : Matrix (Fin d → α) (Fin d → α) ℂ :=
  (K_F_matrix (α := α) d).map (fun q : ℚ => (q : ℂ))

/-- **HEADLINE — Phase 3:**
    K_F is Hermitian on tuple-indexed pairs in any finite preorder.

    For any preorder `α` with decidable order and finite carrier, the
    K_F operator on d-tuples in α — viewed as a matrix and lifted to ℂ —
    is Hermitian. This is the structural theorem the `unifiedtheory`
    program implicitly assumes; making it explicit converts an "almost
    formal" claim into a fully formal one.

    Phase 4 will use this Hermitian structure to prove physical properties
    (spectral gap, functoriality) on graded locally finite posets. -/
theorem K_F_matrix_C_isHermitian {α : Type*} [Preorder α] [DecidableLE α]
    [DecidableEq α] [Fintype α] (d : ℕ) :
    (K_F_matrix_C (α := α) d).IsHermitian :=
  (K_F_matrix_isSymm d).isHermitian_complexLift

end KFHermitian.General
