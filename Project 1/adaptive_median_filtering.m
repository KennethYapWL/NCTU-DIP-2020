function transImgMatr = adaptive_median_filtering(imgMatr,filtSize)
    %-----------------------------------
    % This function perform the noise removal with adaptive median filtering
    % return transformed image matrix
    %
    % for code pls refer to :
    % 1.https://www.mathworks.com/matlabcentral/answers/247326-help-with-adaptive-median-filter
    % 2.https://github.com/mortezamg63/Adaptive-Median-Filter/blob/master/Adaptive_Median_filter.m
    %
    % and refer to it's algorithm explanation: 
    % https://www.massey.ac.nz/~mjjohnso/notes/59731/presentations/Adaptive%20Median%20Filtering.doc
    %-----------------------------------
    
    imgMatr = double(imgMatr);
    
    hg = size(imgMatr,1); % get the height of image
    wd = size(imgMatr,2); % get the width of image
    
    % filter maximum size
    Smax = 9;
    
    % replicate padding on image matrix
    shift = double(floor(Smax / 2));
    paddMatr = imgMatr;
    counterPadding=shift;
     while(counterPadding)
         paddMatr=[paddMatr(:,1) paddMatr paddMatr(:,end)]; 
         paddMatr=[paddMatr(1,:);paddMatr;paddMatr(end,:)]; 
         counterPadding=counterPadding-1;
     end
    
    % create the matrix with width and height 
    % exacly same as the input image to store the transformed pixel values
    transImgMatr = zeros(hg,wd);
    
    startIdx = Smax - shift;
    for row = startIdx : startIdx + (hg - 1)
        for col = startIdx : startIdx + (wd - 1)
            result = adap_med_computation(paddMatr,filtSize,Smax,row,col);
            transImgMatr(row - startIdx + 1, col - startIdx + 1) = result;
        end
    end
    
    transImgMatr = uint8(transImgMatr);
    
    
end


function output = adap_med_computation(paddMatr,filtSz,Smax,x,y)
    %-------------------------------------------------
    % Perform the adaptive median computation
    % paddMatr --> the input image with padding
    % filtSz --> current filter size
    % Smax --> maximum filter size
    % x,y --> current row index and current col index resp.
    % return transformed pixel value
    %-------------------------------------------------
    
    % get the area of neighborhood
    space = ceil((filtSz - 1)/2);
    ngbHood = paddMatr(x - space : x + space,y - space : y + space);
    
    % transformed pixel value
    output = 0;
    
    Zxy = paddMatr(x,y); % image curr index pixel value
    % assign local median, max, and min
    Zmed = median(ngbHood(:));
    Zmax = max(ngbHood(:));
    Zmin = min(ngbHood(:));
    
    A1 = Zmed - Zmin;
    A2 = Zmed - Zmax;
    
    % level A algorithm
    if (A1 > 0 && A2 < 0)
        % level B algorithm
        B1 = Zxy - Zmin;
        B2 = Zxy - Zmax;
        if (B1 > 0 && B2 < 0) 
            output = Zxy;
            return;
        else
            output = Zmed;
            return;
        end
    else % continue level A algorithm
        if (filtSz < Smax)
            filtSz = filtSz + 2;
            output = adap_med_computation(paddMatr,filtSz,Smax,x,y);
            return;
        else
            output = Zxy;
        end
    end
    
end







