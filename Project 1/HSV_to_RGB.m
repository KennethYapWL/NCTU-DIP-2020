function RGB = HSV_to_RGB(imgMatr)
    %-----------------------------------
    % This function perform the tranformation from HSV to RGB
    % return RGB
    % refer to https://www.rapidtables.com/convert/color/hsv-to-rgb.html
    %-----------------------------------
    
    imgMatr = double(imgMatr);
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    imgMatr_H = imgMatr(:,:,1) * 360;
    imgMatr_S = imgMatr(:,:,2);
    imgMatr_V = imgMatr(:,:,3) / 255;
    
    R_matr = zeros(hg,wd);
    G_matr = zeros(hg,wd);
    B_matr = zeros(hg,wd);
    
    for row = 1 : hg
        for col = 1 : wd
            H = imgMatr_H(row,col);
            S = imgMatr_S(row,col);
            V = imgMatr_V(row,col);
            
            % transform to RGB
            C = V * S;
            X = C * (1 - abs( mod(H/60,2) - 1 ));
            m = V - C;
            
            R = 0; G = 0; B = 0;
            if (H >= 0 && H < 60)
                R = C; G = X; B = 0;
            elseif (H >= 60 && H < 120)
                R = X; G = C; B = 0;
            elseif (H >= 120 && H < 180)
                R = 0; G = C; B = X;
            elseif (H >= 180 && H < 240)
                R = 0; G = X; B = C;
            elseif (H >= 240 && H < 300)
                R = X; G = 0; B = C;
            elseif (H >= 300 && H < 306)
                R = C; G = 0; B = X;
            end
            
            
            R_matr(row,col) = (R + m) * 255;
            G_matr(row,col) = (G + m) * 255;
            B_matr(row,col) = (B + m) * 255;
           
        end
    end
    
    RGB = uint8(cat(3,R_matr,G_matr,B_matr));

end