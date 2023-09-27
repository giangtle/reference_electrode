% Add comsol path:
addpath('/Applications/COMSOL56/Multiphysics/mli')

% Start comsol server:
try
    mphstart
catch
    
end

import com.comsol.model.*
import com.comsol.model.util.*

% Add function path:
old_path = path;
current_dir = pwd;
matlab_fcn_dir = strcat(current_dir, '/MATLAB_function');
addpath(matlab_fcn_dir);

% Open COMSOL model
model_name = '2RE_EIS_nondimensional_CPE.mph';
model = mphopen(strcat('COMSOL/', model_name));
