function Points = Merge3DPointclouds(Points_3,Points_4,Blocks_3,Blocks_4)
%UNTITLED4 Summary of this function goes here

% create empty pointmatrix
Points = [];
% matches, containing the match index and the view
Match  = [];


for i = length(Points_3):-1:2
% Match points in 3-point view of current image, to the 4-view points in
% the previous image
%  [~, ~, IB] = intersect(match_quad', match_triple', 'rows', 'stable');
    [~,~,I_3]    = intersect(Blocks_4{i-1}(2:end,:)',Blocks_3{i}','rows','stable');
    Points_34   = Points_3{i}(:,I_3);
    
% Find the best transform between 3-point and 4-points to compute the
% overall transform
    [~,~,T] = procrustes(Points_4{i-1}',Points_34');
    Points_new = T.b*Points_3{i}'*T.T+T.c(3,:);
    
    % Append the points to the previous 3-point matrix
    Points_3{i-1} = [Points_3{i-1},Points_new'];
    
    % fill in the match matrix
    Matches = [Blocks_3{i}(1,:);i*ones(1,length(Blocks_3{i}))];
    Match = [Matches,Match];    
end

Matches = [Blocks_3{1}(1,:);ones(1,length(Blocks_3{1}))];
Match = [Matches,Match];    
Points = [Points_3{1};Match];
end

