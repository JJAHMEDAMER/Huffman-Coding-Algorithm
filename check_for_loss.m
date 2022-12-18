function LOSS = check_for_loss()

file = fopen('trial.txt');
text_send = fread(file);
fclose(file);

file = fopen('received.txt');
text_recv = fread(file);
fclose(file);


if (length(text_send) - length(text_recv) ~= 0)
    disp("Send File Length: ")
    disp(length(text_send))
    
    
    disp("Send File Length: ")
    disp(length(text_recv))
    
    disp("Loss in number of char")
    LOSS = length(text_send) - length(text_recv);
    disp(LOSS) 
    fprintf("There are %d missing char", LOSS)
else
    disp("Equal Char Length, checking for difference/Error")
    LOSS = 0;
    for index = 1:length(text_send)
        if text_send(index) ~= text_recv(index)
            LOSS = LOSS + 1;
        end
    end
    fprintf("There are %d error", LOSS)
end

end