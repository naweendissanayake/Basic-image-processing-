%%Image loading
Pool_Img1 = imread('test_image_1.jpg');
Pool_Img2 = imread('test_image_2.jpg');
Pool_Img3 = imread('test_image_3.jpg');
empty_img = imread('empty.jpg');

%%convert into gray imagers
Pool_Img1_gray = rgb2gray(Pool_Img1);
Pool_Img2_gray = rgb2gray(Pool_Img2);
Pool_Img3_gray = rgb2gray(Pool_Img3);
empty_img_gray = rgb2gray(empty_img);

%% Subraction to get balls
ball_image = Pool_Img2 - empty_img;

%% thresholding
[row, column]  = size(Pool_Img2_gray);
streched_image = zeros(row,column);

x1 = double(min(min(Pool_Img2_gray)));
x2 = double(max(max(Pool_Img2_gray)));
y1 = double(0);
y2 = double(255);
%% linear interpolation
m = (y2 - y1) / (x2-x1) ; % Slope of the image
c = y1 - m*x1;

for i =1:row
    for j =1:column
        streched_image(i,j) = m*Pool_Img2_gray(i,j) +c;
    end
end
%%converting to gray
streched_image = rgb2gray(ball_image);
%%making binary mask
mask_binary = imbinarize(streched_image,0.1);
figure(1)
subplot(1,2,1);imshow(Pool_Img2);title('image 01')
subplot(1,2,2);imshow(mask_binary);title('Mask Image')

%%convolution
r = 30;
kernel = fspecial("disk",r);
%%adding a 0 pad to the Image
padded_img = padarray(mask_binary, 0);
cov_img_1 = conv2(kernel,padded_img);
figure(2)
imshow(cov_img_1);title('covolution image')
colormap('turbo')
colorbar

%% ball shapning
cov_shap = imfill(cov_img_1,'holes'); %% its fill all balls correctly
figure(3)
imshow(cov_shap);title('shap image')
colormap('turbo')

%% counting balls
label =bwlabel(cov_shap); %% labelling balls
max(max(label))
%ball_1 = (label==1);
%figure(4)
%imshow(ball_1)
%colormap('turbo')

%% identify the coordinates
width_pix = size(Pool_Img2,2);
length_pix = size(Pool_Img2,1);

%%converting pixel to cm
width_cm = 200/width_pix;
length_cm = 100/length_pix;

i=1;
max_v=100;

while max_v > 0.01
    max_v = max(max(cov_shap));
    [row, column] = find(cov_shap == max_v,1);

    ball_size = 50;
    dell_size = 70;
    crop_size = 35;

 
    cropping_img = Pool_Img2(row-ball_size:row+ball_size,column-ball_size:column+ball_size,:); %% finding exact location of the balss from RGB image
    cov_shap(row-dell_size:row+dell_size,column-dell_size:column+dell_size) = 0; %% deleting  ball from  mask

    figure(5)
    subplot(4,4,i), histogram(cropping_img);title("( "+row*length_cm+" , "+column*width_cm+" )");

    figure(6)
    subplot(4,4,i), imshow(cropping_img);title("( "+row*length_cm+" , "+column*width_cm+" )");
    crop_ball = Pool_Img2(row-crop_size:row+crop_size,column-crop_size:column+crop_size,:);
 
    i=i+1;

end
%%-------------------------------------------------------------------------------------------END--------

%%deciding value of the balls , I know the 4th part is histogram
%%matching method. I tried but was not work. im sorry for the last part









