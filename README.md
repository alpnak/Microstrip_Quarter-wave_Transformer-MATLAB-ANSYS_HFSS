# Microstrip Quarter-Wave Impedance Transformer

Design, theoretical analysis, and full-wave EM simulation of a microstrip quarter-wave impedance transformer matching a 90 Ω load to a 50 Ω source at a 2 GHz center frequency, developed for the ELE 331 – Electromagnetic Field Theory course project (TOBB University of Economics and Technology, 2024–2025 Summer Term).

## Overview

A microstrip quarter-wave transformer (QWT) is a simple and widely used impedance-matching technique in RF/microwave circuit design. This project covers the complete design flow:

1. **Analytical design** — deriving the physical width (*W*) of the microstrip line from closed-form design equations (Pozar, *Microwave Engineering*).
2. **Line characterization** — computing characteristic impedance (*Z₀*), effective dielectric constant (*ε_eff*), phase constant (*β*), and attenuation constant (*α*).
3. **Distributed circuit model** — extracting per-unit-length *R*, *L*, *G*, *C* parameters and building the equivalent circuit.
4. **Theoretical validation** — computing the reflection coefficient |Γ| across the [1–3] GHz band and confirming |Γ| < 0.1 at the 2 GHz design frequency.
5. **Full-wave EM simulation** — modeling the transformer in ANSYS HFSS, sweeping [1–3] GHz, and comparing simulated *Z₀*, *ε_eff*, *β*, *α*, S₁₁, and S₂₁ against the theoretical results.

## Design Specifications

| Parameter | Value |
|---|---|
| Center frequency | 2 GHz |
| Source impedance (Z_s) | 50 Ω |
| Load impedance (Z_l) | 90 Ω |
| Substrate | Polyethylene (ε_r = 2.4, σ = 0) |
| Substrate height (h) | 600 µm |
| Conductor | Copper (σ = 5.8×10⁷ S/m) |
| Conductor thickness | 17 µm |
| Simulation band | 1–3 GHz |

## Key Results

| Quantity | Theoretical (MATLAB) | HFSS Simulation |
|---|---|---|
| Line width (W) | 1.0915 mm | 1.09 mm (modeled) |
| Z₀ | 67.08 Ω | 70.20 Ω |
| ε_eff | 1.9540 | 1.9251 |
| β | 58.553 rad/m | 58.159 rad/m |
| α | 7.967×10⁻² Np/m | 0.0238 Np/m |
| \|Γ\| @ 2 GHz | ≪ 0.1 | \|S₁₁\| ≈ −56 dB @ 1.985 GHz |

Both analytical and simulated results confirm that the transformer achieves a well-matched condition at the target frequency, with S₁₁ far below the −20 dB (|Γ| < 0.1) requirement.

## Repository Contents

```
.
├── mikroserit.m                     # MATLAB script: line design, Z0/ε_eff/β/α, R/L/G/C, |Γ| vs. frequency
├── dalga.aedt                       # ANSYS HFSS project file (3D EM model, ports, frequency sweep)
├── ELE331_proje_202425.pdf          # Original project assignment/specification
├── alperen-enis_mikroserit.pdf      # Full project report (design, derivations, HFSS results, conclusions)
└── README.md
```

## Tools Used

- **MATLAB** — analytical design equations, distributed-parameter extraction, reflection coefficient calculation and plotting.
- **ANSYS HFSS (Student Edition)** — 3D full-wave electromagnetic simulation using wave ports and modal S-parameter analysis.

## Method Summary

- The line width is found from Pozar's standard microstrip synthesis equations (W/h < 2 and W/h ≥ 2 cases), solved for the required Z₀ = √(Z_s·Z_l).
- Effective dielectric constant, phase velocity, and effective wavelength follow directly from the geometry and substrate properties; the physical length is set to λ_eff/4.
- Distributed R, L, G, C are derived from skin-effect surface resistance, Z₀, and phase velocity, and combined into a complex propagation constant γ = α + jβ.
- The input impedance looking into the terminated line, Z_in(f), is swept over 1–3 GHz to compute |Γ(f)| = |(Z_in − Z_s)/(Z_in + Z_s)|, verifying narrowband matching around 2 GHz.
- The same geometry is reproduced in HFSS with wave ports (chosen over lumped ports for reliable modal propagation-parameter extraction), and S-parameter sweeps are compared against the MATLAB predictions.

## Authors

- Alperen Nakiboğlu — 211201062
- Enis Hacışevki — 211201058

TOBB University of Economics and Technology, Department of Electrical and Electronics Engineering
ELE 331 – Electromagnetic Field Theory, Summer 2024–2025

## References

1. D. M. Pozar, *Microwave Engineering*, 3rd ed., John Wiley & Sons, 2009, Ch. 3, p. 143.
2. D. M. Pozar, *Microwave Engineering*, 3rd ed., John Wiley & Sons, 2009, Ch. 4, p. 174.
3. Ansys Academic Resource Center, "HFSS Getting Started: LE6 Port Basics," 2020.
4. [ANSYS Electronics Desktop Student Edition](https://www.ansys.com/academic/students/ansys-electronics-desktop-student)
