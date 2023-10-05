function extract_COMSOL_job_result(fid, model_name, temp_model)
if strcmp(model_name, 'EIS_model.mph')
    % Get psi value
    table2 = mphtable(temp_model, 'tbl2');
    table2 = table2.data;
    % Get steady state value in order: i_Sigma, psi_ref_o1, psi_ref_o2
    fprintf(fid,'%.4g\t', [table2(1,4); table2(1,2); table2(1,3)]);
    % Get harmonic value
    table1 = mphtable(temp_model, 'tbl1');
    table1 = table1.data;
    psi11_ref_o1 = table1(:,2).';
    psi11_ref_o2 = table1(:,3).';
    i_Sigma11 = table1(:,4).';
    fprintf(fid,'%.4g+%.4gj\t',[real(i_Sigma11);imag(i_Sigma11)]);
    fprintf(fid,'%.4g+%.4gj\t',[real(psi11_ref_o1);imag(psi11_ref_o1)]);
    fprintf(fid,'%.4g+%.4gj\t',[real(psi11_ref_o2);imag(psi11_ref_o2)]);
elseif strcmp(model_name,'iV_model.mph')
    % Get gamma & psi value
    table1 = mphtable(temp_model, 'tbl1');
    table1 = table1.data;
    gamma = table1(:,4).';
    psi_ref_o1 = table1(:,2).';
    psi_ref_o2 = table1(:,3).';
    fprintf(fid,'%.4g\t',gamma);
    fprintf(fid,'%.4g\t',psi_ref_o1);
    fprintf(fid,'%.4g\t',psi_ref_o2);
else
    error(append("Invalid model name. No model named ", model_name, ".\n"))
end