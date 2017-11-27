clear all;
close all;

% Import images
sdirectory = '20170916_R58_60K_treated';
pic.files = dir([sdirectory '/*.jpg']);

% Call createMask function - this function has two outputs: 
%       1) masked RBG image (pixels that are not within a certain range of HSV
%       values are masked (blacked out))
%       2) binary mask image (same as first image, but non-black pixels are white)
%     
%       The first image is used to sum the total intensity of red pixels
%       using the Sum_red file. The second image is used to find the
%       total number of red pixels by summing the number of white pixels.   

SumIntensity = zeros(length(pic.files),1);
SumPixels = zeros(length(pic.files),1);
counter = 1;

    for k = 1:length(pic.files)
        filename = [sdirectory '/' pic.files(k).name];
        this_image = imread(filename);
        [BW,Masked] = createMask(this_image);
        figure(k);
        imshow(Masked);
        
        % Determine total intensity of red pixels from masked RBG image
        red_channel = Masked(:,:,1);
        red_fluor = sum(red_channel(:));
        SumIntensity(counter,1) = red_fluor;
        this_file1 = fopen('SumIntensity.txt','a');
        fprintf(this_file1, '%d %s', red_fluor, filename);
        fprintf(this_file1,'\n\r');
        
        % Determine total number of red pixels from binary mask image 
        red_pixels = sum(BW(:)==1);
        SumPixels(counter,1) = red_pixels;
        this_file2 = fopen('SumPixels.txt','a');
        fprintf(this_file2,'%d %s', red_pixels, filename);
        fprintf(this_file2,'\n\r');
        
        counter = counter + 1;
    end