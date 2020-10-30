function transImgMatr = laplacian_filtering(imgMatr,Lapl_filt)
    % ---------------------------------
    % This function perform sharpening with laplacian filtering
    % return transformed image matrix
    % refer to https://bohr.wlu.ca/hfan/cp467/12/notes/cp467_12_lecture6_sharpening.pdf
    % pg13
    % ---------------------------------
    
    imgMatr = double(imgMatr);
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    % zero padding on image matrix
    filtSize = 3;
    shift = double(floor(filtSize / 2));
    paddMatr = padarray(imgMatr,[shift shift],0);
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(hg,wd);
    
    %Lapl_filt = [1,1,1 ; 1,-8,1 ; 1,1,1];
    %if (filtType == 1)
        %Lapl_filt = [0,1,0 ; 1,-4,1 ; 0,1,0];
    %end
    
    
    filt = zeros(hg,wd);
    for row = 1 : hg
        for col = 1 : wd
            mul = paddMatr(row : row + (filtSize - 1),col : col + (filtSize - 1)).* Lapl_filt;
            filt(row,col) = sum(mul(:));
        end
    end
    
    transImgMatr = imgMatr - filt;
    transImgMatr = uint8(transImgMatr);
end