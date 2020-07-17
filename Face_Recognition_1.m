%You are free to use, modify or distribute this code
 
loaded_Image=load_database();

%memilih gambar yang akan diuji
%pakai fungsi round kalau mau random
random_Index = round(400*rand(1,1));

% gambar yg kan dibandingkan
random_Image = loaded_Image(:,random_Index);

% memilih gambar yg lain untuk dibandingkan
rest_of_the_images = loaded_Image(:,[1:random_Index-1 random_Index+1:end]);         

%banyak fitur yang akan direduksi (semakin kecil maka semakin tidak akurat,
%range 1-399)
image_Signature=20;

%mencari rata2,penggandaan rata2,perhitungan nilai rata2 nol, dan
%pembentukan matrik kovarian
white_Image = uint8(ones(1,size(rest_of_the_images,2)));
mean_value = uint8(mean(rest_of_the_images,2));                
selsih = uint8(single(mean_value)*single(white_Image));
mean_Removed = rest_of_the_images- selsih; 
L = single(mean_Removed)'*single(mean_Removed);

% mencari eigenvalue dan eignvector
% v eigen vektor, D eigen value
[V,D] = eig(L);
V = single(mean_Removed)*V;
V = V(:,end:-1:end-(image_Signature-1));

%membuat matriks baru yang berisi 20 signature tiap gambar sebanyak 399
%gambar //memberi eigenface pada tiap gambar
all_image_Signatire=zeros(size(rest_of_the_images,2),image_Signature);
for i=1:size(rest_of_the_images,2);
    all_image_Signatire(i,:)=single(mean_Removed(:,i))'*V;  
end

subplot(121);
imshow(reshape(random_Image,112,92));
title('Looking for this Face','FontWeight','bold','Fontsize',16,'color','red');

%menambahkan signature pada gambar yang dipilih //memberi eigenface pada
%gambar yg dipilih
subplot(122);
p=random_Image-mean_value;
s=single(p)'*V;
z=[];

%membandingkan signature gambar dipilih dengan yang tersisa dengan cara
%mengurangi image signature dari 399 gambar dengan image signature gambar
%yang dipilih
for i=1:size(rest_of_the_images,2)
    z=[z,norm(all_image_Signatire(i,:)-s,2)];
    if(rem(i,20)==0),imshow(reshape(rest_of_the_images(:,i),112,92)),end;
    drawnow;
end

%mencari perbandingan signature/eigenface paling sedikit
[a,i]=min(z);
subplot(122);

%menampilkan gambar signature yang memiliki perbandingan paling sedikit
imshow(reshape(rest_of_the_images(:,i),112,92));
title('Recognition Completed','FontWeight','bold','Fontsize',16,'color','red');