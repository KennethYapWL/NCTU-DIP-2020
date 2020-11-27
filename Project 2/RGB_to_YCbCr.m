function YCbCr = RGB_to_YCbCr(imgMatr)
    %-----------------------------------
    % This function perform the tranformation from RGB to YCbCr
    % return YCbCr
    % refer to https://stackoverflow.com/questions/6311460/rgb-to-ycbcr-conversion-in-matlab
    %-----------------------------------
    
    imgMatr = double(imgMatr);
    
    coeffs = [65.481, -37.797, 112; ...       % R coef
              128.553, -74.203, -93.786; ...  % G coef
              24.966, 112, -18.214];          % B coef
          
    YCbCr = reshape(imgMatr ./ 255, [], 3) * coeffs;
    YCbCr(:,1) = YCbCr(:,1) + 16;
    YCbCr(:,2) = YCbCr(:,2) + 128;
    YCbCr(:,3) = YCbCr(:,3) + 128;
   
    YCbCr = reshape(uint8(YCbCr),size(imgMatr));
   
end