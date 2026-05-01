# kf-hermitian-lean

Lean 4 formalization of the bridge from causal-poset data to Hermitian observables, via the K_F operator.

**Status:** scaffold. Phase 0 (pencil exploration) complete; Phase 1 not started.

## What this repository proves (target)

For any preorder `α` with a finite chain-indexed support `𝒞 ⊆ α^d`, the **K_F operator**

```
K_F : 𝒞 × 𝒞 → ℝ
K_F(P, Q) := det(ζ[P, Q]) + det(ζ[Q, P]) − δ_{P,Q}
```

where `ζ(i, j) = 1 if i ≤ j else 0` is the order kernel, satisfies `K_F.IsHermitian`. The bridge result is then phrased through QuantumInfo's `HermitianMat n ℂ`, exposing K_F as a bona-fide Hermitian observable in the algebra-of-observables sense — with the spectral gap, eigenvalue-ratio, and functoriality results following on graded locally finite posets.

This is the **constructor** that takes order-theoretic data and produces a Hermitian observable. It is the load-bearing object missing from the [`unifiedtheory`](https://github.com/tomdif/unifiedtheory) program: K_F's symmetry is currently used implicitly in the K_F → eigenvalue → γ₄ → Higgs-mass chain but never typed through the canonical `Matrix.IsHermitian` interface. Closing that gap is the goal of this repo.

## Why a separate repo

- **Audit trail and citability.** Standalone repo + Zenodo DOI = citable artifact for the `unifiedtheory` paper and any successor.
- **Hermetic build.** Phases 1–3 are Mathlib-native; Phase 2 onwards adds a `QuantumInfo` dependency that we do not want propagating into `unifiedtheory`'s build graph.
- **Upstream target.** If `QuantumInfo` maintainers want to absorb the bridge, a small focused repo is far easier to fork than a 345-file physics monorepo.

## Plan

| Phase | Status | Setting | Deliverable |
|---|---|---|---|
| 0 | ✅ committed | n/a | Pencil-exploration note: [`KFHermitian/Pencil.md`](KFHermitian/Pencil.md). |
| 1 | ✅ committed (unverified build) | `[m]^d` concrete | `KF_d2_m3.IsSymm`, `KF_d2_m4.IsSymm`, `KF_odd_block_d2_m4.IsSymm`. See [`KFHermitian/CubeCase.lean`](KFHermitian/CubeCase.lean). |
| 2 | ✅ committed (unverified build) | `[m]^d` concrete | Lift to ℂ; `IsHermitian` for the three cube matrices. See [`KFHermitian/HermitianCase.lean`](KFHermitian/HermitianCase.lean) + lift lemma in [`KFHermitian/Lift.lean`](KFHermitian/Lift.lean). |
| 3 | ✅ committed (unverified build) | any finite preorder | `K_F_matrix_C_isHermitian`: K_F on `(Fin d → α) × (Fin d → α)` is Hermitian over ℂ. See [`KFHermitian/General.lean`](KFHermitian/General.lean). **The headline structural result.** |
| 4a | 📋 planned | graded locally finite poset | Spectral gap > 0; functoriality under rank-preserving embeddings; positivity criterion. See [`KFHermitian/Phase4.md`](KFHermitian/Phase4.md). **The novel-mathematical-content phase.** |
| 4b | 📋 stretch | fully general LFP | Push 4a to non-graded posets. Stop here if it tar-pits. |

> **Verification status:** Phases 1–3 are written but not yet verified by `lake build`. The proofs are short and follow standard Mathlib idioms (`ext + fin_cases + rfl` for finite-matrix symmetry, `simp + rw + ring` for the general K_F symmetry), but tactic syntax can drift between Mathlib versions. First action on a fresh checkout is `lake update && lake build`. Any tactic adjustments will be one-line fixes.

Total target: 6–10 weeks.

## Triggers for going public-with-talk

- **Phase 1**: not workshop-grade. A single concrete K_F is symmetric.
- **Phase 3**: a respectable Lean exercise but the result is "morally easy" once stated correctly. Still not workshop-grade.
- **Phase 4a**: workshop-grade. Proving a positive spectral gap on graded locally finite posets from purely combinatorial data is where the genuinely novel content lives. Pitch QPL / Lean Together / FoMM after Phase 4a, not before.

## Build

Toolchain matches [`unifiedtheory`](https://github.com/tomdif/unifiedtheory) for downstream import compatibility:

```
leanprover/lean4:v4.28.0
```

```bash
lake build
```

(Phase 1 has no Lean files yet.)

## Companion repositories

- [`tomdif/unifiedtheory`](https://github.com/tomdif/unifiedtheory) — the framework that defines K_F and uses it implicitly.
- [`tomdif/causal-algebraic-geometry-lean`](https://github.com/tomdif/causal-algebraic-geometry-lean) — companion algebraic foundation.
- [`Timeroot/Lean-QuantumInfo`](https://github.com/Timeroot/Lean-QuantumInfo) — supplies `HermitianMat n 𝕜` (Phase 2 dependency).

## License

MIT.
