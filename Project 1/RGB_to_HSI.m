function HSI = RGB_to_HSI(imgMatr)
    %-----------------------------------
    % This function perform the tranformation from RGB to HSI
    % return RGB
    % refer to https://www.imageeprocessing.com/2013/05/converting-rgb-image-to-hsi.html
    %-----------------------------------
    
    imgMatr = double(imgMatr);
    
    R = imgMatr(:,:,1) / 255;
    G = imgMatr(:,:,2) / 255;
    B = imgMatr(:,:,3) / 255;
    
    % Hue
    numerator = 1/2 * ((R - G) + (R - B));
    denominator = ((R - G).^2+((R - B).*(G - B))).^0.5;
    
    % To avoid divide by zero exception add a small number in the denominator
    H = acosd(numerator./(denominator + 0.000001));
    
    % If B>G then H= 360-Theta
    H(B > G) = 360 - H(B > G);
    
    % Normalize to the range [0 1]
    H = H / 360;
    
    % Saturation
    S = 1 - (3./ (sum(imgMatr,3) + 0.000001)).* min(imgMatr,[],3);
    
    % Intensity
    I = sum(imgMatr,3)./ 3;
    
    % HSI
    HSI = cat(3,H,S,I);
    
end