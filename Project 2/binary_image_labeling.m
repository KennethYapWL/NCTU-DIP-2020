function [transImgMatr , lbl] = binary_image_labeling(imgMatr, direction_no)
    % ---------------------------------
    % This function perform the labeling of binary image
    % ref: 
    % 1. it's similar to builtin function --> bwlabel()
    % 2. https://www.mathworks.com/matlabcentral/answers/244641-connected-component-labeling-without-using-bwlabel-or-bwconncomp-functions
    % return transformed image matrix
    % ---------------------------------
    
    global transImgMatr;
    global HG;
    global WD;
    
    imgMatr = uint8(imgMatr);
    HG = size(imgMatr,1); % get the height of image
    WD = size(imgMatr,2); % get the width of image
    
    %paddMatr = padarray(imgMatr,[1 1],0); % zero padding
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(HG,WD);
    lbl = 0;
    
    % to make sure boundary conditions, skip first row, column and last row,
    % column. These will be taken care by recursive function calls later
    for row = 1 : HG
        for col = 1 : WD 
            if (imgMatr(row, col) == 1 && transImgMatr(row, col) == 0)
                lbl = lbl + 1;
                labelconnected(row, col, imgMatr, lbl, direction_no);
            end
            
        end
    end
    
    transImgMatr = uint8(transImgMatr);
    
end

function labelconnected(row,col,imgMatr,lbl,direction_no)
    global transImgMatr;
    global HG;
    global WD;
    transImgMatr(row,col) = lbl;
    
    % neighborhood connectivity
    drow = [-1,-1,-1, 0,0, 1,1,1];
    dcol = [-1, 0, 1,-1,1,-1,0,1];
    if (direction_no == 4)
        drow = [-1, 0,0,1];
        dcol = [ 0,-1,1,0];
    end
    
    for direct = 1 : direction_no
        ngb_row = row + drow(direct);
        ngb_col = col + dcol(direct);

        if (ngb_row < 1 || ngb_row > HG)
            continue;
        end
        
        if (ngb_col < 1 || ngb_col > WD)
            continue;
        end


        if (imgMatr(ngb_row, ngb_col) == 1 && transImgMatr(ngb_row, ngb_col) == 0)
            labelconnected(ngb_row, ngb_col, imgMatr, lbl, direction_no);
        end
    end
    
end

