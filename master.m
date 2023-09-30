% COMSOL Application path
comsol_path = "/Applications/COMSOL56/Multiphysics/bin/comsol";
% Add COMSOL path:
addpath('/Applications/COMSOL56/Multiphysics/mli')

% Start COMSOL server:
try
    mphstart
catch
end

import com.comsol.model.*
import com.comsol.model.util.*

% Add function path:
old_path = path;
current_dir = pwd;
matlab_fcn_dir = append(current_dir, '/MATLAB_function');
addpath(matlab_fcn_dir);

% Open COMSOL model:
model_name = 'EIS_model.mph';
model = mphopen(append('COMSOL/', model_name));

% Pass the unchanged input:
pass_unchanged_input(model);

% Get the model input:
[param_names, unit_names, params_matrix] = read_input_file();
model_input_no = length(params_matrix(:,1));

% Set up loop count for parallel computing:
batch_size = 4;
loop_no = floor(model_input_no/batch_size);

% Counting line in simulation result & determine where to pick up
filename = './simulation_result/all.txt';
if isfile(filename)
    fid=fopen(filename,'r');
    checkpoint = linecount(fid)+1;
else
    checkpoint = 0;
end

% Start timing clock
tic
% Clear ./matlab/simulation_result/ directory before starting simulation:
!bash bash_script/clean_sim_dir.sh

% Start simulation:
for batch_i=(checkpoint/batch_size +1):loop_no+1
    % Open COMSOL model:
    model_name = 'EIS_model.mph';
    model = mphopen(append('COMSOL/', model_name));

    model_input_begin = (batch_i-1)*batch_size+1;
    model_input_end = min(batch_i*batch_size, model_input_no);
    % Step 1: create shell file to run batch simulation
    fid=fopen("./COMSOL_job/master.sh",'w');
    for i = model_input_begin:model_input_end
        params = params_matrix(i,:);
        job_name = append(current_dir,'/COMSOL_job/',sprintf('%05d',i),".mph");
        % Then create COMSOL job:
        temp_model = pass_input_to_COMSOL(model, param_names, unit_names, params);
        temp_model.save(job_name)
        fprintf(fid, append(comsol_path,' -np 1 batch -inputfile ',job_name, ' -batchlog &\n'));
    end
    fprintf(fid, "wait\n");
    fclose(fid);
    
    % Step 2: run batch simulation shell script
    system("./COMSOL_job/master.sh");
    
    % Step 3: retreive results and write input and results into .temp files
    for i = model_input_begin:model_input_end
        params = params_matrix(i,:);
        job_name = convertStringsToChars(append('COMSOL_job/',sprintf('%05d',i),".mph"));
        file_name = append('./simulation_result/',sprintf('%05d',i),'.temp');
        fid=fopen(file_name,'w');
        %Write params:
        fprintf(fid,'%g\t',params);
        %Write results:
        temp_model = mphopen(job_name);
        % Get psi value
        table2 = mphtable(temp_model, 'tbl2');
        table2 = table2.data;
        fprintf(fid,'%.4g\t', [table2(1,2); table2(1,3)]);
        % Get psi11 value
        table1 = mphtable(temp_model, 'tbl1');
        table1 = table1.data;
        psi_ref_o1 = table1(:,2).';
        psi_ref_o2 = table1(:,3).';
        i_Sigma = table1(:,4).';
        fprintf(fid,'%.4g+%.4gj\t',[real(i_Sigma);imag(i_Sigma)]);
        fprintf(fid,'%.4g+%.4gj\t',[real(psi_ref_o1);imag(psi_ref_o1)]);
        fprintf(fid,'%.4g+%.4gj\t',[real(psi_ref_o2);imag(psi_ref_o2)]);
        fprintf(fid,'\n');
        fclose(fid);
    end
    !bash bash_script/compile_temp_file.sh
    !bash bash_script/clean_sim_dir.sh
    !bash bash_script/clean_job_dir.sh
end
% Restore old Matlab path:
path(old_path);

toc
% End timing clock
