function [param_names, unit_names, params_matrix] = read_input_file()
% Pass the unchanged input:
fid=fopen('./model_input/inputs.txt','r');
param_names = strsplit(fgetl(fid),"\t");
unit_names = strsplit(fgetl(fid),"\t");
fclose(fid);
params_matrix = readmatrix('./model_input/inputs.txt','NumHeaderLines',2);
end

