-- KFHermitian: the bridge from causal-poset data to Hermitian observables.
-- See README.md for the plan and KFHermitian/Pencil.md for the Phase 0 note.

-- Phase 1: cube case (KF on [m]^d for small m, d).
import KFHermitian.CubeCase

-- Phase 2: lift the cube cases to ℂ; prove IsHermitian.
import KFHermitian.HermitianCase

-- Phase 3: general K_F on tuples in any finite preorder; IsSymm and IsHermitian.
import KFHermitian.General

-- Phase 4 prelude: order-embedding functoriality and the eigenvalue API.
-- The full Phase 4a deliverables (spectral gap > 0, positivity criterion)
-- are described in KFHermitian/Phase4.md.
import KFHermitian.Functoriality
import KFHermitian.Eigenvalues
