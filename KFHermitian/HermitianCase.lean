/-
  KFHermitian/HermitianCase.lean — Phase 2: K_F is Hermitian (over ℂ) on [m]^d
  for small m, d.

  Lifts the rational K_F matrices from `KFHermitian.CubeCase` to ℂ via the
  inclusion ℚ ↪ ℂ. Uses `Matrix.IsSymm.isHermitian_complexLift` from
  `KFHermitian.Lift` as the bridge.

  This closes the implicit-Hermitian gap in the published `unifiedtheory`
  paper for the small cases. The K_F → eigenvalue chain in
  `UnifiedTheory.LayerA.FeshbachJ4` and `SpectralMassTheorem.lean` can now
  be re-typed through the canonical `Matrix.IsHermitian` interface.

  Zero sorry. Zero custom axioms.
-/

import KFHermitian.CubeCase
import KFHermitian.Lift

namespace KFHermitian.HermitianCase

open Matrix
open KFHermitian.CubeCase

/-! ## d = 2, m = 3 over ℂ -/

/-- The K_F matrix for d = 2, m = 3, lifted from ℚ to ℂ. -/
noncomputable def KF_d2_m3_C : Matrix (Fin 3) (Fin 3) ℂ :=
  KF_d2_m3.map (fun q : ℚ => (q : ℂ))

/-- **K_F on `[3]²` is Hermitian over ℂ.** -/
theorem KF_d2_m3_C_isHermitian : KF_d2_m3_C.IsHermitian :=
  KF_d2_m3_isSymm.isHermitian_complexLift

/-! ## d = 2, m = 4 over ℂ -/

/-- The K_F matrix for d = 2, m = 4, lifted from ℚ to ℂ. -/
noncomputable def KF_d2_m4_C : Matrix (Fin 6) (Fin 6) ℂ :=
  KF_d2_m4.map (fun q : ℚ => (q : ℂ))

/-- **K_F on `[4]²` is Hermitian over ℂ.** -/
theorem KF_d2_m4_C_isHermitian : KF_d2_m4_C.IsHermitian :=
  KF_d2_m4_isSymm.isHermitian_complexLift

/-! ## R-odd block on `[4]²` over ℂ -/

/-- The R-odd 2×2 block of K_F on `[4]²`, lifted from ℚ to ℂ.
    Eigenvalues over ℝ ⊂ ℂ are the golden ratio φ = (1+√5)/2 and 1 − φ. -/
noncomputable def KF_odd_block_d2_m4_C : Matrix (Fin 2) (Fin 2) ℂ :=
  KF_odd_block_d2_m4.map (fun q : ℚ => (q : ℂ))

/-- **The R-odd block on `[4]²` is Hermitian over ℂ.** -/
theorem KF_odd_block_d2_m4_C_isHermitian : KF_odd_block_d2_m4_C.IsHermitian :=
  KF_odd_block_d2_m4_isSymm.isHermitian_complexLift

end KFHermitian.HermitianCase
