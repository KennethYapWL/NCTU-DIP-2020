function imgMatr = thresholding_candidates(imgMatr, threshold)
    % ---------------------------------
    % This function perform the thresholding for candidate edge points
    % ref: https://www.imageeprocessing.com/2011/12/sobel-edge-detection.html
    % return transformed image matrix
    % ---------------------------------
    
    imgMatr = max(imgMatr,threshold);
    imgMatr(imgMatr==round(threshold))=0;

    imgMatr = uint8(imgMatr);
    
end