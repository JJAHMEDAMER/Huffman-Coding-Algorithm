function INFO = info(probability)
    INFO = 0;
    for index = 1:length(probability)
        INFO = INFO + (log2(1/probability(index)));
    end
end