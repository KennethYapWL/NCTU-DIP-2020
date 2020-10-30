function transImgMatr = midpoint_filtering(imgMatr,filtWd,filtHg)
    % ---------------------------------
    % This function perform the noise removal with midpoint filtering
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
            filter = zeros(filtHg, filtWd);
            for x = 1 : filtHg
                for y = 1 : filtWd
                    filter(x,y) = paddMatr(x + (row - 1), y + (col - 1));
                end
            end
            
            % assign the midpoint of the filter pixel values
            Max = max(filter(:));
            Min = min(filter(:));
            transImgMatr(row,col) = (Max + Min)/2;
        end
    end
    
    transImgMatr = uint8(transImgMatr);
end