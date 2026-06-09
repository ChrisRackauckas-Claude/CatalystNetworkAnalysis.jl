using CatalystNetworkAnalysis, Aqua, JET
using Test

@testset "Aqua" begin
    Aqua.test_all(CatalystNetworkAnalysis)
end

@testset "JET" begin
    JET.test_package(CatalystNetworkAnalysis; target_defined_modules = true)
end
