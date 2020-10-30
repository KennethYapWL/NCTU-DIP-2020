function transImgMatr = statistic_filtering(imgMatr,filtWd,filtHg,Type)
    % ---------------------------------
    % This function perform the noise removal with statistic filtering
    % "mean" --> averaging filter
    % "max" --> max filter
    % "min" --> min filter
    % "median" --> median filter
    % return transformed image matrix
    % ---------------------------------
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
     
    % zero padding
    shift_hg = int32(floor(filtHg / 2)); % calulate the extra space needed for hg
    shift_wd = int32(floor(filtWd / 2)); % calulate the extra space needed for wd
    paddMatr = zeros(hg + (shift_hg * 2),wd + (shift_wd * 2));
    for row = 1 : hg
        for col = 1 : wd
            paddMatr(row + shift_hg,col + shift_wd) = imgMatr(row,col);
        end
    end
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(hg,wd);
    
    % Do the spatial filtering computation 
    for row = 1 : hg
        for col = 1 : wd
            % assign filter pixel values
            filter = paddMatr(row : row + (filtHg - 1),col : col + (filtWd - 1));
            
            if (Type == "mean")% assign the mean of the filter pixel values
                transImgMatr(row,col) = mean(filter(:));
                
            elseif (Type == "max")% assign the max of the filter pixel values
                transImgMatr(row,col) = max(filter(:));
                
            elseif (Type == "min")% assign the min of the filter pixel values
                transImgMatr(row,col) = min(filter(:));
              
            else % assign the median of the filter pixel values
                transImgMatr(row,col) = median(filter(:));
                
            end
        end
    end
    
    transImgMatr = uint8(transImgMatr);

end