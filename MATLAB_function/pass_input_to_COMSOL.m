function model = pass_input_to_COMSOL(model, geometry, model_input, f)
% model original list of params:
param_ls = mphgetexpressions(model.param);
param_ls = param_ls(:,1);

% Pass geometry & model_input 's inputs:
model = pass_struct_input(geometry, model, param_ls);
model = pass_struct_input(model_input, model, param_ls);
% Pass frequency vector to model:
if ischar(f)
    model.study('std1').feature('stat2').set('plistarr', f);
else
    f = mat2str(f);
    f = f(2:end-1);
    model.study('std2').feature('param').set('plistarr', f);
end
end

function model = pass_struct_input(s, model, param_ls)
fn = fieldnames(s);
other = {'node', 'cell', 'channel', 'defect_3_r', 'fuel_flow_variance', 'phys_par_variance_1', 'phys_par_variance_2', 'phys_par_variance_3', 'phys_par_variance_4', 'phys_par_variance_5'};
for k=1:numel(struct2cell(s))
    if any(strcmp(param_ls, fn{k}))
        model.param.set( fn{k}, s.(fn{k}) );
    elseif any(strcmp(other, fn{k}))
    else
        fprintf(strcat('Parameter named \"', fn{k}, '\" is not in original COMSOL model.\n'));
    end
end
end