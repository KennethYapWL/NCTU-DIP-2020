function [imgMatr, transFunc] = piecewise_linear_streching(imgMatr,r1,s1,r2,s2)
    % ---------------------------------
    % This function perform the piecewise linear transformation
    % with using the equation y = mx + c on each segment.
    % return transformed image matrix
    % ---------------------------------

    imgMatr = uint8(imgMatr);
    
    % declare each starting point, ending point of each segment.
    p1 = [0,0];
    p2 = [r1,s1];
    p3 = [r2,s2];
    p4 = [255,255];
    
    % calculate gradients of each segment.
    m1 = (p2(2) - p1(2))/(p2(1) - p1(1));
    m2 = (p3(2) - p2(2))/(p3(1) - p2(1));
    m3 = (p4(2) - p3(2))/(p4(1) - p3(1));
    
    % calculate intercepts of each segment.
    c1 = p1(2) - m1*p1(1);
    c2 = p2(2) - m2*p2(1);
    c3 = p3(2) - m3*p3(1);
    
    % build transformation function
    transFunc = zeros(2,256);
    transFunc(1,:) = [0:255];
    
    for x = 0 : 255
        y = 0;
        if (x <= p2(1))
            y = m1 * x + c1;
        elseif (x > p2(1) && x <= p3(1))
            y = m2 * x + c2;
        else
            y = m3 * x + c3;
        end
        transFunc(2,x + 1) = y;    
    end
    
    % transform the input image
    hg = size(imgMatr,1);
    wd = size(imgMatr,2);
    
    size(transFunc);
    
    for row = 1 : hg
        for col = 1 : wd
            origPxl = imgMatr(row,col);
            imgMatr(row,col) = transFunc(2, origPxl + 1);
        end
    end
    
end