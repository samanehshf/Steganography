%input------> stego image & key for extracting
%output----->message
%All processes are similar to embedding procedure
%here, the best places of measuerement y3 that have been embedded are
%fined.then 0,1 messages extracted from y2.
function [m_extract,TD1]=extract(stego,picw_s,perm,project_folder)   % picw_s , perm are keys
sidelength = 256;
N =65536;
M=50000;
l_message=100;
best_plce=zeros(1,l_message);
m_extract=zeros(1,l_message);
A = @(x,mode) dfA(x,picw_s,perm,mode);
%*_*_*_*_*_*_*_*_*_*_set the optional paramaters fo cs procedure*_*_*_*_**_
opts= optss();
%-*-*-*-*-*-*-*-*-*-*-*-*sub sampling & measurement matrix*-*-*-*-*-*-*-*-*
[S1,S2,S4,sub1_measure,sub2_measure,sub3_measure,var_wc]=measurement_matrix(stego,picw_s,perm,project_folder);%function for subsampling & generate measueremnt matrix y1,y2,y3
%*_*_*_*_*_*_*_*_*_*_*_*find best place in measurement matrix y3 for extracting_*_*_*_*_**_*_*_*_*_*_*_*_
rand_samples_ex=sub3_measure;
s=1;
t=1;
sum_histgram=0;
for k=1:M
   if s~=l_message+1
        rand_samples_ex(k)=sub1_measure(k)+sign(sub1_measure(k))*80;
        cd(strcat(project_folder,'\cs'))
        [reconstruct3] = TVAL3(A,rand_samples_ex,sidelength,sidelength,opts);
        cd(project_folder) 
        reconstruct3=idct2(reconstruct3);
   %*_*_*_*_*_*local windows for stego object _*_*_*_*_*_*_
 cd(project_folder)
  var_ws= variance(reconstruct3);
 %-*-***********diffrence variance*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      Diff_var=var_wc-var_ws;
      Map_Diff_var=mapping(Diff_var,min(Diff_var),max(Diff_var),0,1);
      [HMap_Diff_var,VMap_Diff_var]=hist(Map_Diff_var,10000);               %frequency of histogram plot
  %*_*_*_*_*_*_*_*_*_*_*_*_*_*identify TD1 *_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*
       if t==1                                                             % just once determine TD2 base on n_sub_2v_n variable & Just run once
         for ii=1:10000
             percent_diff_var=0.55*length(Map_Diff_var);                   %60 percent of blocks variance diffrent 
            if sum_histgram<(percent_diff_var)
                  sum_histgram=sum_histgram + HMap_Diff_var(ii);
            else
                break;
            end    
         end      
          TD1=VMap_Diff_var(ii-1);
          t=t+1;
          Lmap_Diff_var=length(Map_Diff_var(Map_Diff_var>TD1));            %condition for number of sub_2v_n>TD1
          TD2=Lmap_Diff_var-130;
      end
  %*_*_*_*_*_*_*_*_*_*In this sample bit is embedded *_*_*_*_*_*_*_*_*
      if (Lmap_Diff_var)< TD2 
          best_plce(s)=k;    
          s=s+1;     
      end
   else
       break;
       %rand_samples = b3;
   end
rand_samples_ex=sub3_measure;
   
end
%*_*_*_*_*_*_*_*_extract 0,1 bit from best place that is finded_*_*_*_*_*_*
ss=1;
if s>l_message
for i=1:M
    if ss~=l_message+1
        result=abs(sub2_measure(best_plce(i))-sub1_measure(best_plce(i)));
        if result<15
            m_extract(ss)=0;
            ss=ss+1;
        else
            m_extract(ss)=1;
            ss=ss+1;
        end 
    else
        break;
    end    
end 
end
