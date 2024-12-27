% Automatic Number Plate Detection
% Read the input image
inputImage = imread('car_image.jpg'); % Replace with your image file
imshow(inputImage);
title('Original Image');

% Convert the image to grayscale
grayImage = rgb2gray(inputImage);

% Perform edge detection
edgeImage = edge(grayImage, 'Canny');
figure;
imshow(edgeImage);
title('Edge Detection');

% Apply morphological operations to close gaps in edges
se = strel('rectangle', [5, 15]); % Structuring element
dilatedImage = imdilate(edgeImage, se);
figure;
imshow(dilatedImage);
title('Dilated Image');

% Label connected components in the image
[L, num] = bwlabel(dilatedImage);

% Find bounding boxes for connected components
props = regionprops(L, 'BoundingBox', 'Area');

% Initialize variables for number plate region
plateRegion = [];
maxArea = 0;

% Filter regions based on aspect ratio and area
for i = 1:num
    boundingBox = props(i).BoundingBox;
    area = props(i).Area;
    aspectRatio = boundingBox(3) / boundingBox(4); % Width/Height

    % Check for aspect ratio and area criteria
    if aspectRatio > 2 && aspectRatio < 6 && area > 1000
        if area > maxArea
            maxArea = area;
            plateRegion = boundingBox;
        end
    end
end

% Extract and display the number plate region
if ~isempty(plateRegion)
    plateImage = imcrop(inputImage, plateRegion);
    figure;
    imshow(plateImage);
    title('Detected Number Plate Region');
else
    disp('No number plate detected.');
end

% Optional: Perform OCR (Optical Character Recognition)
if exist('plateImage', 'var')
    text = ocr(plateImage);
    disp('Detected Text:');
    disp(text.Text);
end
