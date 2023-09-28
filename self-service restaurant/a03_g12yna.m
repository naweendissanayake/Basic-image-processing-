clear All;

img =double(imread("input (3)\sample_11.jpg"));
gray_img =rgb2gray(img);

%% PSF =approximation with a linear invariant system: PSF =Point Spread Function
%%----->g[m,n] =h[m,n]*f[m,n] --> obsserve =blur(PSF)*clean -->fft
%%----->G[M,N]=H[M,N]+F[M,N]

%% finding mortion blur kernel angle and lenth = h(m,n)
kernel_img =imread('kernel_morton_blur.png');
kernel_lenth =length(kernel_img); %%183,angle=15(theta)
PSF =fspecial('motion',183,15); %% H[m,n] which is PSF

%% let's find the distored image using Richadson lucy iteration method

PSF = psf2otf(PSF,size(img)); %% PSF 
for i=1:12
    img_fft = fft2(img); 
    PSF_img = PSF.*img_fft; 
    %%to get back the original image we need ifft
    destored_image = ifft2(PSF_img); 
    ratio = double(img)./destored_image; 
    fft_points = fft2(ratio); 
    result = PSF .* fft_points; 
    RL = ifft2(result); 
    RL_image = RL.*img; 
end

figure(1);
subplot(1,2,1),imshow(uint8(img))
title('original image')
 
subplot(1,2,2), imshow(uint8(RL_image))
title('RL restored image')

%5 to make more enhance , wallis operation can be used

% window has to be odd
windowWidth =4;
if mod(windowWidth, 2) == 0
    windowWidth = windowWidth+1;
end
input_image = double(RL_image); 

% smoothing using g blur

    gauss_blur = fspecial('gaussian', windowWidth, 1);
    input_image = convn(input_image, gauss_blur, 'same');

I_ones = ones(size(input_image));
kernel = ones(windowWidth);
sumImage = convn(input_image, kernel, 'same');
countImage = convn(I_ones, kernel, 'same');
% mean
Mean = sumImage ./ countImage;
% covarince matrix
D = convn((input_image - Mean).^2, kernel, 'same') / (windowWidth^2);
% STD
D = sqrt(D);
% wallis filter formula according to the given parameters.
Mean=0.5;
percentage =0.2;
std =1/5;
Amax =3;
G = (input_image - Mean) .* Amax .* std ./ (Amax .* D + std) + percentage * Mean + (1-percentage) * Mean;

G(G < 0) = 0;
max = intmax; %%2147483647 is the max interger value
G(G > 2147483647) = 2147483647;
wallis_operator_img = cast(G, 'like', RL_image);

figure(2);
subplot(1,2,1),imshow(uint8(RL_image))
title('RL restored image')
 
subplot(1,2,2), imshow(uint8(wallis_operator_img))
title('wallis operator contrast image')

%%----------------cropping the plate
%%substrabction
plat = imread('input (3)\sample_00.jpg');
tx=plat-rl;
r_channel =tx(:,:,1);
g_channel =tx(:,:,2);
b_channel =tx(:,:,3);

MASK =binary_mask(a,b,e,q,r);

x_ = [a-r-5; a+r+5];
y_ = [b-r-5; b+r+5];

samples = uint8(zeros(100, 100, 3));
seg = uint8(squeeze(mean(mean(samples))));
p = train(samples);

%% Times Up :(





















