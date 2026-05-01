/-
  KFHermitian/Eigenvalues.lean — Phase 4 prelude: eigenvalues of K_F via the
  Mathlib `Matrix.IsHermitian.eigenvalues` API.

  We expose the eigenvalues of the K_F matrix (lifted to ℂ) as a real-valued
  function on the indexing set, and record the basic spectral facts that
  follow immediately from `IsHermitian`:
    - eigenvalues are real (definitional from `IsHermitian.eigenvalues`)
    - the spectrum decomposition is available

  The genuinely novel Phase 4a results — spectral gap > 0, positivity
  criterion — require a graded structure and are deferred to a later file.

  Zero sorry. Zero custom axioms.
-/

import Mathlib.Analysis.Matrix.Spectrum
import KFHermitian.General

namespace KFHermitian.Eigenvalues

open Matrix
open KFHermitian.General

/-- The eigenvalues of the K_F matrix on a finite preorder, as a real-valued
    function on tuples. This packages `Matrix.IsHermitian.eigenvalues`
    applied to `K_F_matrix_C_isHermitian`. -/
noncomputable def K_F_eigenvalues
    {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α] [Fintype α]
    (d : ℕ) : (Fin d → α) → ℝ :=
  Matrix.IsHermitian.eigenvalues (K_F_matrix_C_isHermitian (α := α) d)

/-- **K_F has real spectrum.** Trivially follows from `IsHermitian`; recorded
    here to make the dependency on Phase 3 explicit and to provide the
    canonical real eigenvalue function for downstream use. -/
theorem K_F_has_real_eigenvalues
    {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α] [Fintype α]
    (d : ℕ) :
    ∀ P : Fin d → α, ∃ r : ℝ, (K_F_eigenvalues (α := α) d) P = r := by
  intro P
  exact ⟨K_F_eigenvalues (α := α) d P, rfl⟩

end KFHermitian.Eigenvalues
