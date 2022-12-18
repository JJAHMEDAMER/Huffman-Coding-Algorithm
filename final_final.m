function x = main()

disp('Reading data: '); 
file = fopen('trial.txt', 'r');
text = fread(file, '*char')';
fclose(file);

disp('Probability '); 
[unique_symbol, probability]=source_statistics(text);

disp('Huffman encoding: '); 
code_word = huffman_encoding(probability); 

disp('Stream generator: '); 
bit_stream = stream_generator(unique_symbol, code_word, text);

disp('Huffman decoding: ');
decoded_msg = huffman_decoding(unique_symbol, code_word, bit_stream); 

disp('Writing data to received.txt: ');
f = fopen('received.txt', 'w+');
fprintf(f, '%s', decoded_msg);
fclose(f);


disp("Inforamtion: ")
INFO = info(probability);
disp(INFO)

disp("Entropy: ")
ENTRO = entropy(probability);
disp(ENTRO)

disp("Average Code Length: ")
AVG_CODE_LENGTH = avg_code_length(probability, code_word);
disp(AVG_CODE_LENGTH)

disp("Efficiency: ")
efficency = ENTRO/AVG_CODE_LENGTH;
disp(efficency)

disp("Number of Binary Bits Before Encoding")
number_of_binary_before_encoding = length(text) * 8 ;
disp(number_of_binary_before_encoding)

disp("Number of Binary Bits After Encoding")
number_of_binary_after_encoding = length(text) * AVG_CODE_LENGTH ;
disp(number_of_binary_after_encoding)

disp("Comprsion ratio")
comprison = number_of_binary_after_encoding/number_of_binary_before_encoding;
disp(comprison)

disp("Losses")
x = check_for_loss();

end


function [unique_symbol, probability]=source_statistics(text)
    unique_symbol = unique(text); 
    count_symbol = histc(text, unique_symbol);
    probability = count_symbol / length(text); 
    [probability, index] = sort(probability, 'descend'); 
    unique_symbol = unique_symbol(index);
end

function code_word = huffman_encoding(prob)
    n = length(prob); 
    code_word = cell(1, n);
    prob = fliplr(prob); 
    if n == 1
        code_word{1} = '1'; 
    end
    x = zeros(n, n); 
    x(:, 1) = (1:n)'; 
    
    for i = 1:n-1
        temp = prob; 
        [~, min1] = min(temp);  
        temp(min1) = 1; 
        [~, min2] = min(temp); 
        prob(min1) = prob(min1) + prob(min2); 
        prob(min2) = 1; 
        x(:, i+1) = x(:, i); 
        for j = 1:n
            if x(j, i+1) == min1
                code_word(j) = strcat('0', code_word(j)); 
            elseif x(j, i+1) == min2
                x(j, i+1) = min1; 
                code_word(j) = strcat('1', code_word(j));
            end
        end
    end
    code_word = fliplr(code_word); 
end


function bit_stream = stream_generator(unique_symbol, code_word, msg)
    bit_stream = '';
    increment = length(char(unique_symbol(1))); 
    for i = 1:increment:length(msg)
        index = strfind(unique_symbol, msg(i:i+increment-1)); 
        bit_stream = [bit_stream char(code_word(index))];
    end
    bit_stream = double(bit_stream - double('0')); 
end

function decoded_msg = huffman_decoding(unique_symbol, code_word, bit_stream)
    decoded_msg = []; 
    i_min = min(cellfun('length', code_word));
    ptr = 1; 
    for i = i_min:length(bit_stream)
        if isempty(find(strcmp(code_word, char(bit_stream(ptr:i) + '0')), 1)) ~= 1
            ind = find(strcmp(code_word, char(bit_stream(ptr:i) + '0')), 1); 
            decoded_msg = [decoded_msg char(unique_symbol(ind))]; 
            ptr = i + 1; 
            i = i + i_min; 
        end
    end
end

