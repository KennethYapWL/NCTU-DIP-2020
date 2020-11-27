function transImgMatr = gaussian_filtering(imgMatr,sigma,filtSize)
    % ---------------------------------
    % This function perform the noise removal with gaussian filtering
    % return transformed image matrix
    % ---------------------------------
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    % replicate padding on image matrix
    shift = double(floor(filtSize / 2));
    paddMatr = padarray(imgMatr,[shift shift],'replicate');
    
    % Make 2D Gaussian kernel
    x=-ceil(shift):ceil(shift);
    Gauss1D = exp(-(x.^2/(2*sigma^2)));
    Gauss1D = Gauss1D/sum(Gauss1D(:));
    
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

            tmp = 0;
            for x = 1 : filtSize
                for y = 1 : filtSize
                    tmp = tmp + GaussMatr(x,y) * paddMatr(x + (row - 1), y + (col - 1));
                end
            end

            transImgMatr(row,col) = tmp;

        end
    end
    
    transImgMatr = uint8(transImgMatr);
    
end