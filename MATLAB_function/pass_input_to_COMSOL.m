function model = pass_input_to_COMSOL(model, param_names, unit_names, params)
for i=1:length(param_names)
    NAME = param_names{i};
    if length(NAME)>6
        if strcmp(NAME(1:6),'log10_')
            NAME = NAME(7:end);
            params(i) = 10^params(i);
        end
    end
    model.param.set(NAME, append(string(params(i)),"[",unit_names{i},"]"));
end
end