# Phase 4 — Plan: physical properties on graded locally finite posets

Status: planned, not started. Phases 1–3 (Hermitian-ness) are mechanically complete; Phase 4 is where the genuinely novel mathematical content lives.

## Why this is the talk-grade phase

The Phase 3 result (`K_F_matrix_C_isHermitian`) is structurally true in essentially full generality — the symmetry argument is a one-line consequence of the formula. Anyone reading the paper carefully would say "yes, of course." The interesting question is what *physical* structure the Hermitian K_F has, and that requires the indexing poset to have at least *graded* structure. That's where the work is.

Phase 4 splits into 4a (committed) and 4b (stretch) — see `Pencil.md` for the rationale.

## Phase 4a — the committed deliverables

Working setting: `α : Type*` with `[GradedOrder α]` (or equivalent), `[LocallyFiniteOrder α]`, plus typeclasses ensuring K_F's matrix form is well-defined on antichain or chain indexings.

### (4a-i) Spectral gap > 0

**Theorem statement (target).**

```lean
theorem K_F_spectralGap_pos
    {α : Type*} [Preorder α] [LocallyFiniteOrder α] [GradedOrder α]
    [DecidableLE α] [DecidableEq α] [Fintype α] (d : ℕ) :
    0 < spectralGap (K_F_matrix_C (α := α) d)
```

**Proof sketch.** The K_F matrix has a block structure aligned with the rank decomposition: rank-r antichains form a sub-block, and inter-rank entries are exactly the determinantal-kernel transitions. Positivity of the spectral gap follows from:

1. K_F restricted to a single rank level is a sum of rank-one projectors (positive semi-definite).
2. The off-diagonal blocks have norm bounded by the rank-level diameters.
3. The Cheeger-style inequality for the resulting block matrix.

The rank structure is essential: without grading, no canonical decomposition exists, and the positivity argument fails.

**Estimated effort.** 1–1.5 weeks in Lean. The hard piece is the Cheeger inequality on a non-symmetric block decomposition; Mathlib has `Matrix.IsHermitian.eigenvalues` but the gap-bound machinery is sparse. May require building auxiliary `Matrix.PosSemidef` infrastructure.

### (4a-ii) Functoriality under rank-preserving embeddings

**Theorem statement (target).**

```lean
theorem K_F_functoriality
    {α β : Type*} [Preorder α] [Preorder β]
    [LocallyFiniteOrder α] [LocallyFiniteOrder β]
    [GradedOrder α] [GradedOrder β]
    [Fintype α] [Fintype β]
    (φ : α →o β) (h_rank : ∀ a, rank (φ a) = rank a) (d : ℕ) :
    ∃ ψ : (Fin d → α) ↪ (Fin d → β),
      ∀ P Q, K_F P Q = K_F (ψ P) (ψ Q)
```

i.e. a rank-preserving order embedding `α ↪ β` induces an isometric embedding of K_F matrices.

**Proof sketch.** Order-preservation makes the determinantal kernel ζ-functorial: `ζ(φ(i), φ(j)) = ζ(i, j)` because both equal `1 if i ≤ j else 0`. Rank-preservation extends this from the kernel to the K_F formula by ensuring chamber/antichain decompositions transport.

**Estimated effort.** 1 week. Mostly bookkeeping once the chain/antichain indexing types are pinned down.

### (4a-iii) Positivity criterion

**Theorem statement (target).**

```lean
theorem K_F_posSemidef_iff
    {α : Type*} [Preorder α] [LocallyFiniteOrder α] [GradedOrder α]
    [Fintype α] (d : ℕ) :
    (K_F_matrix_C (α := α) d).PosSemidef ↔
      (∀ rank-level antichains A, ∑ … some explicit determinantal sum … ≥ 0)
```

Characterizes when K_F is a *physical* observable (positive semi-definite, hence representable as a density matrix's expectation).

**Proof sketch.** Direct expansion of the determinantal kernel against unit vectors, using `Matrix.PosSemidef.iff_…` Mathlib lemmas. The right-hand condition is checkable cell-by-cell on rank-level antichains.

**Estimated effort.** 1–2 weeks. The forward direction is straightforward; the reverse direction (positivity of every level-restricted sum implies global PSD) needs a Schur-complement argument.

## Phase 4b — stretch deliverables

Working setting: `α : Type*` with `[Preorder α]` and `[LocallyFiniteOrder α]` only. No grading.

### (4b-i) Spectral gap on non-graded LFP

If 4a-i pins down which step uses grading, 4b asks whether grading is *necessary* or merely *convenient*. There are two possible outcomes:

- **Generalization possible.** The grading is a convenience; a structurally weaker hypothesis (e.g., the existence of *any* rank-like function) suffices. This would be a stronger theorem.
- **Grading is essential.** The Cheeger argument fails on non-graded LFP. The theorem fails or admits only a weaker bound.

Either outcome is publishable; the latter would be a sharp boundary-of-applicability result.

**Estimated effort.** 1–2 weeks. Strong dependence on what 4a-i reveals.

### (4b-ii) Sharp bound on ‖K_F‖

Phase 3 gives Hermitian-ness, hence real eigenvalues. A sharp upper bound on the operator norm (in terms of d, |α|, and combinatorial invariants of the poset) would let downstream `unifiedtheory` claims about γ_d = ln((d+1)/(d-1)) be re-derived from a structural inequality rather than the ad-hoc Volterra calculation.

**Estimated effort.** 1+ week, contingent on 4b-i.

## Trigger for going to talk

Phase 4a complete (i.e., spectral gap > 0 + functoriality, ideally + positivity criterion) is the trigger for QPL / Lean Together / FoMM submission. The novelty pitch: *"a verified constructor turning order-theoretic data into Hermitian observables, with a structural (not ad-hoc) spectral-gap bound."*

Until then: zero talks, zero overclaims.

## Open questions before Phase 4 starts

1. **Mathlib's `GradedOrder` typeclass status.** Mathlib has rank-related infrastructure scattered across files. Worth ~2 hours of triage before Phase 4a starts to map what's reusable.

2. **Cheeger-on-block-Hermitian Mathlib status.** The standard Cheeger inequality is for symmetric matrices on graphs. Mathlib has `SimpleGraph.spectralGap` but the more general Cheeger for arbitrary Hermitian PSD matrices may not be there.

3. **Choice of indexing.** Phase 3 indexes by `Fin d → α` (all d-tuples). Phase 4a will likely want to restrict to chains-of-length-d (the chamber points of [m]^d generalized). The change-of-indexing should preserve the Hermitian result; the spectral-gap argument almost certainly *needs* the chain restriction.

4. **The `unifiedtheory` cross-cite.** Once Phase 4a lands, the next move is a PR back into `unifiedtheory` adding a `KFHermitian` import and re-deriving γ_d through `K_F_matrix_C_isHermitian.spectralTheorem` rather than ad-hoc char-poly. That PR closes the bridge — the entire K_F → eigenvalue → m_H chain runs through `Matrix.IsHermitian` start-to-end.
