function [param_names, unit_names, params_matrix] = read_input_file(file_name)
arguments
    file_name char = './model_input/inputs.txt'
end
% Pass the unchanged input:
fid=fopen(file_name,'r');
param_names = strsplit(fgetl(fid),"\t");
unit_names = strsplit(fgetl(fid),"\t");
fclose(fid);
params_matrix = readmatrix('./model_input/inputs.txt','NumHeaderLines',2);
end

