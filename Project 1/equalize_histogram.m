function transImgMatr = equalize_histogram(imgMatr)
    % ---------------------------------
    % This function perform histogram equalization
    % return transformed image matrix
    % refer to https://github.com/HYPJUDY/
    % digital-image-processing-hw/blob/master/
    % hw2-Histogram%20and%20Spatial%20Filtering/code_hw2/equalize_hist.m
    % ---------------------------------
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(hg,wd);
    
    cdf = zeros(256,1); % cummulative frequency
    equalized = zeros(256,1); % equalized frequency
    hist = compute_histogram(imgMatr); % histogram of image
    L = 256; % maximum pixel value
    
    % for each pixel in the input image
    % calculate the cdf for this image
    tempSum = 0;
    for i = 1 : size(hist)
        tempSum = tempSum + hist(i,1);
        cdf(i) = tempSum / (hg * wd);
        equalized(i) = round(cdf(i) * (L - 1));
    end
    
    % for each pixel in the output image
    % calculate the histogram equalization result
    for row = 1 : hg
        for col = 1 : wd
            transImgMatr(row,col) = equalized(imgMatr(row,col) + 1);
        end
    end
    
end