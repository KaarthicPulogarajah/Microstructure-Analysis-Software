% imgReal = imread('C:\Users\Kaarthic\Downloads\deltahacks 5\p2mask_np_7.png');
fileName = cell2mat(filePath);
img = imread(fileName);

img = histeq(img);
% figure;
% imshow(img);
img2 = img;
img2 = imgaussfilt(img2,100);
% figure;
% imshow(img);

se = strel('disk',100);
background = imopen(img2,se);
background = background*1.2;
%background = histeq(background);

I2 = img;

xy = edge(I2, 'canny');
regionSizes = regionprops(xy, 'Area');
areas = cell2mat(struct2cell(regionSizes));
areas(areas < 100) = nan;
figure('NumberTitle', 'off', 'Name', 'Grain sizes (pixels)');
h = histogram(areas);

figure('NumberTitle', 'off', 'Name', 'Grains and Boundaries');
imshow(xy);


I2 = wiener2(I2, [30 30]);

% figure;
% imshow(I2);

%see dark parts
for i =1:8
    I2 = I2 - background/4;
    I2 = histeq(I2);
    I2 = I2 *1.4;
end

% see light parts
I3 = img;
I3 = wiener2(I3, [30 30]);
for i =1:3
    I3 = I3 - background/3;
    I3 = histeq(I3);
    I3 = I3 *1.3;
end

% figure;
% imshow(I2);
% figure;
% imshow(I3);

[r,c] = size(img);
total = r*c;

% figure;
% imshow(I2);

%zero is black
IBW = zeros(r,c);
IBW2 = zeros(r,c);
threshold = 50000;

for i = 1:r
    for j = 1:c
        if I2(i,j) > threshold
            IBW(i,j) = 1;
        else
            IBW(i,j) = 0;
        end
        
        if I3(i,j) > threshold
            IBW2(i,j) = 1;
        else
            IBW2(i,j) = 0;
        end
        
    end
end

% figure;
% imshow(IBW);
% 
% figure;
% imshow(IBW2);

mask = ceil((IBW + IBW2)/2);

% figure;
% imshow(mask);

white = 0;
mask2 = nan(r,c);
mask3 = nan(r,c);

% mask = im2bw(imgReal);

for i = 1:r
    for j = 1:c
        sum = 0;
        if i > 1 && j > 1 && i < r && j < c
            sum = mask(i+1,j+1) + mask(i+1,j) + mask(i+1,j-1) + mask(i,j+1) + mask(i,j-1) +mask(i-1,j+1) + mask(i-1,j) + mask(i-1,j-1);  
        end

        if sum > 0
            mask2(i,j) = 1;
        else
            mask2(i,j) = mask(i,j);
        end
        if mask(i,j) ~= 0
            white = white +1;
        end
    end
end

figure('NumberTitle', 'off', 'Name', 'Microstructure mask');
imshow(mask2);

lightPhasePercent = white/total*100
darkPhasePercent = 100 - lightPhasePercent


