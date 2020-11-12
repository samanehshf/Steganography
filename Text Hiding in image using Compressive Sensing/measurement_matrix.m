function [sub1_1,sub3,sub4,y1,y2,y3 ,var_wc] = measurement_matrix(cover,picw_s,perm,project_folder)
sidelength = 256;
N=65536; 
M=21000;                                                                   %row size for measurement matrix
w_local=4;                                                                 %size of blocks of stego & cover image
first_sort=15000;                                                          %size of sparse
%*_*_*_*_*_*_*_*_*_*_*_*_Define dynamic variables*_*_*_*_*_*_*_*_*_*_*_*_*
var_wc=zeros(1,(sidelength/w_local)*(sidelength/w_local));                 % variance for 4*4 blocks cover image
%*_*_*_*_*_*_*_*_*_*_*_*_generate subimage*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*

sub1= cover (2:2:size(cover,1),2:2:size(cover,1));
%imwrite(uint8(sub1),('sub1.png'));
sub2= cover (1:2:size(cover,1),2:2:size(cover,1));
sub3= cover (2:2:length(cover (:,1)),1:2:length(cover (1,:))); 
sub4= cover (1:2:length(cover (:,1)),1:2:length(cover (1,:)));
%*_*_*_*_*_*_*_*_*_*_*_*_local windows & variance for cover*_*_*_*_*_*_*_*_
cd(project_folder)
var_wc= variance(sub1);
%*_*_*_*_*_*_*_*_*_*_*_*_vector sub1 , sub3 and DCT*_*_*_*_*_*_*_*_*_*_*_*_
sub3_1=sub3;
%var_sub3=var(sub3(:));
sub1_1=sub1;
sub1=dct2(sub1);
sub2=dct2(sub2);
sub3=dct2(sub3);
sub1=sub1(:);
sub2=sub2(:);
sub3=sub3(:);
%*_*_*_*_*_sort sub1 , sub3 and select 25000 first values*_*_*_*_*_*_*_*_*_
[~, index_sub1]=sort(abs(sub1),'descend');
%[~, index_sub3]=sort(abs(sub3),'descend');
id_sub1 = 1:length(sub1);
id_sub2 = 1:length(sub2);
id_sub3 = 1:length(sub3);
id_sub1(index_sub1(1:first_sort)) = [];
id_sub2(index_sub1(1:first_sort)) = [];
id_sub3(index_sub1(1:first_sort)) = [];
%*_*_*_*_*_return 2000 first to correct position in sub1 , sub3*_*_*_*_*_*_
sub1(id_sub1) = 0;     
sub2(id_sub2) = 0;     
sub3(id_sub3) = 0;         %jump number
%*_*_*_*_*__multiple sub1 , sub3 with measurement matrix*_*_*_*_*_*_*_*_*_*
cd(strcat(project_folder,'\cs')) 
A = @(x,mode) dfA(x,picw_s,perm,mode);
y1 = A(sub1,1);                       %measurement matrix y1
y2 = A(sub2,1);                       %measurement matrix y2
y3 = A(sub3,1);                       %measurement matrix y3

end

