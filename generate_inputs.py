#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 28 11:32:15 2023

@author: giangle
"""

from SALib.sample import sobol
from numpy import log10
import numpy as np

unchanged_inputs = {
    "w_elec": ([1.342],"cm"),
    "phi_star": ([30.42], "mV"),
    }

inputs = {
    "L": ([20, 200],"um"),
    "lambda": ([5, 40], "1"),
    ##############################################################
    # If using COMSOL_model/iV_model.mph, comment out the lines  #
    # below, i.e. no gamma, beta, chi, omega_bar inputs          #
    "gamma": ([7, 17], "1"),
    "beta": ([0.75, 1], "1"),
    "omega_bar": ([1.0E-4, 1.0E-2], "1"),
    "chi": ([1.0E-2, 1.0E0], "1"),
    ##############################################################
    "k": ([5, 25], "S/m"),
    "kappa_1": ([1.0E-5, 1.0E-2], "1"),
    "kappa_2": ([1.0E1, 1.0E3], "1"),
    }

#log adjustment
corrected_inputs = dict()
for k,v in inputs.items():
    bounds, unit = v
    if len(bounds) == 2:
        if bounds[1]/bounds[0] >99:
            corrected_inputs["log10_"+k] = ([log10(bounds[0]), log10(bounds[1])], unit)
        else:
            corrected_inputs[k] = (bounds, unit)
    else:
        assert("Bound list of parameter {} does not contain 2 elements".format(k))

# make a list of sobol sampling
problem = {
    'num_vars' : len(corrected_inputs),
    'names' : corrected_inputs.keys(),
    'bounds' : [bounds for bounds, _ in corrected_inputs.values()]
    }

# Generate samples
param_values = sobol.sample(problem, 2**9)

# Save inputs to text file
file_name = "./model_input/unchanged_inputs.txt"
with open(file_name, "w") as f:
    f.write("\t".join(unchanged_inputs.keys())+"\n")
    f.write("\t".join([unit for _, unit in unchanged_inputs.values()])+"\n")
    f.write("\t".join([str(v[0]) for v, _ in unchanged_inputs.values()])+"\n")
    
file_name = "./model_input/inputs.txt"
with open(file_name, "w") as f:
    f.write("\t".join(corrected_inputs.keys())+"\n")
    f.write("\t".join([unit for _, unit in corrected_inputs.values()])+"\n")
    np.savetxt(f, param_values, fmt="%.3g", delimiter="\t")