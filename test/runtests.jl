using Pkg
using SafeTestsets, Test
using CatalystNetworkAnalysis
using UnPack, SBMLImporter, SBMLToolkit

const GROUP = get(ENV, "GROUP", "All")

# QA (Aqua + JET) runs in an isolated environment (test/qa) so its tooling deps
# never enter the main test target's resolve. On Julia < 1.11 the [sources] table
# is ignored, so develop the package by path to test the PR branch code.
function activate_qa_env()
    Pkg.activate(joinpath(@__DIR__, "qa"))
    if VERSION < v"1.11.0-DEV.0"
        Pkg.develop(PackageSpec(path = dirname(@__DIR__)))
    end
    return Pkg.instantiate()
end

if GROUP == "All" || GROUP == "Core"
    @testset "CatalystNetworkAnalysis.jl" begin
        @time @safetestset "Concentration Robustness" begin
            include("ACR.jl")
        end
        @time @safetestset "Concordance Helpers" begin
            include("concordancehelpers.jl")
        end
        @time @safetestset "Siphons" begin
            include("siphons.jl")
        end
        @time @safetestset "Persistence" begin
            include("persistence.jl")
        end
        @time @safetestset "Deficiency One Algorithm" begin
            include("deficiencyone.jl")
        end
        @time @safetestset "Specific Stoichiometric Compatibility Class Functionality" begin
            include("specificscc.jl")
        end
        @time @safetestset "Linear programming utilities" begin
            include("lp_utils.jl")
        end
        @time @safetestset "Network Translation" begin
            include("network_translation.jl")
        end
    end
end

if GROUP == "QA"
    activate_qa_env()
    @time @safetestset "Quality Assurance" begin
        include("qa/qa.jl")
    end
end
