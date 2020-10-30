function imgMatr = power_law_transform(imgMatr,c,gamma)
    % ---------------------------------
    % This function perform the power law transformation
    % return transformed image matrix
    % https://www.ques10.com/p/3690/determine-the-output-image-using-power-law-transfo/?
    % ---------------------------------
    imgMatr = double(imgMatr)/255;
    imgMatr = c * (imgMatr).^gamma;
    imgMatr = uint8(imgMatr * 255);
end