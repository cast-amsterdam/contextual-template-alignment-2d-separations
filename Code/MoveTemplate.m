%%
% This code is part of the work entitled "Contextual automated template alignment for 2D group type separations with univariate detection"
% by Nino B. L. Milani, Ferry de Kruijff, Alan R. Garcia Cicourel, Rob Edam, Tijmen S. Bos, and Bob W. J. Pirok.
%%
%% univeral template mover 
% the required inputs are listed below
%
% note o and a should be alighend prior to using this script. meaning the
% same row of the matrixes of o and a correspont to the same peak in
% different chromatograms. 
%% required inputs 
o = %apexes of the orignal data set (first column 1d time in min; second column 2d time in sec)
a = %alighend new data points corresponding to the order of "o" (first column 1d time in min; second column 2d time in sec)
temp_names = % name of the classes organised per box
temp_xpoints = %template x coordinates organised per box
temp_ypoints = %template y coordinates organised per box
m1 = %normalization for each dimension usale the maximum
w = [1, 100, 0.1, 0.0001]; % define weights for point selection
%%

for i = 1:length(temp_xpoints) 
        % select each box
        nodes_o = [[temp_xpoints{i},temp_xpoints{i}(1)]', [temp_ypoints{i},temp_ypoints{i}(1)]']; %selet one of the boxes in the existing template 
        nodes_a = zeros(size(nodes_o)); %create space to store new box
        for n = 1:size(nodes_o,1) 
            % select each node in the box and move it using the MoveNode
            % function 
            node = nodes_o(n,:);
            [x_int_a,y_int_a,scores,at,ac] = MoveNode(o,a,node,m1,w);
            nodes_a(n,1) = x_int_a;
            nodes_a(n,2) = y_int_a;
        end
        % perform error correction
        
        % find non finite values
        finloc = ~or(~isfinite(nodes_a(:,1)), ~isfinite(nodes_a(:,2)));
        nodes_a(~finloc,:) = nodes_o(~finloc,:);
        
        % find out-of-bount values
        OfBloc  = or(or(nodes_a(:,1) > (m1(1)*1.01),nodes_a(:,1) < m1(1)*-0.01), or(nodes_a(:,2) > (m1(2)*1.01), nodes_a(:,2) < m1(2)*-0.01));
        nodes_a(OfBloc,:) = nodes_o(OfBloc,:);
        
        % find other outliers
        DFM_o = sqrt((nodes_o(:,1) - mean(nodes_o(:,1))).^2 + (nodes_o(:,2) - mean(nodes_o(:,2))).^2);
        DFM_a = sqrt((nodes_a(:,1) - mean(nodes_a(:,1))).^2 + (nodes_a(:,2) - mean(nodes_a(:,2))).^2);
        redoloc = or(abs(DFM_o - DFM_a) > 6 .* median(abs(DFM_o - DFM_a)),or(~finloc,OfBloc));
        redolist = nodes_o(redoloc);
        
        % Calculate deviation and adjust accordingly 
        dx = mean(nodes_o(~redoloc,1))-mean(nodes_a(~redoloc,1));
        dy = mean(nodes_o(~redoloc,2))-mean(nodes_a(~redoloc,2));
        redoinx = find(redoloc);
        for r = 1:size(redolist,1) 
            nodes_a(redoinx(r),1) = nodes_o(redoinx(r),1) - dx;
            nodes_a(redoinx(r),2) = nodes_o(redoinx(r),2) - dy;
        end
        
        % store new template
        NewTemplate(i).xpoints = nodes_a(:,1);
        NewTemplate(i).ypoints = nodes_a(:,2);
        NewTemplate(i).names = temp_names{i};
end
   
