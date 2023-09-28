%% Reading folder path with 15 images as a loop
file ='input';
filename =dir(fullfile(file,'*.jpg'));
totalfile =numel(filename);

for i=1:totalfile
    images =fullfile(file,filename(i).name);
    rgb = imread(images);
    graylist = rgb2gray(rgb);
    %imshow(graylist)

%%histogram /image streching
[rows,columns] =size(graylist);
out =zeros(rows,columns);
%%Slop
x1 =min(min(graylist));
x2 =max(max(graylist));
y1=0;
y2=255;
%interpolation
m = (y2-y1) / (x2-x1);
c = y1-m*x1;
for q=1:rows
    for j=1:columns
        out(q,j) = m*graylist(q,j)+c;
    end
end

 %figure
 %imshow(graylist)
 %imhist(graylist)

 %%I dont thing we need to convert into binary form!!!!
streched_edge =edge(graylist,"sobel","both");
figure(1)
subplot(2,2,1),imshow(graylist);
subplot(2,2,2),imshow(streched_edge);
fast_fft =fft2(graylist);
%%magnitude
mag =abs(fast_fft);
%imshow(mag)
%%shift
mag1 =fftshift(mag);
%%maximum point
max_pixel = max(max(mag1));
%% maximum point location(columns and rows) /
[columns, rows] =find(mag1==max_pixel,1);
mag1(rows-100:rows+100,columns-100:rows+100,:) =0;
[x,y] = find(mag1==max_pixel,1);
%% finding theta /angle
R =(columns-y) / (rows-x);
Theta =atand(R); %% Sir! sometimes this line dosent work my computer but i found angle/ == 35.4312/it will work your pc%% I will attahced an image as a profe
%%rotation / Straighten image
rot_images=imrotate(streched_edge,35.4312*-1);
% figure
% imshow(rot_images)
%%log function
mag2=log(1+abs(mag1));
%figure
%imshow(mag2)

%%Let's find Hough space
w = size(rot_images,1);
h = size(rot_images,2);
r2 = ceil(hypot(w,h));
r=40; 
H = zeros(2*r2+1,2*r2+1); %%Accumilator matrix
   
    for x=1:w
        for y=1:h
            
            if(rot_images(x,y))>0
                for theta = 1:360

                b = y - r * sin(theta * pi / 180);  
                a = x - r * cos(theta * pi / 180); 

                H(round(a),round(b)) = H(round(a),round(b))+1;


                end
            end
        end
        
    end

end
imagesc(H); %% Hough Space
%%Finding Circle coordinates

x=[];
y=[];
  
 for t=1:8
     max_H =max(max(H));
     [X,Y] =find(H==max_H,1);
     x(t) =X;
     y(t) =Y;
     H(x-50:x+50,y-50:y+50,:) =0;
 end

s = sort(y+x);
f =1;
r = 0.5; %% kernel size
th =9425; % threshold_pixel_value of the cicles 

    for n=1:8
        for m=1:8
            if x(m)+y(m)==s(n)
                Crop_C =rot_images(x(m)-50:x(m)+50,y(m)-50:y(m)+50,:);
% %             Convolution to find the cross of the cicles 
                kernel = fspecial("disk",r);
                cov_imgs = conv2(kernel,Crop_C);
                figure(2)
                subplot(4,2,f),imshow(cov_imgs);
                figure(3)
                subplot(4,2,f),histogram(cov_imgs);%% histogram of the cicles
                f = f+1;               
            end
        end
    end
%% ----END----- this code works for all the images but to show the results(I decided not to create processor function) I figured out (: Thanks you)







