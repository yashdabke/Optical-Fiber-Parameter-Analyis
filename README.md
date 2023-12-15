# Comprehensive Simulation of Nonlinear Optical Pulse Propagation in Graded-Index Fibers with Polarization Effects

## Overview

This MATLAB-based project delves into the intricate simulation of optical pulse propagation in optical fibers, specifically exploring the Nonlinear Schrödinger Equation (NLSE) with polarization effects. The simulation provides a comprehensive study of optical pulse behaviors, encompassing nonlinear phenomena, polarization intricacies, and the impact of amplification within the context of optical fiber communication systems.

## Key Features

1. **Fiber Parameters:**
   - Core radius, operating wavelength, numerical aperture, fiber length, amplification length, and speed of light are defined.

2. **Graded Refractive Index Profile:**
   - The graded refractive index profile is defined based on the core radius and refractive indices of the core and cladding.

3. **Pulse Parameters:**
   - Bit rate, pulse duration, number of bits, and symbol rate are specified.

4. **Pulse Shaping:**
   - A Gaussian pulse shape is generated in the time domain.

5. **Narrowband Filtering:**
   - A narrowband filter is applied to the pulse in the frequency domain.

6. **Propagation through Fiber (NLSE):**
   - The NLSE is solved numerically for pulse propagation through the fiber, considering polarization effects and amplification.

7. **Plotting:**
   - Various plots are generated to visualize the graded refractive index profile, filtered pulse shape, pulse propagation through fiber with polarization, frequency domain representation, and spectral phase/intensity before and after propagation.

8. **Additional Results and Validation:**
   - Displayed pulse and amplification parameters, filter parameters, and performed validation by comparing theoretical and simulated pulse broadening.

9. **NLSE Function Definition:**
   - The NLSE function (`nlse`) is defined to represent the differential equations governing pulse propagation, including polarization effects and amplification.

## Usage

1. **Customization:**
   - Users can modify parameters in the MATLAB script (`main.m`) to tailor the simulation to specific scenarios or experiments.

2. **Execution:**
   - Run the MATLAB script to initiate the simulation.

## File Structure

- `main.m`: Main MATLAB script for the simulation.
- `nlse.m`: Function defining the NLSE and polarization effects.
- `LICENSE`: MIT License file.

## Dependencies

- MATLAB environment is required to run the simulation.
