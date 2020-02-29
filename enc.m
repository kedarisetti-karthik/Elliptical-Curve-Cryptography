%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                initialization                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all;
clc
a=1;
b=3;
n=31;
q=2^n-1;
% fprintf('a=%d; b=%d; n=%d;\n',a,b,n)
% fprintf('points on elliptic curve\n');
%for x = [0:q-1]
 %   [x; mod(x^2+x+3,n)]; 
  %  c(x+1)=ans(1);
   % d(x+1)=ans(2);
%end
dA=randint(1,1,[1,q-1]);
dB=randint(1,1,[1,q-1]);
i=randint(1,1,[1,q-1]);
P=[c(i) d(i)];
P
QA=multell(P,dA,a,b,n);
QB=multell(P,dB,a,b,n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                signcryption                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Img,map] = imread('lena.jpg');
m=im2bw(Img, map,0.3);% which is signcrypted by A -> sent to B
figure(1);
imshow(m,2);
title('ACTUAL MESSAGE');
k=randint(1,1,[1,q-1]);
Y1=multell(P,k,a,b,n);
Y1
Y2=multell(QB,k,a,b,n);
Y2
% if (Y1(1)==Inf || Y1(2)==Inf || Y2(1)==Inf || Y2(2)==Inf)
% clear all;
% clc
% a=1;
% b=0;
% n=17;
% q=n;
% % a=2;b=3;n=5;q=n;c=[1 1 2 3 3 4];
% % d=[1 4 0 1 4 0];
% disp('shankar');
% fprintf('a=%d; b=%d; n=%d;\n',a,b,n)
% fprintf('points on elliptic curve\n');
% for x = [0:16]
%     [x; mod(x^3+x, n)]; 
%     c(x+1)=ans(1);
%     d(x+1)=ans(2);
% end
% for x=[0:16]
%     fprintf('(%d %d)\t',c(x+1),d(x+1));
%     if x==2||x==5||x==8||x==11||x==14
%         fprintf('\n');
%     end
% end
% dA=randint(1,1,[1,q-1]);
% dB=randint(1,1,[1,q-1]);
% i=randint(1,1,[1,q-1]);
% P=[c(i) d(i)];
% P
% QA=multell(P,dA,a,b,n);
% QB=multell(P,dB,a,b,n);
% [Img,map] = imread('srs2.bmp');
% m=im2bw(Img, map,0.3);% which is signcrypted by A -> sent to B
% figure(1);
% %image(m);
% imshow(m,2);
% title('ACTUAL MESSAGE');
% k=randint(1,1,[1,q-1]);
% Y1=multell(P,k,a,b,n);
% Y1
% Y2=multell(QB,k,a,b,n);
% Y2
% end
x=m.*Y2(1);
r=mod(x,n);
figure(2);
imshow(r,2);
title('SIGNCRYPTED MESSAGE r')
s=mod(k-dA.*r, n);
figure(3);
imshow(s,2);
title('SIGNCRYPTED MESSAGE s');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         verification n message recovery           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a1=multell(QA,r,a,b,n);
a1
a2=multell(P,s,a,b,n);
a2
Y11=addell(a1,a2,a,b,n);
Y11
Y22=multell(Y11,dB,a,b,n);
Y22
mm1=mod((r./Y22(1)),n);
m1=im2bw(mm1);
figure(4);
imshow(m1,2);
title('RECOVERED MESSAGE');