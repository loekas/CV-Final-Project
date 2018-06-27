
close all; clear all; %clc;
delete(findall(0,'Type','figure'));
load framesDatabaseCastle;
load matchesDatabaseCastle;
%load framesDatabaseTeddy;
%load matchesDatabaseTeddy;
 
% selectedMatches = size(matchesDatabase{1,1},2);
% selectedMatches = 1:20; % debug
nn = 0;

generateGraphicsOnly = 1;

if generateGraphicsOnly
    % ENABLE ONLY TO GENERATE GRAPHICS
    % pick less elements for visualization, turn numbers into black and zeros into white, saves as image
    load pvmCastle
    %load pvmTeddy
    pvm_visual = pvm(:,1:20:end); % 40 is good for Teddy, 20 for Castle
    pvm_visual(pvm_visual ==0) = nan;
    pvm_visual(pvm_visual > 0) = 0;
    pvm_visual(isnan(pvm_visual)) = 255;
    imFinal = uint8(pvm_visual);
    figCommon = figure(1);
    %imFinal = imresize(imFinal, [round(10*size(imFinal,1)), round(1*size(imFinal,2))]); --- resize externally with irfanviewer
    imshow(imFinal);
    imwrite(imFinal,'somethingT.jpg', 'jpg');
    imwrite(imFinal,'somethingT.png', 'png');
    imwrite(imFinal,'somethingT.bmp', 'bmp'); % use resize without resampling on irfanviewer with height using an extra zero
    delete(findall(0,'Type','figure'));
    return;
end


for i = 1:size(matchesDatabase,1) % all frames
    
    fprintf("frame %.0f\n", i);
    
    for j = 1:size(matchesDatabase{i,3},2) % follow every point
        
        if (matchesDatabase{i,3}(1,j)==0) && (matchesDatabase{i,4}(1,j)==0) % ignore used-up points
            continue;
        end
        
        nn = nn + 1; % the only one advancement of 'nn'
        pvm(i,nn) = 1; % current frame
        xToFind = matchesDatabase{i,3}(1,j); 
        yToFind = matchesDatabase{i,4}(1,j);
        matchesDatabase{i,3}(1,j) = 0; % use once
        matchesDatabase{i,4}(1,j) = 0; % use once
        %fprintf("frame %d, point %d, looking for x %.0f and y %.0f in the remaining %.0f frames\n", i, j, xToFind, yToFind, size(matchesDatabase,1)-i);
        
        if i ~= (size(matchesDatabase,1)-1) % all but the last frame
            startFromHere = i+1;
        else % add relations between last and first
            startFromHere = 1; 
        end
        
        alive = true;
        
        for k = startFromHere:size(matchesDatabase,1) % all remaining frames
            
            %fprintf("frame %d, point %d, looking for x %.0f y %.0f in frame %d\n", i, j, xToFind, yToFind, k);
            
            if alive ~= true % stop following a point tht has been not visible even for one frame
               break; 
            end
            
            found = false; 
            for m = 1:size(matchesDatabase{k,1},2)
               %fprintf("frame %d, point %d, looking for x %.0f y %.0f in frame %.0f, checking point %.0f\n", i, j, xToFind, yToFind, k, m);
                
%                fprintf("frame %d, point %d, looking for (x %.0f y %.0f) in frame %.0f, checking point %.0f (x %.0f y %.0f)\n", ... 
%                    i, j, xToFind, yToFind, k, m, matchesDatabase{k,1}(1,m), matchesDatabase{k,2}(1,m)  );
               
               if ((xToFind == matchesDatabase{k,1}(1,m)) && (yToFind == matchesDatabase{k,2}(1,m)))
                    %fprintf("frame %d, point %d, FOUND x %.0f y %.0f in frame %d, point %d\n", i, j, xToFind, yToFind, k, m);
                    found = true; % FROM now on continuity is expected
                    pvm(k,nn) = 1;
                    xToFind = matchesDatabase{k,3}(1,m); % get next coordinates
                    yToFind = matchesDatabase{k,4}(1,m); % get next coordinates
                    break;
               end % of if match
            end
            
            if found == false
                alive = false;
            end
            
        end
    end
    
    rrrrr=1; % for breakpoint purposes only
end

save pvmCastle pvm