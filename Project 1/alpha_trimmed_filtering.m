function transImgMatr = alpha_trimmed_filtering(imgMatr,filtWd,filtHg,alpha)
    % ---------------------------------
    % This function perform the noise removal with alpha trimmed filtering
    % return transformed image matrix
    % ---------------------------------
    
    wd = size(imgMatr,1); % get the width of image
    hg = size(imgMatr,2); % get the height of image
    
    
    % zero padding on image matrix
    shiftWd = double(floor(filtWd / 2));
    shiftHg = double(floor(filtHg / 2));
    paddMatr = padarray(imgMatr,[shiftWd shiftHg],0);
    
    % number of element to be trimmed
    d = floor(floor(filtWd * filtHg * alpha)/2);
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(wd,hg);
    
    % Do the spatial filtering computation 
    for row = 1 : wd
        for col = 1 : hg
            % assign filter pixel values
            filter = zeros(filtWd, filtHg);
            for x = 1 : filtWd
                for y = 1 : filtHg
                    filter(x,y) = paddMatr(x + (row - 1), y + (col - 1));
                end
            end
            
            list = sort(filter(1 : filtWd * filtHg)); % sort
            list = list(d + 1 : length(list)-d); % trimmed
            transImgMatr(row,col) = mean(list); % take mean value
            
        end
    end
    
    transImgMatr = uint8(transImgMatr);
    
    
    
end