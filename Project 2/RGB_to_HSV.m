function HSV = RGB_to_HSV(imgMatr)
    %-----------------------------------
    % This function perform the tranformation from RGB to HSV
    % return HSV
    % refer to https://www.mathworks.com/matlabcentral/fileexchange/48864-rgb_to_hsv-m
    %-----------------------------------
    
    imgMatr = double(imgMatr);
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    imgMatr_R = imgMatr(:,:,1);
    imgMatr_G = imgMatr(:,:,2);
    imgMatr_B = imgMatr(:,:,3);
    
    H_matr = zeros(hg,wd);
    S_matr = zeros(hg,wd);
    V_matr = zeros(hg,wd);
    
    for row = 1 : hg
        for col = 1 : wd
            R = imgMatr_R(row,col);
            G = imgMatr_G(row,col);
            B = imgMatr_B(row,col);
            
            Max = max(R,max(G,B));
            Min = min(R,min(G,B));
            
            % Compute H
            H = 0;
            delta = Max - Min;
            if (delta == 0)
                H = 0; % undefined
            elseif (Max == R)
                H = 60 * (G - B) / delta;
                if (G < B) H = H + 360; end
            elseif (Max == G)
                H = 60 * (B - R) / delta + 120;
            elseif (Max == B)
                H = 60 * (R - G) / delta + 240;
            end
            
            % check if the value of H is negative
            if (H < 0)
                H = H + 360;
            end
            H = H / 360.0;
            
            
           % Compute S
           if (Max == 0)
               S = 0;
           else
            S = 1 - Min / Max;
           end
           
           % Compute V
           V = Max;
            
           H_matr(row,col) = H;
           S_matr(row,col) = S;
           V_matr(row,col) = V;
           
        end
    end
    
    HSV = cat(3,H_matr,S_matr,V_matr);
    
end