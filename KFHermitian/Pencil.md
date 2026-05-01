# Phase 0 — Pencil exploration

Status: complete (this document).

## Question this exploration answers

The Phase 3 generalization in the original plan was framed as risky because "chamber points" / "antichain quotient" do not generalize uniformly across all locally finite posets. The pencil exploration asks: **what does the symmetry argument for K_F actually depend on?**

## The K_F construction

Given:

- a preorder `α`,
- a positive integer `d`,
- the **order kernel** `ζ : α × α → ℝ` with `ζ(i, j) = 1 if i ≤ j else 0`,
- an **indexing set** `𝒞 ⊆ α^d` of d-tuples (typically chains, or chamber points of `[m]^d`).

For each pair `P, Q ∈ 𝒞`, define the d × d matrix `ζ[P, Q]` with `(a, b)` entry `ζ(P[a], Q[b])`.

The K_F operator is

```
K_F(P, Q) := det(ζ[P, Q]) + det(ζ[Q, P]) − δ_{P,Q}.
```

## Symmetry argument

```
K_F(Q, P) = det(ζ[Q, P]) + det(ζ[P, Q]) − δ_{Q,P}
          = det(ζ[P, Q]) + det(ζ[Q, P]) − δ_{P,Q}      [+ commutes;  δ symmetric]
          = K_F(P, Q).
```

The argument depends on:

1. The formula for K_F (a sum of two determinants ± a Kronecker delta).
2. Commutativity of `+` in ℝ (or ℚ, or any commutative ring).
3. Symmetry of `δ_{P,Q}`.

The argument does **not** depend on:

- locally finite,
- graded,
- rank structure,
- the poset being `[m]^d`,
- any specific choice of `𝒞`.

In particular, it suffices that `α` is a preorder and `𝒞` is a set of d-tuples in `α`.

## Specialization to existing K_F in `unifiedtheory`

In `UnifiedTheory.LayerA.KFComputable`, the explicit instance for `d = 2, m = 3` is

```lean
def KF_d2_m3 : Matrix (Fin 3) (Fin 3) ℚ :=
  !![1, 1, 0; 1, 1, 1; 0, 1, 1]
```

with chamber points `{(0, 1), (0, 2), (1, 2)}`. These are exactly the 2-element chains in `{0, 1, 2}` under the natural order. Setting `α := Fin 3`, `d := 2`, `𝒞 := chains-of-length-2`, the existing `KF_d2_m3` is the special case of the general construction.

The general construction also recovers the larger `[m]^d` cases in `KFComputable` and `KFd4Verified` for free — they are special cases of "K_F on chains of length `d` in a finite chain poset."

## Where the structure-dependence actually lives

The Hermitian-ness theorem is structure-free. The **physical** properties are not. Decomposed:

| Property | Generalization difficulty |
|---|---|
| `K_F.IsSymm` (= `IsHermitian` over ℝ; lifts to ℂ via the inclusion ℝ ↪ ℂ) | **Trivial in full generality.** One-line proof from the formula. |
| `K_F.spectralGap > 0` | **Needs graded structure.** Positivity follows from rank-level antichain decomposition; without grading there is no canonical decomposition to drive the bound. |
| `lim_{m → ∞} le/lo = (d+1)/(d-1)` | **Needs the chain-poset specifically.** Uses Catalan / chamber-polynomial machinery tied to the box poset `[m]^d`. |
| `charPoly(K_F) = (5λ−3)(150λ²−50λ+3)` for `d = 4` | **`[m]^d`-specific.** Uses the explicit Volterra singular-value ratios `σ_k = 2/((2k−1)π)`. |
| Functoriality (poset embedding `α ↪ β` induces `HermitianMat` embedding) | **Tractable for graded LFP** with rank-preserving embeddings. **Open** for arbitrary LFP. |

## Implication for the plan

The 3a / 3b split does not belong inside Phase 3 (Hermitian-ness). It belongs inside Phase 4 (physical properties). Updated phasing:

- **Phase 3** — `(KF P).IsHermitian` for `P : Type` with `[Preorder P]` and finite chain indexing. Fully general; the "free" generalization. ~1–2 weeks.

- **Phase 4a** (committed) — spectral gap, functoriality, positivity criterion on **graded locally finite posets**. ~2–3 weeks.

- **Phase 4b** (stretch) — push 4a to fully general locally finite. Stop here if it tar-pits.

The novel mathematical content has migrated from "Phase 3 generalization" to "Phase 4a spectral gap / functoriality." This is where the talk-grade material lives.

## Risks identified

1. **Reliance on Mathlib's `Matrix.IsHermitian` API for non-square indexing.** Mathlib expects `Matrix n n 𝕜` where `n : Type` is the index. Our indexing `𝒞 ⊆ α^d` becomes a `Fintype` over a subtype. Should work but the subtype boilerplate may be non-trivial.

2. **Determinant of `d × d` submatrix.** The formula `det(ζ[P, Q])` takes a determinant over `Fin d`, then sums over `𝒞 × 𝒞`. The sum-over-pairs is the natural definition of K_F as a `Matrix 𝒞 𝒞 ℝ`. No issue, but worth being explicit about the data layout.

3. **QuantumInfo dependency at Phase 2.** External library, not in Mathlib. Mitigation: Phase 1 stays Mathlib-native; if QuantumInfo churns, we still have a publishable result through `Matrix.IsHermitian` alone.

4. **Phase 4a spectral gap.** This is where actual difficulty is concentrated. The positivity argument for graded LFP requires identifying the rank decomposition explicitly; not yet pencil-clear that this is short.

## Decision implied

Proceed to Phase 1. The pencil exploration confirms Phase 3 is cheap, so we do not need to pre-commit Phase 3 effort. Phase 4a is where the budget goes.

## Phase 1 first deliverable

`KFHermitian/CubeCase.lean`:

```lean
theorem KF_d2_m3_isSymm : KF_d2_m3.IsSymm := by
  decide  -- or unfold + simp; the matrix is finite
```

Validation: zero sorry, zero custom axioms, compiles against Mathlib v4.28.0.

If this lemma takes more than two days to land, the plan has hidden friction and we re-scope.
