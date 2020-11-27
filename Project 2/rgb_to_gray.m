function gray = rgb_to_gray(imgMatr)
    % ---------------------------------
    % This function perform the edge detection with sobel filtering
    % ref: https://www.mathworks.com/matlabcentral/fileexchange/29392-rgb2gray
    % return grayscale image matrix
    % ---------------------------------
    
    imgMatr = double(imgMatr);
    [hg wd ch] = size(imgMatr); % get height, width and channel of the image
    
    R = imgMatr(:,:,1);
    G = imgMatr(:,:,2);
    B = imgMatr(:,:,3);
    
    gray = 0.29900 * R + 0.58700 * G + 0.11400 * B;
    gray = uint8(gray);
    
end