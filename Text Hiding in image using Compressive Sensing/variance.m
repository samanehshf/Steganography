function [var_ws] = variance(reconstruct3)
w_local=4;                                                                 %size of blocks of stego & cover image
sidelength=256;
var_ws=zeros(1,(sidelength/w_local)*(sidelength/w_local));                 % variance for 4*4 blocks stego image
w_s=1;
      for ii=1:w_local:length(reconstruct3)-3
         for jj=1:w_local:length(reconstruct3)-3
           window=reconstruct3(ii:ii+w_local-1,jj:jj+w_local-1);
           var_ws(w_s)=var(window(:));
           w_s=w_s+1;
         end    
      end

end

