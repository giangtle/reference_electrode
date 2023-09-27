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
EIS_dir = strcat(current_dir, '/EIS_model');
matlab_fcn_dir = strcat(current_dir, '/matlab_fcn');
addpath(EIS_dir);
addpath(matlab_fcn_dir);

% Determine looping values/number of simulation:
fid=fopen('./simulation_input/model_input.csv','r');
model_input_no = linecount(fid);

% Determine what the independent variables are:
fid=fopen('./simulation_input/ind_var_model_input.csv','r');
ind_var_model_input = read_file_to_list_of_ind_var(fid);

% Clear ./matlab/simulation_result/ directory before starting simulation:
!bash bash_script/clean_sim_dir.sh

% Read input files to provide geometry and model_input information:
fid=fopen('./simulation_input/geometry.csv','r');
geometry = read_geometry_file_to_struct(fid);
fid=fopen('./simulation_input/model_input.csv','r');
[model_input_field, model_input_text]=read_model_input_file(fid, model_input_no);
fid=fopen('./simulation_input/freq_vec.csv','r');
f=read_freq_file_to_vector(fid);

% Clear memory of unnecessary variables
clearvars -except model_input_no old_path geometry ind_var_model_input model_input_field model_input_text f

% Set up loop count for parallel computing:
batch_size = 50;
loop_no = floor(model_input_no/batch_size);

% Counting line in simulation result & determine where to pick up
filename = './simulation_result/all.txt';
if isfile(filename)
    fid=fopen(filename,'r');
    checkpoint = linecount(fid)+1;
else
    checkpoint = 0;
end

% get cell #: 

% Using the right defect/normal model name:
model_name = 'delaminated_noGUI.mph';
model = mphopen(strcat('EIS_model/', model_name));
cell = geometry.cell;

tic
% Step 1: create model handle from given model name:

% Start simulation:
for batch_i=(checkpoint/batch_size +1):loop_no
    model_input_begin=(batch_i-1)*batch_size+1;
    model_input_end=batch_i*batch_size;
    for i = model_input_begin:model_input_end
        model_input_1 = read_model_input(model_input_field, model_input_text, i);
        filename = strcat('./simulation_result/',sprintf('%05d',i),'.temp');
        fid=fopen(filename,'w');
        write_struct_to_file(model_input_1,fid,ind_var_model_input);
        % First to compute normal EIS:
        [geometry_n, model_input_n] = pristine_cell_physical_parameters(model_input_1);
        [Vn, V11n] = model_1Dcell_EIS(model_input_n, geometry_n, f);
        V = Vn*cell; V11=V11n*cell;
        write_EIS_result_to_file(fid,V,V11);
        fprintf(fid,',');
        % Then compute defect EIS:
        try
            [Vd, V11d] = compute_EIS_from_COMSOL(model, geometry, model_input_1, f);
            [Vo, V11o] = model_1Dcell_EIS(model_input_1, geometry, f);
            V = Vo*(cell-1)+Vd; V11 = V11o*(cell-1)+V11d;
        catch
            V=0; V11=0*V11n;
        end
        write_EIS_result_to_file(fid,V,V11);
        fprintf(fid,'\n');
        fclose(fid);
    end
    !bash bash_script/compile_temp_file.sh
    !bash bash_script/clean_sim_dir.sh
end

model_input_begin=loop_no*batch_size+1;
for i = model_input_begin:model_input_no
    model_input_1 = read_model_input(model_input_field, model_input_text, i);
    filename = strcat('./simulation_result/',sprintf('%05d',i),'.temp');
    fid=fopen(filename,'w');
    write_struct_to_file(model_input_1,fid,ind_var_model_input);
    % First to compute normal EIS:
    [geometry_n, model_input_n] = pristine_cell_physical_parameters(model_input_1);
    [Vn, V11n] = model_1Dcell_EIS(model_input_n, geometry_n, f);
    V = Vn*cell; V11=V11n*cell;
    write_EIS_result_to_file(fid,V,V11);
    fprintf(fid,',');
    % Then compute defect EIS:
    try
        [Vd, V11d] = compute_EIS_from_COMSOL(model, geometry, model_input_1, f);
        [Vo, V11o] = model_1Dcell_EIS(model_input_1, geometry, f);
        V = Vo*(cell-1)+Vd; V11 = V11o*(cell-1)+V11d;
    catch
        V=0; V11=0*V11n;
    end
    write_EIS_result_to_file(fid,V,V11);
    fprintf(fid,'\n');
    fclose(fid);
end
!bash bash_script/compile_temp_file.sh
!bash bash_script/clean_sim_dir.sh

% Restore old Matlab path:
path(old_path);

toc