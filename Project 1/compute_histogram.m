function Hist = compute_histogram(imgMatr)
    % ----------------------
    % This function simply output the histogram of image
    % To show it on graph, please use bar() function
    % return: A matrix with dimension 2 x 256, 
    % first row represents pixel value class
    % second row represents the frequency of corresponding pixel value
    % ----------------------
    Hist = zeros(256,1);

    % Stat frequency of each pixel values.
    for i = 1 : 256
        Hist(i,1) = sum(sum(sum(imgMatr == i)));
    end
    
end