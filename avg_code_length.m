function AVG_CODE_LENGTH = avg_code_length(propabiity, symbols)

AVG_CODE_LENGTH = 0;

for index = 1:length(propabiity)
    x = symbols(index);
    AVG_CODE_LENGTH = AVG_CODE_LENGTH + propabiity(index) * length(x{1});
end

end
