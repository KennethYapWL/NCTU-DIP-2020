function RGB = YCbCr_to_RGB(imgMatr)
    %-----------------------------------
    % This function perform the tranformation from YCbCr to RGB
    % return RGB
    % refer to https://github.com/arrayfire/arrayfire/issues/532
    %-----------------------------------
    
    imgMatr = double(imgMatr);
    
    coeffs = [0.0045662, 0.0045662, 0.0045662; ...        % Y coef
              0.0, -0.0015363, 0.0079107; ...             % Cb coef
              0.0062589, -0.0031881, 0.0];                % Cr coef
          
    RGB = reshape(imgMatr, [], 3) * coeffs;
    RGB(:,1) = RGB(:,1) + -0.8742024;
    RGB(:,2) = RGB(:,2) + 0.5316682;
    RGB(:,3) = RGB(:,3) + -1.0856326;
    RGB = RGB .* 255;
    RGB = reshape(uint8(RGB),size(imgMatr));
   
end