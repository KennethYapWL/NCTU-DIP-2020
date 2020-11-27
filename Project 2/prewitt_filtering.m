function transImgMatr = prewitt_filtering(imgMatr, direction)
    % ---------------------------------
    % This function perform the edge detection with prewitt filtering
    % ref: https://www.geeksforgeeks.org/matlab-image-edge-detection-using-prewitt-operator-from-scratch/
    % return transformed image matrix
    % ---------------------------------
    
    imgMatr = double(imgMatr);
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    % zero padding on image matrix
    filtSize = 3;
    shift = double(floor(filtSize / 2));
    paddMatr = padarray(imgMatr,[shift shift],0);
    
    % prewitt filter
    prewittx = [-1,0,1; -1,0,1; -1,0,1];
    prewitty = [-1,-1,-1; 0,0,0; 1,1,1];
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    gx = zeros(hg,wd);
    gy = zeros(hg,wd);
    for row = 1 : hg
        for col = 1 : wd
            % x direction
            mul = paddMatr(row : row + (filtSize - 1),col : col + (filtSize - 1)).* prewittx;
            gx(row,col) = sum(mul(:));
            
            % y direction
            mul = paddMatr(row : row + (filtSize - 1),col : col + (filtSize - 1)).* prewitty;
            gy(row,col) = sum(mul(:));
            
            switch direction
                case 'vertical'
                    gx(row,col) = 0; % remove gx
                case 'horizontal'
                    gy(row,col) = 0; % remove gy
            end
            
        end
    end
    
    grad = sqrt((gx .^2) + (gy .^2));
    transImgMatr = uint8(grad);
    
end