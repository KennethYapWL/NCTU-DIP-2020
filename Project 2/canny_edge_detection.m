function transImgMatr = canny_edge_detection(imgMatr, sigma, low_thres, high_thres)
    % ---------------------------------
    % This function perform the canny edge detection
    % ref: 
    % 1. https://towardsdatascience.com/canny-edge-detection-step-by-step-in-python-computer-vision-b49c3a2d8123
    % 2. https://www.mathworks.com/matlabcentral/fileexchange/41221-canny-edge-detector
    % return transformed image matrix
    % ---------------------------------
    
    imgMatr = double(imgMatr);
    % 1. Smoothing
    transImgMatr = smoothing_with_gaussian(imgMatr, sigma);
    % 2. Gradient Calculation
    [transImgMatr, theta] = gradient_calculation(transImgMatr);
    % 3. Non-Maxima Suppression
    transImgMatr = non_maxima_suppression(transImgMatr, theta);
    % 4. Double Thresholding
    transImgMatr = double_thresholding(transImgMatr, low_thres, high_thres);
    % 5. Hysteresis Edge Tracking
    transImgMatr = hysteresis_edge_tracking(transImgMatr);
    
    transImgMatr = uint8(transImgMatr);
end

function transImgMatr = smoothing_with_gaussian(imgMatr, sigma, filtSz)
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image

    % filter size is estimated by: sigma * constant
    filtSz = ceil(sigma) * 5; 
    filtSz = (filtSz - 1) / 2; 
    
    % replicate padding on image matrix
    shift = double(floor(filtSz / 2));
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
   
    for row = 1 : hg
        for col = 1 : wd

            tmp = 0;
            for x = 1 : filtSz
                for y = 1 : filtSz
                    tmp = tmp + GaussMatr(x,y) * paddMatr(x + (row - 1), y + (col - 1));
                end
            end

            transImgMatr(row,col) = tmp;

        end
    end
    
end

function [transImgMatr, theta] = gradient_calculation(imgMatr)
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image

    % ========================================
    % 1. gradients computing
    % ========================================
    % zero padding on image matrix
    filtSize = 3;
    shift = double(floor(filtSize / 2));
    paddMatr = padarray(imgMatr,[shift shift],0);
    
    % sobel filter
    sobelx = [-1,0,1; -2,0,2; -1,0,1];
    sobely = [-1,-2,-1; 0,0,0; 1,2,1];
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    gx = zeros(hg,wd);
    gy = zeros(hg,wd);
    for row = 1 : hg
        for col = 1 : wd
            % x direction
            mul = paddMatr(row : row + (filtSize - 1),col : col + (filtSize - 1)).* sobelx;
            gx(row,col) = sum(mul(:));
            
            % y direction
            mul = paddMatr(row : row + (filtSize - 1),col : col + (filtSize - 1)).* sobely;
            gy(row,col) = sum(mul(:));
            
            
        end
    end
    
    grad = sqrt((gx .^2) + (gy .^2));
    %grad = grad / max(grad(:)) * 255;
    transImgMatr = grad;
    
    % ========================================
    % 2. angle of gradients computing
    % ========================================
    [gradHg, gradWd] = size(gx);
    epsilon = 0.00000000001; % prevent infinity results (in case there could be 0 in gx)
    theta = atan(gy./(gx + epsilon)) * (180/3.1412);
    
    % note that the range of arctan is (-pi/2, pi/2)
    % make all elements in theta positive 
    for row = 1 : gradHg
        for col = 1 : gradWd
            if (theta(row,col) < 0)
                theta(row,col) = theta(row,col) + 180;
            end
        end
    end
    
    % fix all element of theta into 4 degrees
    for row = 1 : gradHg
        for col = 1 : gradWd
          if ( (0 <= theta(row,col)) && (theta(row,col) < 22.5)) || ((157.5 <= theta(row,col)) && (theta(row,col) <= 180) )
                theta(row,col) = 0;
          elseif (22.5 <= theta(row,col)) && (theta(row,col) < 67.5)
                theta(row,col) = 45;
          elseif (67.5 <= theta(row,col)) && (theta(row,col) < 112.5)  
                theta(row,col) = 90;
          elseif (112.5 <= theta(row,col)) && (theta(row,col) < 157.5)
                theta(row,col) = 135;
          end
      end
  end 

    
end

function transImgMatr = non_maxima_suppression(Grad, theta)
    GradHg = size(Grad, 1); % get the height of gradient
    GradWd = size(Grad, 2); % get the width of gradient
    
    paddMatr = padarray(Grad,[1 1],0); % zero padding
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(GradHg,GradWd);
    
    for row  = 1 : GradHg
        for col = 1 : GradWd
            lt = 0;
            rt = 0;
            act_row = row + 1; 
            act_col = col + 1;
            switch theta(row,col)
                case 0
                    lt = paddMatr(act_row, act_col - 1);
                    rt = paddMatr(act_row, act_col + 1);
                case 45
                    lt = paddMatr(act_row + 1, act_col - 1);
                    rt = paddMatr(act_row - 1, act_col + 1);
                case 90
                    lt = paddMatr(act_row + 1, act_col);
                    rt = paddMatr(act_row - 1, act_col);
                case 135
                    lt = paddMatr(act_row - 1, act_col - 1);
                    rt = paddMatr(act_row + 1, act_col + 1);
            end
            
            % check if current pixel value is the maximum in surrounding
            if (Grad(row,col) >= lt && Grad(row,col) >= rt)
                transImgMatr(row,col) = Grad(row,col);
            else
                transImgMatr(row,col) = 0;
            end
            
        end
    end
    
end

function Grad = double_thresholding(Grad, low_thres, high_thres)
    GradHg = size(Grad, 1); % get the height of gradient
    GradWd = size(Grad, 2); % get the width of gradient
    
    weak = 25;
    strong = 255;
    zero = 0;
    
    for row = 1 : GradHg
        for col = 1 : GradWd
            if (Grad(row,col) >= high_thres)
                Grad(row,col) = strong;
            elseif (Grad(row,col) > low_thres)
                Grad(row,col) = weak;
            else
                Grad(row,col) = zero;
            end
        end
    end
    
end

function Grad = hysteresis_edge_tracking(Grad)
    GradHg = size(Grad, 1); % get the height of gradient
    GradWd = size(Grad, 2); % get the width of gradient
    
    paddMatr = padarray(Grad,[1 1],0); % zero padding
    
    weak = 25;
    strong = 255;
    zero = 0;
    
    for row  = 1 : GradHg
        for col = 1 : GradWd
            act_row = row + 1; 
            act_col = col + 1;
            
            if (Grad(row,col) == weak)
                if (paddMatr(act_row - 1, act_col - 1) == strong || ... % top-left
                    paddMatr(act_row - 1, act_col) == strong ||     ... % upper
                    paddMatr(act_row - 1, act_col + 1) == strong || ... % top-right
                    paddMatr(act_row, act_col - 1) == strong ||     ... % left
                    paddMatr(act_row, act_col + 1) == strong ||     ... % right
                    paddMatr(act_row + 1, act_col - 1) == strong || ... % bottom-left
                    paddMatr(act_row + 1, act_col) == strong ||     ... % bottom
                    paddMatr(act_row + 1, act_col + 1) == strong)       % bottom-right
                
                    Grad(row,col) = strong;
                else
                    Grad(row,col) = zero;
                end
            end
            
            
            
        end
    end
    
    
end

