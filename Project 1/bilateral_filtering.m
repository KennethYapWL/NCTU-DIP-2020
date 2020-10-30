function transImgMatr = bilateral_filtering(imgMatr,filtSize,sigma_d,sigma_g)
    % ---------------------------------
    % This function perform the noise removal with bilateral filtering
    % return transformed image matrix
    % Code refer to https://www.mathworks.com/matlabcentral/fileexchange/12191-bilateral-filtering
    % ---------------------------------
    imgMatr = double(imgMatr);
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    % replicate padding on image matrix
    shift = double(floor(filtSize / 2));
    paddMatr = padarray(imgMatr,[shift shift],0);
    
    % Make 2D Gaussian kernel
    x=-ceil(shift) : ceil(shift);
    Gauss1D = exp(-(x.^2 / (2 * sigma_d^2)));
    Gauss1D = Gauss1D / sum(Gauss1D(:));
    
    GaussX=reshape(Gauss1D,[length(Gauss1D) 1]);
    GaussY=reshape(Gauss1D,[1 length(Gauss1D)]);
    
    GaussMatr = zeros(length(GaussX),length(GaussY));
    for x = 1 : length(GaussX)
        for y = 1 : length(GaussY)
            GaussMatr(x,y) = GaussX(x) * GaussY(y);
        end
    end
    
    clearvars GaussX GaussY Gauss1D
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(hg,wd);
    
    % Do spatial filtering
    for row = 1 : hg
        for col = 1 : wd

            % Extract local region
            L = paddMatr(row : row + (filtSize - 1),col : col + (filtSize - 1));
            % Compute Gaussian Intensity Weights
            H = exp(-(L - imgMatr(row,col).^2) / (2 * sigma_g^2));
            % Compute Bilateral filter response
            Bilt = H.* GaussMatr;
            
            transImgMatr(row,col) = sum(Bilt(:).* L(:)) / sum(Bilt(:));

        end
    end
    
    transImgMatr = uint8(transImgMatr);
end