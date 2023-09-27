function create_COMSOL_job(model, geometry, model_input, f, job_name)
% Step 2: update model parameters:
model = pass_input_to_COMSOL(model, geometry, model_input, f);
model.save(job_name);
% % Step 3: run COMSOL simulation and evaluate impedance response:
% model.sol('sol1').runAll;
% model.sol('sol2').runAll;
% 
% V = mphmean(model, {'V'}, 2, 'selection', 2, 'solnum', 'end');
% table1 = mphtable(model, 'tbl1');
% table1 = table1.data;
% V11 = -table1(:,2)+(1j)*table1(:,3);
end