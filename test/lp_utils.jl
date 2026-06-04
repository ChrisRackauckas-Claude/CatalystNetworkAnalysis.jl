# Testing of the linear programming utilities in CatalystNetworkAnalysis

import CatalystNetworkAnalysis as C
using StableRNGs

# Test that matrices with positive element in their image space are identified.
let
    rng = StableRNG(1234)

    # A full-rank matrix has image space all of Rᵐ, so it admits a positive solution.
    # `rand(1:10, ...)` is entrywise positive, so this is true unconditionally.
    a = rand(rng, 1:10, 10, 10)
    @test C.has_positive_solution(a)

    # An entrywise-negative random 10×10 matrix is full rank with overwhelming
    # probability; full rank ⟹ image space is Rᵐ ⟹ a positive solution exists.
    # The seed above pins the draw so this is deterministic.
    b = -rand(rng, 1:10, 10, 10)
    @test C.has_positive_solution(b)

    # `[1 -1; -1 1]` has column space spanned by `[1, -1]`; every image vector has
    # entries summing to zero, so it can never dominate `ones`. ⟹ no positive solution.
    a = [1 -1; -1 1]
    @test !C.has_positive_solution(a)

    # Columns of this 4×4 matrix sum to zero, so every image vector's entries sum to
    # zero and can never dominate `ones` ⟹ no strictly-positive solution. The zero
    # vector is a valid non-negative solution, so the `nonneg` variant is satisfied.
    b = [
        -3 1 1 1;
        1 -3 1 1;
        1 1 -3 1
        1 1 1 -3
    ]
    @test !C.has_positive_solution(b)
    @test C.has_positive_solution(b, nonneg = true)
end

# Testing that extreme rays are properly identified.
let
end

# Testing elementary flux modes are found.
let
end
