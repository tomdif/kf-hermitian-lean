/-
  KFHermitian/Functoriality.lean — Phase 4a partial: order-embedding invariance.

  An order embedding `φ : α ↪o β` between preorders induces an entry-wise
  invariance of K_F:

      K_F (φ ∘ P) (φ ∘ Q) = K_F P Q.

  This is the algebraic skeleton of "functoriality": K_F respects order
  embeddings. The full Phase 4a-ii claim (K_F as a Matrix is preserved
  under tuple-pushforward by `φ`) follows immediately and is also
  recorded here.

  No grading is needed — the theorem holds for any preorder. Grading
  enters only in Phase 4a-i (spectral gap) and 4a-iii (positivity
  criterion), which are not in this file.

  Zero sorry. Zero custom axioms.
-/

import KFHermitian.General

namespace KFHermitian.Functoriality

open Matrix
open KFHermitian.General

/-- The K_F **diagonal entries** are explicit:
    `K_F(P, P) = 2 · det(ζ[P, P]) − 1`. -/
theorem K_F_diagonal {α : Type*} [Preorder α] [DecidableLE α] [DecidableEq α] {d : ℕ}
    (P : Fin d → α) :
    K_F P P = 2 * (Matrix.of (fun a b : Fin d => orderKernel (P a) (P b))).det - 1 := by
  unfold K_F
  rw [if_pos rfl]
  ring

/-- An **order embedding `φ : α ↪o β` preserves K_F entry-wise.**

    The proof: the order kernel `ζ` is invariant under order embeddings
    (since `φ a ≤ φ b ↔ a ≤ b`), so `ζ[φ ∘ P, φ ∘ Q] = ζ[P, Q]` as matrices,
    and their determinants agree. The Kronecker delta is preserved because
    `φ` is injective: `φ ∘ P = φ ∘ Q ↔ P = Q`. -/
theorem K_F_orderEmbed_invariant {α β : Type*}
    [Preorder α] [Preorder β]
    [DecidableLE α] [DecidableLE β]
    [DecidableEq α] [DecidableEq β]
    (φ : α ↪o β) {d : ℕ} (P Q : Fin d → α) :
    K_F (φ ∘ P) (φ ∘ Q) = K_F P Q := by
  unfold K_F
  have hker_PQ :
      (Matrix.of (fun a b : Fin d => orderKernel ((φ ∘ P) a) ((φ ∘ Q) b)))
        = (Matrix.of (fun a b : Fin d => orderKernel (P a) (Q b))) := by
    ext a b
    simp [orderKernel, Function.comp, φ.le_iff_le]
  have hker_QP :
      (Matrix.of (fun a b : Fin d => orderKernel ((φ ∘ Q) a) ((φ ∘ P) b)))
        = (Matrix.of (fun a b : Fin d => orderKernel (Q a) (P b))) := by
    ext a b
    simp [orderKernel, Function.comp, φ.le_iff_le]
  have hδ : (if (φ ∘ P) = (φ ∘ Q) then (1 : ℚ) else 0) = (if P = Q then 1 else 0) := by
    by_cases h : P = Q
    · subst h; simp
    · have h' : ¬ (φ ∘ P) = (φ ∘ Q) := by
        intro heq
        apply h
        funext i
        exact φ.injective (congr_fun heq i)
      rw [if_neg h, if_neg h']
  rw [hker_PQ, hker_QP, hδ]

/-- **Functoriality at the matrix level:** an order embedding `α ↪o β` and
    a fixed `d` induce a function on indexings that pulls back the K_F matrix.

    Concretely, `(K_F_matrix d : Matrix (Fin d → β) (Fin d → β) ℚ)` evaluated
    on pushed-forward tuples matches `K_F_matrix d` on `α`. -/
theorem K_F_matrix_orderEmbed_invariant {α β : Type*}
    [Preorder α] [Preorder β]
    [DecidableLE α] [DecidableLE β]
    [DecidableEq α] [DecidableEq β]
    [Fintype α] [Fintype β]
    (φ : α ↪o β) {d : ℕ} (P Q : Fin d → α) :
    K_F_matrix (α := β) d (φ ∘ P) (φ ∘ Q) = K_F_matrix (α := α) d P Q := by
  simp [K_F_matrix, K_F_orderEmbed_invariant φ P Q]

end KFHermitian.Functoriality
