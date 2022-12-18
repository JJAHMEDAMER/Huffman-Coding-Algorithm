function ENTRO = entropy(probability)

ENTRO = 0;
for index = 1:length(probability)
    ENTRO = ENTRO + (probability(index) *  log2(1/probability(index)));
end
end