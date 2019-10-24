function [stego,psnr_stego,best_plce,TD2,TD1]=embedding(cover,picw_s,perm,message,project_folder) % picw_s , perm are keys
%*_*_*_*_*_*_*_*_*_*_*_*_Define constant variables*_*_*_*_*_*_*_*_*_*_*_*_
sidelength = 256;
M=21000;                                                                   %row size for measurement matrix
l_message=50;                                                             %lenght of message
l_cover=512;
stego=zeros(l_cover);
best_plce=zeros(1,l_message);                                              %maintain best place for embedding
%*_*_*_*_*_*_*_*_*_*_set the optional paramaters fo cs procedure*_*_*_*_**_
opts= optss();
%*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*read current image*_*_*_*_*_*_*_*_*_*_*_*_*

[r,c,h]=size(cover);
         if h==3                                                           %for cover 512*512*3
             cover = rgb2gray(cover);                                      %rgb2gray cover 
         end
cover=double(cover);
cd(project_folder)
%-*-*-*-*-*-*-*-*-*-*-*-*sub sampling & measurement matrix*-*-*-*-*-*-*-*-*
[sub1_1,sub3_1,sub4,y1,y2,y3,var_wc]=measurement_matrix(cover,picw_s,perm,project_folder);%function for subsampling & generate measueremnt matrix y1,y2,y3
%----------------------select best place for embedding---------------------
A = @(x,mode) dfA(x,picw_s,perm,mode);
s=1;
rand_samples=y3;
t=1;
sum_histgram=0;
for k=1:M
    if s~=l_message+1         % for all message
        %rand_samples(k)=y1(k)+sign(y1(k))*80;                              %modify one bits of y1     
 cd(strcat(project_folder,'\cs'))
        [reconstruct3] = TVAL3(A,rand_samples,sidelength,sidelength,opts); %recounstruct rand_samples
        cd(project_folder) 
ps=psnr(sub3_1,reconstruct3(:),3000);        
reconstruct3=idct2(reconstruct3);
  %*_*_*_*_*_*_*_*_*_*local windows for stego object _*_*_*_*_*_*_*_*_*_*_
  cd(project_folder)
  var_ws= variance(reconstruct3);
  %*_*_*_*_*_*_*_*_*_*_*_*_*_*identify TD1 & TD2 *_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*
      Diff_var=var_ws-var_wc;                                              %diffrence variance between blocks of cover and stego image
      map_Diff_var=mapping(Diff_var,min(Diff_var),max(Diff_var),0,1);      %mapping between 0,1
      hist(map_Diff_var,10000)
      [Hmap_Diff_var,Vmap_Diff_var]=hist(map_Diff_var,10000);                          %frequency of histogram plot
      if t==1                                                              %just once determine TD2 base on n_sub_2v_n variable & Just run once
             percent_diff_var=0.60*length(map_Diff_var);                   %60 percent of blocks variance diffrent 
             TD2=0.35*length(map_Diff_var);
          for ii=1:10000

             if sum_histgram<(percent_diff_var)
                  sum_histgram=sum_histgram+ Hmap_Diff_var(ii);
            else
                break;
            end    
         end
          TD1=Vmap_Diff_var(ii-2);
          t=t+1;
         % Lmap_Diff_var=length(map_Diff_var(map_Diff_var>TD1));            %condition for number of sub_2v_n>TD1
         % TD2=Lmap_Diff_var-900;
      end
   %*_*_*_*_*_*_*_*_*_*identify best places for embedding *_*_*_*_*_*_*_*_*
     
      Lmap_Diff_var=length(map_Diff_var(map_Diff_var>TD1));                %condition for number of sub_2v_n>TD1
      if (Lmap_Diff_var)< TD2                                              %second condition for numbr of bad blocks
          best_plce(s)=k;                                                  %this sample of measurement matrix y3 is once of best places for embedding  
          s=s+1;                                                           %next bit of message
      end
     else
       break;                                                              %best places for all bits of message are finded
    end
rand_samples=y3;
 end
%*_*_*_*_*_*_*_*_*_**embedding in measurement matrix y2 *_*_*_*_*_*_*_*_*_*

if s>l_message                                                             %if all best places have been finded for all bits of message
  for i=1:l_message
     y2(best_plce(i))=y1(best_plce(i))+sign(y1(best_plce(i)))*80*message(i);%embedding bits in y2 measurement
     % cd(strcat(project_folder,'\dataset'))
  end  
      cd(strcat(project_folder,'\cs'))
      [reconstruct3] = TVAL3(A,y2,sidelength,sidelength,opts);
      cd(project_folder);
      ps=psnr(sub3_1 ,reconstruct3(:));
      reconstruct3=idct2(reconstruct3);
      stego(2:2:size(stego,1),2:2:size(stego,1))=sub1_1;
      stego(1:2:size(stego,1),2:2:size(stego,1))=reconstruct3;
      stego(2:2:size(stego,1),1:2:size(stego,1))=sub3_1; 
      stego(1:2:size(stego,1),1:2:size(stego,1))=sub4;
      psnr_stego=psnr(uint8(stego),uint8(cover));
      %copyfile(stego,strcat(project_folder,'\embedded_images'));
  else
   stego=[];
   psnr_stego=0;
 end
%*_*_*_*_*_*_*_*_*compose 4 sub samples for creating stego image_*_*_*_*_*

    
end


