function write_EIS_result_to_file(fid, V, V11)
fprintf(fid, '%.4f', V);
extract_mat= [-real(V11), imag(V11)];
fprintf(fid,',%.4e,%.4e', extract_mat.');
end
