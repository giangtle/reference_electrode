# reference_electrode

The [folder](/COMSOL/)(/COMSOL/) contains several dimensionless COMSOL models to simulate the response of reference electrode with a misaligned anode-cathode (both anode overhang and cathode overhang). Though the parameters are relevant for PEM electrolysis, minor modification can be made to convert it to PEM fuel cell or solid oxide fuel cell. The detail of model is described here in my [thesis](https://digital.lib.washington.edu/researchworks/handle/1773/51107) - Simulation Informed Machine Learning Interpretation of Electrochemical Measurements.

1. **iV_model.mph:** 4-electrode polarization curves.
2. **EIS_model_current_control.mph:** 4-electrode EIS with current input.
3. **EIS_model_voltage_control.mph:** 4-electrode EIS with voltage input.

The involved physics are extensively explained in several previous publications:
* [He & Nguyen, 2004](http://dx.doi.org/10.1149/1.1634272) - Edge Effects on Reference Electrode Measurements in PEM Fuel Cells.
* [Adler et al, 2002](http://dx.doi.org/10.1149/1.1467368) - Reference Electrode Placement in Thin Solid Electrolytes.
* [Ender et al, 2011](http://dx.doi.org/10.1149/2.100202jes) - Analysis of Three-Electrode Setups for AC-Impedance Measurements on Lithium-Ion Cells by FEM simulations.

The dimensionless model details will be updated once ready!
