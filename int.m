%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               verifiable threshold signcryption                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%G={P1,P2,...,Pn} is set of n users 
%let threshold be t (1<=t<=n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   parameter chosing phase                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc
a=1;
b=0;
q=17;
fprintf('a=%d; b=%d; q=%d;\n',a,b,q)
fprintf('points on elliptic curve\n');
for x = [0:16]
    [x; mod(x^3+x, q)]; 
    c(x+1)=ans(1); 
    d(x+1)=ans(2);
end
for x=[0:16]
    fprintf('(%d %d)\t',c(x+1),d(x+1));
    if x==2||x==5||x==8||x==11||x==14
        fprintf('\n');
    end
end
i=randint(1,1,[1,q-1]);
P=[c(i) d(i)];
d=randint(1,1,[1,q-1]);
dB=randint(1,1,[1,q-1]);
Q=multell(P,d,a,b,q);
QB=multell(P,dB,a,b,q);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               verifiable secret key split phase                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%let f(x)=a(0)+a(1).x+a(2).x^2+...+a(t-1).x^t-1 be secret polynomial
%for (3,4) secret sharing
t=3;
n=4;
a0=d;
a1=6;
a2=9;
d1=mod((a0+a1+a2),q);%f(1)
d2=mod((a0+a1*2+a2*4),q);%f(2)
d3=mod((a0+a1*3+a2*9),q);%f(3)
d4=mod((a0+a1*4+a2*16),q);
% d1
% d2
% d3
% d4
% for i=[1:n-1]
%     f(i)=aa(1)+aa(2)*i+aa(3)*i*i+aa(4)*i*i*i+aa(5)*i*i*i*i;
% end
% f=[d f]
Q1=multell(P,d1,a,b,q);
Q2=multell(P,d2,a,b,q);
Q3=multell(P,d3,a,b,q);
Q4=multell(P,d4,a,b,q);
%for j=[1:t-1]
a1_P=multell(P,a1,a,b,q);
a2_P=multell(P,a2,a,b,q);
%a3_P=multell(P,aa(3),a,b,q);
%end
d1_P=(a1_P)+(a2_P);
d2_P=2.*(a1_P)+4.*(a2_P);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Threshold signcryption phase                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Img,map] = imread('srs2.bmp');%mm=imread('TEST.bmp');
m=im2bw(Img, map,0.4);%m=im2bw(mm);
figure(1)
imshow(m,2);
k1=randint(1,1,[1,q-1]);
k2=randint(1,1,[1,q-1]);
k3=randint(1,1,[1,q-1]);
k4=randint(1,1,[1,q-1]);
Y1=multell(P,k1,a,b,q);
Y2=multell(P,k2,a,b,q);
Y3=multell(P,k3,a,b,q);
Y4=multell(P,k4,a,b,q);
Z1=multell(QB,k1,a,b,q);
Z2=multell(QB,k2,a,b,q);
Z3=multell(QB,k3,a,b,q);
ZZ=addell(Z1,Z2,a,b,q);
Z=addell(ZZ,Z3,a,b,q);
r=mod(m.*Z(1),q);
figure(2)
imshow(r,2);
x=[1 1 1 1];
for i=1:n
    for j=1:t
        if j~=i
            x(i)=x(i)*(-j./(i-j));
        else
            continue;
        end
    end
end
for i=1:t
    x(i)=mod(x(i),q);
end
e1=mod(d1.*x(1),q);
e2=mod(d2.*x(2),q);
e3=mod(d3.*x(3),q);
e4=mod(d4.*x(4),q);
%partial signcryptions si
s1=mod(k1-e1.*r,q);
figure(3);
imshow(s1,2);
s2=mod(k2-e2.*r,q);
figure(4);
imshow(s2,2);
s3=mod(k3-e3.*r,q);
figure(5);
imshow(s3,2);
s4=mod(k4-e4.*r,q);
figure(6);
imshow(s4,2);
Y11=addell(multell(Q1,r*x(1),a,b,q),multell(P,s1,a,b,q),a,b,q);
Y22=addell(multell(Q2,r*x(2),a,b,q),multell(P,s2,a,b,q),a,b,q);
Y33=addell(multell(Q3,r*x(3),a,b,q),multell(P,s3,a,b,q),a,b,q);
Y44=addell(multell(Q4,r*x(4),a,b,q),multell(P,s4,a,b,q),a,b,q);
s=mod(s1+s2+s3+s4,q);
figure(7);
imshow(s,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             verification and message recovery phase              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b1=addell(Y1,Y2,a,b,q);
b2=addell(Y3,b1,a,b,q);
Y=addell(Y4,b2,a,b,q);
Y_1=addell(multell(Q,r,a,b,q),multell(P,s,a,b,q),a,b,q);
Z_1=multell(Y_1,dB,a,b,q);
m_1=mod(r./Z_1(1),q);
figure(10);
imshow(m_1,2);