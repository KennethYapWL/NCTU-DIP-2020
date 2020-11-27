function transImgMatr = laplacian_gaussian_filter(imgMatr,sigma)
    % ---------------------------------
    % This function perform the edge detection with log filtering
    % ref: https://www.mathworks.com/matlabcentral/fileexchange/59816-log_edgedetection-image-sigma
    % return transformed image matrix
    % ---------------------------------
    
    imgMatr = double(imgMatr);
    
    % filter size is estimated by: sigma * constant
    filtSz = ceil(sigma) * 5; 
    filtSz = (filtSz - 1) / 2; 
    
    shift = double(floor(filtSz / 2));
    [x, y] = meshgrid(-shift : shift, -shift : shift);
    % The two parts of the LoG equation
    part_1 = (x .^ 2 + y .^ 2 - 2 * sigma ^ 2) / sigma ^ 4;
    part_2 = exp( - (x .^ 2 + y .^ 2) / (2 * sigma ^ 2) );
    part_2 = part_2 / sum(part_2(:));
    % The LoG filter
    LoG = - part_1 .* part_2;
    % The normalized LoG filter
    nLoG = LoG - mean2(LoG);
    
    transImgMatr = imfilter(imgMatr, nLoG, 'replicate');
    
    transImgMatr = transImgMatr * 255.0;
    transImgMatr = uint8(transImgMatr);
    
end
