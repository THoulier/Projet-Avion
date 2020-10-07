function [d, error_flag] = decodeCRC(sequence,h)

    [d, error] = detect(h,sequence);
    error_flag = error;       
end