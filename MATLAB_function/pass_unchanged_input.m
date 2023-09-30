function pass_unchanged_input(model)
% Pass the unchanged input:
fid=fopen('./model_input/unchanged_inputs.txt','r');
param_names = strsplit(fgetl(fid),"\t");
unit_names = strsplit(fgetl(fid),"\t");
values = strsplit(fgetl(fid),"\t");
for i=1:length(param_names)
    model.param.set(param_names{i}, append(values{i},"[",unit_names{i},"]"));
end
fclose(fid);
end

