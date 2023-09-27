function file_struct=read_model_input(model_input_field, model_input_text, line_i)
file_struct = struct();

value=textscan(model_input_text{line_i},'%f','delimiter',',','EmptyValue',nan);

for i=1:length(model_input_field)
    file_struct.(model_input_field{i})=value{1}(i);
end
end
