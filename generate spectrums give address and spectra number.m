clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Please give following inputs
strip=10; %strip length for background elimination
% samples=12; % no. of data sample for polynomial fitting
% poly_order=4; %order for polynomial fitting
no_of_images=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder=fullfile('D:\PhD data\Experimetal Data\Beamtime 100 Hz May2018\tin5_27May2018\tin5_940nm_SHG');
cd(folder);
ref_img=fitsread('tinspectrum2_0001.fts'); 
figure
imshow(ref_img, [100 500]); %[0 500] is just for the contrast management
[cr_img_1st, im_axis_1st]=imcrop(); %cr_img_1st gives cropped image and im_axis_1st gives the cropping rectangle [xmin ymin width height]
close();
%figure
%imshow(cr_img_1st, [100 115]);
[row_1st,col_1st]=size(cr_img_1st); %no. of rows and columns in cropped image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%reading xaxis from excel file
path='E:\PhD Folder\Data Analysis\Beamtime May 2018 OPA 100 Hz\tin_Beamtime May 2018 OPA 100 Hz\x-axis generation tinspectrum1_0001_tin5_900nm_SHG\x-axis generation tinspectrum1_0001_tin5_900nm_SHG';
xaxis=xlsread(path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

avr_img_1st=zeros(row_1st,col_1st); % blank image having same size as the cropped image
for i=1:no_of_images
    name=sprintf('_%3.4d',  i);  %makes 0001, 0002, 0003..... program works even without this line
    joiname=cat(2,strcat('tinspectrum2',name,'.fts')); %strcat will place '2' and '265' together as 2265 and cat with 2 also does the same thing
    image=fitsread(joiname); %what image is this?
    image2=imcrop(image, im_axis_1st); %to make sure cropped image matches with the previous 
    avr_img_1st=avr_img_1st+double(image2);
    avr_img_1st;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Background
    strip_length=strip;
    [row1,col1]=size(avr_img_1st);
    bkg=(avr_img_1st(1:strip_length,:)+avr_img_1st(row1-(strip_length-1):row1,:));
    bkg_num=sum(sum(bkg))/(2*col1*strip_length); %what is the logic behind this background calculation??
img_plot_1st=double(sum(avr_img_1st-bkg_num));
% img_plot_1st=double(sum(avr_img_1st));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%Pixel to wavelength
% figure(); 
% area(abs(img_plot_1st)); 
% [X_val, Y_val]=ginput(samples);
% close(); 
% harmonics=(9:1:8+length(X_val)); 
% %harmonics=(9:2:14+length(X_val)); 
% P=polyfit(transpose(X_val), harmonics, poly_order); % does polynomial fitting of order .
% X_axis_1st=polyval(P, 1:length(img_plot_1st)); %gives us wavelength values across the whole x axis of cropped image by polynomial evaluation
% X_axis_1st=(1240/860).*X_axis_1st;
figure
img_plot_1st=sum(avr_img_1st); %creates a row vector by summing the matrix.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(xaxis,img_plot_1st,'LineWidth',4); %multiplied by two to mke it  20 shot spectra
%set(gca, 'YScale', 'log')
%xlim([11.4 49.88])
% plot(X_axis_1st./.8552,(img_plot_1st-min(img_plot_1st))./max(img_plot_1st-min(img_plot_1st)),'LineWidth',3)
axis tight
grid on
%ylim([.0011 1.1])
set(gca,'FontSize',16,'FontWeight','bold');
xlabel('Energy (in eV)','FontSize', 16,'FontWeight','bold');
ylabel('Normalized Intensity (log scale) ','FontSize',16,'FontWeight','bold');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row,col]=size(avr_img_1st);
Y=(((row:-1:1)./row))*1.5;
figure
surf(xaxis,Y,(avr_img_1st-bkg_num)./2500);
xlim([11.4 49.88])
view(0,90);
shading interp
axis tight
caxis ([0 0.5]);
%ylim ([0.3 1.3]);
%set(gca,'XTick',30:10:80);


xlabel('Energy (eV)','FontSize', 24);
%xlabel('Harmonic Order','FontSize', 24);
% ylabel('MCP Y-axis (cm)','FontSize', 24);
% ylabel('Divergence (mrad)','FontSize', 24);
colorbar

set(gcf,'color','w');
set(gca,'FontSize',20)















