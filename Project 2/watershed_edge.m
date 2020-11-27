function label = watershed_edge(imgMatr)
    % ---------------------------------
    % This function perform the watershed edge detection
    % ref: 
    % 1. https://blog.csdn.net/dcrmg/article/details/52498440
    % 2. https://github.com/Akbonline/Watershed-Segmentation/blob/main/watershed.m
    % return transformed image matrix
    % ---------------------------------
    
    global HG;
    global WD;
    
    imgMatr = uint8(imgMatr);
    HG = size(imgMatr,1); % get the height of image
    WD = size(imgMatr,2); % get the width of image
    
    % Step 1 : 
    % Leveling the pixel list
    X_cell = cell(1,256);
    Y_cell = cell(1,256);
    
    for row = 1 : HG
        for col = 1 : WD
            c = imgMatr(row, col);
            X_cell{c + 1} = [X_cell{c + 1} row];
            Y_cell{c + 1} = [Y_cell{c + 1} col];
        end
    end
    
    % Setting the label to -1
    % Initializing the label variable from -1 through unlabeled
    label = -1 * ones(HG,WD);  
    labels_no = 0;
    
    % Step 2 : 
    for idx = 1 : 256
        % ref: https://blog.csdn.net/yes1989yes/article/details/75948473
        [tlabel, X, Y, front_X, front_Y] = deal(label, X_cell{idx}, Y_cell{idx}, [], []);
        
        for k = 1 : length(X)
            grays = idx - 1;
            [label,flag] = nearest_eight_watershed(tlabel, X(k), Y(k), grays, label, imgMatr);
            if flag > 0 
                front_X = [front_X X(k)];
                front_Y = [front_Y Y(k)];
            end
        end
        
        % Check if the frontier empty
        while ~isempty(front_X & front_Y) 
            
            last_X = front_X(length(front_X));  % Pop the last value from the Stack (front_X)
            front_X(length(front_X)) = []; % Delete the last value (front_X)
            
            last_Y = front_Y(length(front_Y)); % Pop the last value from the Stack (front_Y) 
            front_Y(length(front_Y)) = []; % Delete the last value (front_Y)
            
            % Visit this Stack, change the label, and push the updated value
            [front_X, front_Y, label] ...
            = neighborlist_watershed(imgMatr, last_X, last_Y, label, grays, front_X, front_Y);
        end
        
        % Creating a new catchment basins
        for k = 1 : length(X)
            seed = [X(k) Y(k)];
            color = labels_no;
            
            if (imgMatr(X(k), Y(k)) == grays && label(X(k), Y(k)) == -1)
                label = floodfill_separate(seed, imgMatr, color, label);
                labels_no = labels_no + 1;
            end
            
        end
        
        
    end
    
end

function [final,flag] = nearest_eight_watershed(tlabels, row, col, grays, final, imgMatr)
    % ref: https://github.com/Akbonline/Watershed-Segmentation/blob/main/nearestEight_watershed.m
    global HG;
    global WD;
    
    flag = 0;
    if (imgMatr(row, col) ~= grays) 
        return;
    end
    
    % neighborhood connectivity
    drow = [-1,-1,-1, 0,0, 1,1,1];
    dcol = [-1, 0, 1,-1,1,-1,0,1];
    
    % check if any neighborhood is not a dam (-1 as dam)
    is_any_greater_than_zero = false;
    idx = 0;
    for direction = 1 : 8
        ngb_row = row + drow(direction);
        ngb_col = col + dcol(direction);

        if (ngb_row < 1 || ngb_row > HG)
            continue;
        end
        
        if (ngb_col < 1 || ngb_col > WD)
            continue;
        end
        
        idx = idx + 1;
        neighbors(idx) = tlabels(ngb_row, ngb_col); % append into a list
        is_any_greater_than_zero = is_any_greater_than_zero || (tlabels(ngb_row, ngb_col) >= 0);
    end
    
    
    if (is_any_greater_than_zero == true)
        neighbors(neighbors == -1) = inf;
        ngbMin = min(neighbors);
        if (ngbMin ~= inf)
            final(row,col) = ngbMin;
            flag = 1;
        end
        
    end
        
end

function [front_X, front_Y,label] = neighborlist_watershed(imgMatr, row, col, label, grays, front_X, front_Y)
    % ref: https://github.com/Akbonline/Watershed-Segmentation/blob/main/neighborlist_watershed.m
    global HG;
    global WD;
    
    % neighborhood connectivity
    drow = [-1,-1,-1, 0,0, 1,1,1];
    dcol = [-1, 0, 1,-1,1,-1,0,1];
    
    for direction = 1 : 8
        ngb_row = row + drow(direction);
        ngb_col = col + dcol(direction);

        if (ngb_row < 1 || ngb_row > HG)
            continue;
        end
        
        if (ngb_col < 1 || ngb_col > WD)
            continue;
        end
        
        if (imgMatr(ngb_row, ngb_col) == grays && label(ngb_row, ngb_col) == -1)
            label(ngb_row, ngb_col) = label(row, col);
            front_X=[front_X ngb_row];
            front_Y=[front_Y ngb_col];
        end
    end
    
end

function final = floodfill_separate(seed, imgMatr, color, final)
    % ref: https://github.com/Akbonline/Watershed-Segmentation/blob/main/floodfill_seperate.m
    global HG;
    global WD;
    
    old_color = imgMatr(seed(1), seed(2));
    if old_color == color
        return
    else
        front_X = []; 
        front_Y = [];
        front_X = [front_X seed(1)]; 
        front_Y = [front_Y seed(2)];
        final(seed(1),seed(2)) = color;
        
        while ~isempty (front_X & front_Y)
            last_X = front_X(length(front_X)); % Pop the last value from the Stack (front_X)
            front_X(length(front_X)) = []; % Delete the last value (front_X)
            
            last_Y = front_Y(length(front_Y)); % Pop the last value from the Stack (front_Y)
            front_Y(length(front_Y)) = []; % Delete the last value (front_Y)
            
            imgMatr(last_X, last_Y) = color;
            
            % neighborhood connectivity
            drow = [-1, 0, 0,1];
            dcol = [ 0, -1,1,0];
            
            row = last_X;
            col = last_Y;
            
            for direction = 1 : 4
                ngb_row = row + drow(direction);
                ngb_col = col + dcol(direction);

                if (ngb_row < 1 || ngb_row > HG)
                    continue;
                end

                if (ngb_col < 1 || ngb_col > WD)
                    continue;
                end

                if (imgMatr(ngb_row, ngb_col) == old_color  && final(ngb_row, ngb_col) ~= color)
                    final(ngb_row, ngb_col) = color;
                    front_X = [front_X ngb_row];
                    front_Y = [front_Y ngb_col];
                end
            end
            % endfor
        end
        %end while
    end
    %end if
    
end

