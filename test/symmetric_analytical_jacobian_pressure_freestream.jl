

@testset "Test symmetric_analytical_jacobian_position for point vortices with real freestream" begin

    atol = 1000*eps()

    Nv = 10
    Nx = 3*Nv

    x = rand(Nx)
    x0 = deepcopy(x)

    xsensors = collect(-2.0:0.5:10)
    sensors = complex(xsensors)
    Ny = length(sensors)
#     U = 0.0 + 0.0*im
    U = randn() + 0.0*im

    #     U = randn(ComplexF64)
    freestream = Freestream(U);

    config = let Nv = Nv,
             U = U,
             Δt = 1e-3, δ = 5e-2
            VortexConfig(Nv, U, Δt, δ; body=LowRankVortex.OldFlatWall)
    end

    config_symm = let Nv = Nv,
             U = U,
             Δt = 1e-3, δ = 5e-2
            VortexConfig(Nv, U, Δt, δ)
    end

    sys = state_to_lagrange(x, config; isblob = false)
    @test typeof(sys[1][1])<:Vortex.Point{Float64, Float64}

    sys = vcat(sys...)

    dpdz, dpdzstar = analytical_jacobian_position(sensors, sys, freestream, 0.0)

    dpdzsym, dpdzstarsym = symmetric_analytical_jacobian_position(xsensors, sys, freestream, 0.0)

    @test isapprox(dpdz, dpdzsym, atol = atol)
    @test isapprox(dpdzstar, dpdzstarsym, atol = atol)
end


@testset "Test symmetric_analytical_jacobian_position for regularized vortices with real freestream" begin

    atol = 1000*eps()

    Nv = 10
    Nx = 3*Nv

    x = rand(Nx)
    x0 = deepcopy(x)

    xsensors = collect(-2.0:0.5:10)
    sensors = complex(xsensors)
    Ny = length(sensors)
#     U = 0.0 + 0.0*im
    U = randn() + 0.0*im

    #     U = randn(ComplexF64)
    freestream = Freestream(U);

    config = let Nv = Nv,
             U = U,
             Δt = 1e-3, δ = 5e-2
            VortexConfig(Nv, U, Δt, δ; body=LowRankVortex.OldFlatWall)
    end

    sys = state_to_lagrange(x, config; isblob = true)
    @test typeof(sys[1][1])<:Vortex.Blob{Float64, Float64}

    sys = vcat(sys...)

    dpdz, dpdzstar = analytical_jacobian_position(sensors, sys, freestream, 0.0)

    dpdzsym, dpdzstarsym = symmetric_analytical_jacobian_position(xsensors, sys, freestream, 0.0)

    @test isapprox(dpdz, dpdzsym, atol = atol)
    @test isapprox(dpdzstar, dpdzstarsym, atol = atol)
end



@testset "Test symmetric_analytical_jacobian_strength for point vortices with real freestream" begin

    atol = 1000*eps()

    Nv = 10
    Nx = 3*Nv

    x = rand(Nx)
    x0 = deepcopy(x)

    xsensors = collect(-2.0:0.5:10)
    sensors = complex(xsensors)
    Ny = length(sensors)

    U = randn() + 0.0*im
    freestream = Freestream(U);

    config = let Nv = Nv,
             U = U,
             Δt = 1e-3, δ = 5e-2
            VortexConfig(Nv, U, Δt, δ; body=LowRankVortex.OldFlatWall)
    end

    sys = state_to_lagrange(x, config; isblob = false)
    @test typeof(sys[1][1])<:Vortex.Point{Float64, Float64}

    sys = vcat(sys...)

    dpdS, dpdSstar = analytical_jacobian_strength(sensors, sys, freestream, 0.0)

    dpdSsym, dpdSstarsym = symmetric_analytical_jacobian_strength(xsensors, sys, freestream, 0.0)

    @test isapprox(dpdS, dpdSsym, atol = atol)
    @test isapprox(dpdSstar, dpdSstarsym, atol = atol)
end

@testset "Test symmetric_analytical_jacobian_strength for regularized vortices with real freestream" begin

    atol = 1000*eps()

    Nv = 10
    Nx = 3*Nv

    x = rand(Nx)
    x0 = deepcopy(x)

    xsensors = collect(-2.0:0.5:10)
    sensors = complex(xsensors)
    Ny = length(sensors)

    U = randn() + 0.0*im
    freestream = Freestream(U);

    config = let Nv = Nv,
             U = U,
             Δt = 1e-3, δ = 5e-2
            VortexConfig(Nv, U, Δt, δ; body=LowRankVortex.OldFlatWall)
    end

    sys = state_to_lagrange(x, config; isblob = true)
    @test typeof(sys[1][1])<:Vortex.Blob{Float64, Float64}

    sys = vcat(sys...)

    dpdS, dpdSstar = analytical_jacobian_strength(sensors, sys, freestream, 0.0)

    dpdSsym, dpdSstarsym = symmetric_analytical_jacobian_strength(xsensors, sys, freestream, 0.0)

    @test isapprox(dpdS, dpdSsym, atol = atol)
    @test isapprox(dpdSstar, dpdSstarsym, atol = atol)
end

@testset "Test routine symmetric_analytical_jacobian_pressure with real freestream" begin
    atol = 1000*eps()

    Nv = 10
    Nx = 3*Nv

    x = rand(Nx)
    x0 = deepcopy(x)

    xsensors = collect(-2.0:0.5:10)
    sensors = complex(xsensors)
    Ny = length(sensors)

    U = randn() + 0.0*im
    freestream = Freestream(U);

    config = let Nv = Nv,
             U = U,
             Δt = 1e-3, δ = 5e-2
            VortexConfig(Nv, U, Δt, δ; body=LowRankVortex.OldFlatWall)
    end

    sys = state_to_lagrange(x, config; isblob = true)
    @test typeof(sys[1][1])<:Vortex.Blob{Float64, Float64}

    sys = vcat(sys...)

    Jfull = analytical_jacobian_pressure(sensors, sys, freestream, 0.0)
    Jsymfull = symmetric_analytical_jacobian_pressure(xsensors, sys, freestream, 0.0)

    @test isapprox(Jfull, Jsymfull, atol = atol)

    # Test only on a subset of the vortices

    J = analytical_jacobian_pressure(sensors, sys, freestream, 1:Nv, config.state_id, 0.0)
    Jsym = symmetric_analytical_jacobian_pressure(xsensors, sys, freestream, 1:Nv, config.state_id, 0.0)

    @test isapprox(J[:,1:3*Nv], Jfull[:,1:3*Nv], atol = atol)
    @test isapprox(Jsym[:,1:3*Nv], Jfull[:,1:3*Nv], atol = atol)

    @test norm(J[:,3*Nv+1:end]) < atol
    @test norm(Jsym[:,3*Nv+1:end]) < atol
end
