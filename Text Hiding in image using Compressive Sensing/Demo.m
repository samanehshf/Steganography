function demo_lena1
clc;
clear all; close all;
N=65536;                                                                    %size of signal
M=21000;                                                                    %size of measurement Matrix Row
l_message=50;
message=round(rand(1,l_message));

%*_*_*_*_*_*generate picw_s,perm keys for embeding and extracting*_*_*_*_*_
%load('picw_s.mat');
%load('perm.mat');
picw_s=picw_ss(N,M);
    perm=randperm(N); %                                                        %column permutations allowable
    mkdir('embedded_images');
    %*_*_*_*_*_*_*_*_*read dataset image & Definition Dynamic variable_*_*_*_*_
    project_folder =uigetdir('C:\','select project folder');
    imagefiles= dir(strcat(project_folder,'\dataset\*.png'));
    number_file = length(imagefiles);                                           % Number of files found
    psnr_stego=zeros(1,number_file);
    TD2=zeros(1,number_file);                                                   %threshold TD1 for all images        
    TD1=zeros(1,number_file);                                                   %threshold TD1 for extract procedure
    TD1_extract=zeros(1,number_file);                                           %threshold TD2 for all images
    err_rate=zeros(1,number_file);                                              %error rate for all images
    BestPlace_AllImage=zeros(number_file,l_message);                            %best places embedding for all images
    m_extract=zeros(number_file,l_message);
%-------embedding & extracting  procedure for all images in dataset--------
   for i=1:number_file
         currentimage = imagefiles(i).name;
         cd(strcat(project_folder,'\dataset'))
         cover = imread(currentimage);
         cd(project_folder);
         [stego,psnr_stego(i),BestPlace_AllImage(i,:),TD2(i),TD1(i)]=embedding(cover,picw_s,perm,message,project_folder);
         u=isempty(stego);
         if u==0
             cd(strcat(project_folder,'\embedded_images'))
             imwrite(uint8(stego),currentimage)
         end
        % cd(project_folder);
%          [m_extract(i,:),TD1_extract(i)]=extract(stego,picw_s,perm,project_folder);                       %call extracting function 
% %-------------calculate err rate-------------------------------------------
%          x=xor(m_extract(i,:),message);                                                
%          err(i)=nnz(x);  
%          err_rate(i)=err(i)/length(x); 
   end
   
end  





