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

| Phase | Wks | Setting | Deliverable |
|---|---|---|---|
| 0 | done | n/a | Pencil-exploration note: [`KFHermitian/Pencil.md`](KFHermitian/Pencil.md). Confirms the symmetry argument is structure-free; relocates the 3a/3b split from Phase 3 (Hermitian-ness) to Phase 4 (physical properties). |
| 1 | 1–2 | `[m]^d` concrete | `KF_d2_m3.IsSymm` and analogues for `d = 3, 4`. Mathlib-native; no QuantumInfo dep. |
| 2 | 1–2 | `[m]^d` concrete | Lift to ℂ. `IsHermitian`. Wrap as `HermitianMat`. Re-derive γ₄ = ln(5/3) through `HermitianMat.eigenvalues` rather than ad-hoc char-poly. |
| 3 | 1–2 | fully general locally finite poset | `(KF P).IsHermitian` for `P : Type` with `[Preorder P]` and finite chain indexing. The "free" generalization. |
| 4a | 2–3 | graded locally finite poset (committed) | Spectral gap > 0; functoriality under rank-preserving embeddings; positivity criterion. **The novel-mathematical-content phase.** |
| 4b | 1–2 | fully general LFP (stretch) | Push 4a to non-graded posets. Stop here if it tar-pits — 4a is a strong result on its own. |

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
