clock;
% img = imread('C:\Users\Kaarthic\Downloads\deltahacks 5\p2mask_np_7.png');
fileName = cell2mat(filePath);
img = imread(fileName);

[img, xx] = wiener2(img, [37 37]);
% figure;
% imshow(img)

img = imsharpen(img, 'Radius', 1.0);
% figure;
% imshow(img)

img = imadjust(img, [0.5 1]);
% figure;
% imshow(img)

img = im2bw(img, 0.1);
% figure;
% imshow(img)

[r,c] = size(img);
white = 0;
sum = 0;
total = r*c;
image2 = nan(r,c);
image3 = nan(r,c);

for i = 1:1:r
    for j = 1:1:c
        
        sum = 0;
        if i > 1 && j > 1 && i < r && j < c
            sum = img(i+1,j+1) + img(i+1,j) + img(i+1,j-1) + img(i,j+1) + img(i,j-1) +img(i-1,j+1) + img(i-1,j) + img(i-1,j-1);  
        end

        if sum > 0
            image2(i,j) = 1;
        else
            image2(i,j) = img(i,j);
        end
        
    end
end

for i = 1:1:r
    for j = 1:1:c
        
        sum = 0;
        if i > 1 && j > 1 && i < r && j < c
            sum = image2(i+1,j+1) + image2(i+1,j) + image2(i+1,j-1) + image2(i,j+1) + image2(i,j-1) +image2(i-1,j+1) + image2(i-1,j) + image2(i-1,j-1);  
        end

        if sum > 0
            image3(i,j) = 1;
        else
            image3(i,j) = image2(i,j);
        end
        
        if image3(i,j)
            white = white +1;
        end
    end
end

lightPhasePercent = white/total*100
darkPhasePercent = 100 - lightPhasePercent

figure('NumberTitle', 'off', 'Name', 'Microstructure mask');
imshow(image3);
% figure;
% imshow(image2);
% figure;
% imshow(img);
% imwrite(image3, 'C:\Users\Kaarthic\Downloads\deltahacks 5\target 2\test5x.png');


