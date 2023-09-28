clear;

plat = imread('input (3)\sample_00.jpg');
plate_gray =rgb2gray(plat);
plat_br=imbinarize(plate_gray,0.5);
%%substrabction
%tx=plat-rl;
%r_channel =tx(:,:,1);
%g_channel =tx(:,:,2);
%b_channel =tx(:,:,3);
%%trying to find plate = used paint to measure those
r = 1053;
a = 1554;
b = 2121;
e = size(plat, 1);
q = size(plat, 2);

function binary_mask =plate_mask(a,b,e,q,r)
binary_mask = plate_mask(e, q);
for x = 1:e
    for y = 1:q
        if (x-a)^2 + (y-b)^2 < r^2
            binary_mask(x,y) = 1;
        end
    end
end
end



