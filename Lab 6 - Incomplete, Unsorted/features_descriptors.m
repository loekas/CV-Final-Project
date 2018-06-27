function [features, descriptors] = features_descriptors(filepath, file_extension)
    % # INPUT PARAMETERS: 
    % * filepath = string of the directory containing the haraff.sift and hesaff.sift
    % files
    % * file_extension = a string format of the file extension with
    % asterisk e.g. *.hesaff.sift for affine Hessain SIFT files and *.haraff.sift for affine Haraff SIFT files.  
    % * To generate such features from image file, refer to: http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html
    % # OUTPUT PARAMETRS:
    % * features: Cells containing features
    % * descriptors: Cells containing the descriptors.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Script Author: Ali Nawaz, Delft University of Technology.
    % Aerospace Engineering Faculty [LR]
    % Mechanical, Maritime and Materials Engineering Faculty [3ME]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    addpath(filepath); % Add file directory containing all the files to the run path
    
    lookup = strcat(filepath,file_extension); % look up in this given directory for files with the given extension
    files = dir(lookup); % load file data in the directory
    
    features = {}; % Initialise a cell format to store features for all the images
    descriptors = {}; % Initialise a cell format to store descriptors for all the images
    for k = 1:length(files)
        data = importdata(files(k).name, ' ', 2); % load data from the files
        
        % Organise data for the image. For information regarding the data
        % format, please refer to: http://www.robots.ox.ac.uk/~vgg/research/affine/detectors.html
        x = data.data(:,1)'; % x location of the feature
        y = data.data(:,2)'; % y location of the feature
%         a = data.data(:,3)'; % currently unused
%         b = data.data(:,4)'; % currently unused
%         c = data.data(:,5)'; % currently unused
        desc = data.data(:,6:end)';
        
        features(1,k) = {[x;y]}; % store the feature locations x and y
        descriptors(1,k) = {[desc]}; % store the descriptor information
    end
    
end
