function write_struct_to_file(s, fid, ind_var)
for k=1:length(ind_var)
    fprintf(fid,'%.4e,',s.(ind_var{k})(1));
end
end
