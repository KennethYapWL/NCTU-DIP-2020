function imgMatr = convert_to_binary_image(imgMatr, threshold)
    % ---------------------------------
    % This function perform the conversion from image to binary image
    % note that threshold value is between 0 to 1
    % ref: it's same to builtin function --> im2bw()
    % return transformed image matrix
    % ---------------------------------
    
    imgMatr = uint8(imgMatr);
    th = 255 * threshold;
    
    imgMatr(imgMatr < th) = 0;
    imgMatr(imgMatr >= th) = 1;
    
    imgMatr = double(imgMatr);
    
end