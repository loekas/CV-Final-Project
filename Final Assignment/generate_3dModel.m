load('matches_0.1.mat')
markerSize = 100;
% load all images
for i = 1:19
    frame1_string = num2str(i+585);
    img = imread(strcat('8ADT8',frame1_string,'.png'));
    matches  = round(feat_comb{i});
    for j = 1:length(matches)
        values = img(matches(2,j),matches(1,j),:);
        rgbframe{i}(:,j) = values(:);
    end
end
% extract pixelvalues
model = PointCloud;

% create point cloud from x/y/z coordinates
pc = pointCloud([model(1,:)' model(2,:)' model(3,:)']);
figure('Name','3D model without colors');
pcshow(pc, 'MarkerSize', markerSize);

pcshow([model(1,:)', model(2,:)', model(3,:)'], rgb)
% show the denoised version
[pcDn denoisedIndexes] = pcdenoise(pc, 'NumNeighbors', 50, 'Threshold', 0.01); % 30, 0.001
figure('Name','3D model with colors, de-noised');
pcshow(pcDn, 'MarkerSize', markerSize);

% adding colors
load featuresDatabaseCastle; % features, to retrieve color
numFrame = model(5,:); % frame number
indexFeature = model(4,:); % feature/region number in frame
rgbValues = [];
for i = 1:length(rgbframe) % re-organize data to fit expectations of pcshow()
    rgbAllFrame{i} = rgbframe{i}'
end

for j = 1:length(model)
    rgb(j,:) = rgbAllFrame{model(5,j)}(model(4,j),:);
end
pc.Color = rgb;
figure('Name','3D model, denoised, with colors');
pcshow(pc, 'MarkerSize', markerSize);
[model(1,:)' model(2,:)' model(3,:)']
% interpolation --- choose the meshgrid according to value range
figure,
x = model(1,denoisedIndexes);     
y = model(2,denoisedIndexes);     
z = model(3,denoisedIndexes);
x_min = min(x(:));  y_min = min(y(:));
x_max = max(x(:));  y_max = max(y(:));
[xq,yq] = meshgrid(x_min:20:x_max, y_min:20:y_max);
zq = griddata(x,y,z,xq,yq);
%mesh(xq,yq,zq);
surfc(xq,yq,zq);
hold on;
plot3(x,y,z,'o', 'MarkerSize', 3);
xlim([x_min x_max]);
ylim([y_min y_max]);
% for now   


