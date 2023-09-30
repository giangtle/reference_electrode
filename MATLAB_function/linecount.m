function n=linecount(fid)
n = 0;
fgetl(fid);
while ~feof(fid)
    fgetl(fid);
    n = n+1;
end

fclose(fid);
end
