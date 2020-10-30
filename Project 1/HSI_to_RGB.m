function RGB = HSI_to_RGB(imgMatr)
    %-----------------------------------
    % This function perform the tranformation from HSI to RGB
    % return RGB
    % refer to https://www.imageeprocessing.com/2013/06/convert-hsi-image-to-rgb-image.html
    %-----------------------------------
    
    imgMatr = double(imgMatr);
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    H = imgMatr(:,:,1) * 360;
    S = imgMatr(:,:,2);
    I = imgMatr(:,:,3);
    
    % Preallocate the R,G and B components  
    R = zeros(hg,wd);
    G = zeros(hg,wd);  
    B = zeros(hg,wd);  
     
    % RG Sector(0<=H<120)  
    % When H is in the above sector, the RGB components equations are
    B(H < 120) = I(H < 120).* (1 - S(H < 120));  
    R(H < 120) = I(H < 120).* (1 + ((S(H < 120).* cosd(H(H < 120)))./ cosd(60 - H(H < 120))));     
    G(H < 120) = 3.* I(H < 120) - (R(H < 120) + B(H < 120)); 
    
    % GB Sector(120<=H<240)  
    % When H is in the above sector, the RGB components equations are  
    % Subtract 120 from Hue  
    H_adj = H - 120;  
    R(H >= 120 & H < 240) = I(H >= 120 & H < 240).*(1 - S(H >= 120 & H < 240));  
    G(H >= 120 & H < 240) = I(H >= 120 & H < 240).*(1 + ((S(H >= 120 & H < 240).*cosd(H_adj(H >= 120 & H <240)))./cosd(60 - H_adj(H >=120 & H < 240)))); 
    B(H >= 120 & H < 240) = 3.*I(H >= 120 & H < 240) - (R(H >= 120 & H < 240) + G(H >= 120 & H < 240));
     
    % BR Sector(240<=H<=360)  
    % When H is in the above sector, the RGB components equations are  
    % Subtract 240 from Hue  
    H_adj = H - 240;  
    G(H >= 240 & H <= 360) = I(H >= 240 & H <= 360).*(1 - S(H >= 240 & H <= 360)); 
    B(H >= 240 & H <= 360) = I(H >= 240 & H <= 360).*(1 + ((S(H >= 240 & H <= 360).*cosd(H_adj(H >= 240 & H <= 360)))./cosd(60 - H_adj(H >= 240 & H <= 360))));  
    R(H >= 240 & H <= 360) = 3.*I(H >= 240 & H <= 360) - (G(H >= 240 & H <= 360) + B(H >= 240 & H <= 360));  
    
    %Form RGB Image
    RGB = uint8(cat(3,R,G,B));
    
end