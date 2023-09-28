function [V, V11] = extract_COMSOL_job_result(i)
out_file = strcat('comsol_job/',sprintf('%05d',i), ".mph");
model = mphopen(char(out_file));
V = mphmean(model, {'V'}, 2, 'selection', 2, 'solnum', 'end');
table1 = mphtable(model, 'tbl1');
table1 = table1.data;
V11 = -table1(:,2)+(1j)*table1(:,3);
end