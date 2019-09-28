%Karthik Kedarisetti
clc
clear all %#ok<CLSCR>
original=imread('lena.jpg');
[original_row,original_col]=size(original);
%elliptic curve function:E=y^2mod(31)=x^3+x+3 mod(31)
%where a=1;b=3;p=31; which satisfies the condition
%4*(a^3)+27*(b^2)=4+243=247mod(31)=30
elliptic_matrix=[[1 6],[1 25],[3 8],[3 23],[4 3],[4 28],[5 3],[5 28],[6 15],[6 16],[9 11],[9 20],[12 10],[12 21],[14 8],[14 23],[15 13],[15 18],[17 2],[17 29],[18 5],[18 26],[20 5],[20 26],[21 4],[21 27],[22 3],[22 28],[23 14],[23 17],[24 5],[24 26],[26 11],[26 20],[27 11],[27 20],[28 2],[28 29],[30 1],[30 30]];
Generator_point=input('enter index from points  :');
private_key_A=input('Enter private key for A within range=[1,30]  :');
n_A=private_key_A;
private_key_B=input('Enter private key for B within range=[1,30]  :');
n_B=private_key_B;
a=1;p=31;
b=3;
x1=elliptic_matrix(Generator_point,1);
y1=elliptic_matrix(Generator_point,2);
public_key_A=multell([x1 y1],n_A,a,b,p);
public_key_B=multell([x1 y1],n_B,a,b,p);
intial_key_K1=multell(public_key_B,n_A,a,b,p);
intial_key_K2=multell(public_key_A,n_B,a,b,p);
K1=multell([x1 y1],intial_key_K1(1,1),a,b,p);
K2=multell([x1 y1],intial_key_K1(1,2),a,b,p);
K11=[K1;K2];
K12=eye(2)-K11;
K12=mod(K12,256);
K21=eye(2)+K11;
K22=-K11;
K22=mod(K22,256);
K=[K11 K12;K21 K22];
%------------------------------------------------
%Encryption
%K=[4 28 253 228;15 18 241 239;5 28 252 228;15 19 241 238];
encrypted=zeros(original_row,original_col);
P_1=zeros(4,1);

for i=1:original_row
    for j=1:original_col-3
        l=1;z=j;
        for k=j:j+3
            P_1(l,1)=original(i,k);
            l=l+1;
        end
        C_1=K * P_1;
        l=1;
        for m=z:z+3
            encrypted(i,m)=mod(C_1(l,1),256);
            l=l+1;
         end
        j=j+4;
    end
end

%decryption

decrypted=zeros(original_row,original_col);
LP_1=zeros(4,1);

for i=1:original_row
    for j=1:original_col-3
        l=1;z=j;
        for k=j:j+3
            LP_1(l,1)=encrypted(i,k);
            l=l+1;
        end
        DC_1= K * LP_1;
        l=1;
        for m=z:z+3
            decrypted(i,m)=mod(DC_1(l,1),256);
            l=l+1;
        end
        j=j+4;
    end
end

%----------------------------------------
%Plotting

figure;
imshow(mat2gray(original))
figure;
imhist(mat2gray(original))
figure;
imshow(mat2gray(encrypted))
figure;
imhist(mat2gray(encrypted))
figure;
%--------------------------------------------
E=entropy(encrypted/255);
disp('entropy of encrypted image : ')
disp(E)



%-----------------------------------------------------------------------
%#########################################################
%Analysis of encryted and decrypted images
%-------------------------------------------------
%NPCR value
sum=0;
for i=1:original_row
    for j=1:original_col
        if(original(i,j)==encrypted(i,j))
           sum=sum+0;
        else
            sum=sum+1;
        end
        
    end
end
NPCR = (sum/(original_col*original_row));
disp('NPCR')
disp(NPCR)


%correlation
  %Correlation coeff Original image horizontal direction
 I=imread('lena.jpg');
xi = I(:,1:end-1);  % original image
yi = I(:,2:end);  % original image
randIndex = randperm(numel(xi));                                   
randIndex = randIndex(1:2000);   
xRandi = xi(randIndex);            
yRandi = yi(randIndex); 
r_xyi = corr2(xRandi(:),yRandi(:));
disp('Correlation coeff Original image horizontal direction:')
disp(r_xyi);
% R=corrcoef(xRandi(:),yRandi(:));
% R_soh=R(2)^2;
subplot(3,2,1)
scatter(xRandi(:),yRandi(:),'.');
title('Scatter plot in horizontal direction for original image')
%Correlation coeff encrypted image horizontal direction
x = encrypted(:,1:end-1);  
y = encrypted(:,2:end);  
randIndex = randperm(numel(x));                               
randIndex = randIndex(1:2000);   
xRand = x(randIndex);  
yRand = y(randIndex);
% R=corrcoef(xRand(:),yRand(:));
% R_seh=R(2)^2;
% disp(R_seh);
r_xy = corr2(xRand(:),yRand(:));
disp('Correlation coeff encrypted image horizontal direction:')
disp(r_xy);
subplot(3,2,2)
scatter(xRand(:),yRand(:),'.');
title('Scatter plot in horizontal direction for encrypted image')
%Correlation coeff Original image vert direction
xiv = I(1:end-1,1:end-1,1);  
yiv = I(2:end,2:end,1); 
randIndex = randperm(numel(xiv));                                   
randIndex = randIndex(1:2000);   
xRandiv = xiv(randIndex);            
yRandiv = yiv(randIndex); 
% R=corrcoef(xRandiv(:),yRandiv(:));
% R_sov=R(2)^2;
% disp(R_sov);
r_xyiv =corr2(xRandiv(:),yRandiv(:));
disp('Correlation coeff Original image vertical direction:')
disp(r_xyiv);
subplot(3,2,3)
scatter(xRandiv(:),yRandiv(:),'.');
title('Scatter plot in vertical direction for original image')
%Correlation coeff encrypted image vert direction
xv = encrypted(1:end-1,1:end-1,1);  
yv = encrypted(2:end,2:end,1); 
randIndex = randperm(numel(xv));                                   
randIndex = randIndex(1:2000);   
xRandv = xv(randIndex);            
yRandv = yv(randIndex); 
% R=corrcoef(xRandv(:),yRandv(:));
% R_sev=R(2)^2;
% disp(R_sev);
r_xyv = corr2(xRandv(:),yRandv(:));
disp('Correlation coeff encrypted image vertical direction:')
disp(r_xyv);
subplot(3,2,4)
scatter(xRandv(:),yRandv(:),'.');
title('Scatter plot in vertical direction for encrypted image')
%Correlation coeff original image diagonal direction
xid = I(2:end,1:end-1,1);  
yid = I(1:end-1,2:end,1);
randIndex = randperm(numel(xid));                                   
randIndex = randIndex(1:2000);   
xRandid = xid(randIndex);            
yRandid = yid(randIndex); 
% R=corrcoef(xRandid(:),yRandid(:));
% R_sod=R(2)^2;
% disp(R_sod);
r_xyid =corr2(xRandid(:),yRandid(:));
disp('Correlation coeff Original image diagonal direction:')
disp(r_xyid);
subplot(3,2,5)
scatter(xRandid(:),yRandid(:),'.');
 title('Scatter plot in diagonal direction for original image')
%Correlation coeff encrypted image diagonal direction
xd = encrypted(2:end,1:end-1,1);  
yd = encrypted(1:end-1,2:end,1); 
randIndex = randperm(numel(xd));                                   
randIndex = randIndex(1:2000);   
xRandd = xd(randIndex);            
yRandd = yd(randIndex); 
%  R=corrcoef(xRandd(:),yRandd(:));
% R_sed=R(2)^2;
% disp(R_sed);
r_xyd = corr2(xRandd(:),yRandd(:));
disp('Correlation coeff encrypted image diagonal direction:')
subplot(3,2,6)
disp(r_xyd);
scatter(xRandd(:),yRandd(:),'.');
title('Scatter plot in diagonal direction for encrypted image')
