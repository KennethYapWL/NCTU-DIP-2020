function transImgMatr = adaptive_filtering(imgMatr,filtWd,filtHg)
    %-----------------------------------
    % This function perform the noise removal with adaptive filtering
    % return transformed image matrix
    % refer to https://www.imageeprocessing.com
    % /2011/12/adaptive-filtering-local-noise-filter.html
    %-----------------------------------
    
    imgMatr = double(imgMatr);

    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    % zero padding on image matrix
    shiftHg = double(floor(filtHg / 2));
    shiftWd = double(floor(filtWd / 2));
    paddMatr = padarray(imgMatr,[shiftHg shiftWd],0);
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(hg,wd);
    
    % create matrices of local variance,
    % local means, 
    local_var = zeros(hg,wd);
    local_mean = zeros(hg,wd);
    
    % Do the spatial filtering computation 
    for row = 1 : hg
        for col = 1 : wd
            % assign filter pixel values
            filter = paddMatr(row : row + (filtHg - 1),col : col + (filtWd - 1));
            
            % get local mean for the local region
            local_mean(row,col) = mean(filter(:)); 
            % get local variance for the local region
            local_var(row,col) = mean(filter(:).^2) - mean(filter(:)).^2;
            
        end
    end
    
    % calculate noise variance
    noise_var = mean(local_var(:));
    
    % replace local variances which smaller than noice variance
    local_var = max(local_var,noise_var);
    
    % apply adaptive expression formula to image matrix
    transImgMatr = imgMatr - (noise_var./local_var).*(imgMatr - local_mean);
    
    transImgMatr = uint8(transImgMatr);
    
end