function res = getU( X,Xr,model )
%get 2X1 vector input U based on 
%   Detailed explanation goes here
x=X(1);
y=X(2);
xd=X(3);
yd=X(4);
xr=Xr(1);
yr=Xr(2);
xrd=Xr(3);
yrd=Xr(4);
xrdd=Xr(5);
yrdd=Xr(6);

dx=0;
dy=0;

xc=model.spPos(1);
yc=model.spPos(2);
r0=3.5/100;

theta=atan2(-model.spPos(2)+y,-model.spPos(1)+x);


epsilonn =  dot(-[xc+r0*cos(theta);yc+r0*sin(theta)]+[x;y],[-cos(theta); -sin(theta)])+dot(-[xr;yr]+[x;y],[-cos(theta); -sin(theta)]);%+...
%             dot([xc+r0*cos(theta);yc+r0*sin(theta)]-[x;y],[-cos(theta); -sin(theta)]);
epsilont =  dot(-[xr;yr]+[x;y],[cos(theta+pi/2);sin(theta+pi/2)]);

epsilond=[((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-3/2).*(xc.^2.*(xd.*y+(-1).*xrd.*y+ ...
  (-1).*xd.*yc+xrd.*yc+(-1).*xr.*yd)+(-1).*(y+(-1).*yc).^2.*(xrd.*y+xd.* ...
  yc+(-1).*xrd.*yc+(-1).*xd.*yr)+xc.^3.*(yd+(-1).*yrd)+x.^3.*yrd+x.^2.*( ...
  xrd.*((-1).*y+yc)+xc.*yd+(-1).*xr.*yd+(-3).*xc.*yrd)+(-1).*xc.*(y+(-1).* ...
  yc).*(xd.*xr+yc.*yd+(-1).*yd.*yr+y.*yrd+(-1).*yc.*yrd)+x.*(xc.*((-1).* ...
  xd.*y+2.*xrd.*y+xd.*yc+(-2).*xrd.*yc+2.*xr.*yd)+xc.^2.*((-2).*yd+3.*yrd) ...
  +(y+(-1).*yc).*(xd.*xr+yc.*yd+(-1).*yd.*yr+y.*yrd+(-1).*yc.*yrd))),((x+( ...
  -1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(x.*xd+(-1).*xc.*xd+(y+(-1).*yc).* ...
  yd)].';

% [xr;yr]
% [x;y]
T=[-sin(theta) -cos(theta); cos(theta) -sin(theta)];
kt=1000;
kn=80;
kdt=5;
kdn=5;

cx=model.cx;
cy=model.cy;
mx=model.mx;
my=model.my;

Kpxx=-1; Kpxy=0; Kpyx=0; Kpyy=-1;
Kdxx=-1; Kdxy=0; Kdyx=0; Kdyy=-1;
Ksxx=1; Ksxy=0; Ksyx=0; Ksyy=1;

% 
% %% Using tangential and nomral force transformation
res=T*([-kt 0; 0 -kn]*[epsilont;epsilonn]+[kdt 0; 0 kdn]*epsilond);

% 
% %% Decomposed
% B=[imag(yc)/(mx*abs(xc - xr + yc*1i - yr*1i)) - imag(yr)/(mx*abs(xc - xr + yc*1i - yr*1i)) - real(xc)/(mx*abs(xc - xr + yc*1i - yr*1i)) + real(xr)/(mx*abs(xc - xr + yc*1i - yr*1i)), - imag(xc)/(my*abs(xc - xr + yc*1i - yr*1i)) + imag(xr)/(my*abs(xc - xr + yc*1i - yr*1i)) - real(yc)/(my*abs(xc - xr + yc*1i - yr*1i)) + real(yr)/(my*abs(xc - xr + yc*1i - yr*1i)); ...
%     - imag(xc)/(mx*abs(xc - xr + yc*1i - yr*1i)) + imag(xr)/(mx*abs(xc - xr + yc*1i - yr*1i)) - real(yc)/(mx*abs(xc - xr + yc*1i - yr*1i)) + real(yr)/(mx*abs(xc - xr + yc*1i - yr*1i)), - imag(yc)/(my*abs(xc - xr + yc*1i - yr*1i)) + imag(yr)/(my*abs(xc - xr + yc*1i - yr*1i)) + real(xc)/(my*abs(xc - xr + yc*1i - yr*1i)) - real(xr)/(my*abs(xc - xr + yc*1i - yr*1i))];
% 
% Kp=[Kpxx Kpxy; Kpyx Kpyy];
% Kd=[Kdxx Kdxy; Kdyx Kdyy];
% Ks=[Ksxx Ksxy; Ksyx Ksyy];
% M=[mx 0; 0 my];
% epsilon=[((x - xr)*(imag(yc) - imag(yr) - real(xc) + real(xr)))/abs(xc - xr + yc*1i - yr*1i) - ((y - yr)*(imag(xc) - imag(xr) + real(yc) - real(yr)))/abs(xc - xr + yc*1i - yr*1i); ...
%  - ((x - xr)*(imag(xc) - imag(xr) + real(yc) - real(yr)))/abs(xc - xr + yc*1i - yr*1i) - ((y - yr)*(imag(yc) - imag(yr) - real(xc) + real(xr)))/abs(xc - xr + yc*1i - yr*1i)];
% epsilond=[xrd*((x - xr)/abs(xc - xr + yc*1i - yr*1i) - (imag(yc) - imag(yr) - real(xc) + real(xr))/abs(xc - xr + yc*1i - yr*1i) + (sign(xc - xr + yc*1i - yr*1i)*(x - xr)*(imag(yc) - imag(yr) - real(xc) + real(xr)))/abs(xc - xr + yc*1i - yr*1i)^2 - (sign(xc - xr + yc*1i - yr*1i)*(y - yr)*(imag(xc) - imag(xr) + real(yc) - real(yr)))/abs(xc - xr + yc*1i - yr*1i)^2) + yrd*((y - yr)/abs(xc - xr + yc*1i - yr*1i) + (imag(xc) - imag(xr) + real(yc) - real(yr))/abs(xc - xr + yc*1i - yr*1i) + (sign(xc - xr + yc*1i - yr*1i)*(x - xr)*(imag(yc) - imag(yr) - real(xc) + real(xr))*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (sign(xc - xr + yc*1i - yr*1i)*(y - yr)*(imag(xc) - imag(xr) + real(yc) - real(yr))*1i)/abs(xc - xr + yc*1i - yr*1i)^2) + (xd*(imag(yc) - imag(yr) - real(xc) + real(xr)))/abs(xc - xr + yc*1i - yr*1i) - (yd*(imag(xc) - imag(xr) + real(yc) - real(yr)))/abs(xc - xr + yc*1i - yr*1i); ...
%  yrd*((x - xr)/abs(xc - xr + yc*1i - yr*1i) + (imag(yc) - imag(yr) - real(xc) + real(xr))/abs(xc - xr + yc*1i - yr*1i) - (sign(xc - xr + yc*1i - yr*1i)*(x - xr)*(imag(xc) - imag(xr) + real(yc) - real(yr))*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (sign(xc - xr + yc*1i - yr*1i)*(y - yr)*(imag(yc) - imag(yr) - real(xc) + real(xr))*1i)/abs(xc - xr + yc*1i - yr*1i)^2) - xrd*((y - yr)/abs(xc - xr + yc*1i - yr*1i) - (imag(xc) - imag(xr) + real(yc) - real(yr))/abs(xc - xr + yc*1i - yr*1i) + (sign(xc - xr + yc*1i - yr*1i)*(x - xr)*(imag(xc) - imag(xr) + real(yc) - real(yr)))/abs(xc - xr + yc*1i - yr*1i)^2 + (sign(xc - xr + yc*1i - yr*1i)*(y - yr)*(imag(yc) - imag(yr) - real(xc) + real(xr)))/abs(xc - xr + yc*1i - yr*1i)^2) - (xd*(imag(xc) - imag(xr) + real(yc) - real(yr)))/abs(xc - xr + yc*1i - yr*1i) - (yd*(imag(yc) - imag(yr) - real(xc) + real(xr)))/abs(xc - xr + yc*1i - yr*1i)];
%  
% subtr(1,1)=(x*xrdd)/abs(xc - xr + yc*1i - yr*1i) - (2*yrd^2)/abs(xc - xr + yc*1i - yr*1i) - (2*xrd^2)/abs(xc - xr + yc*1i - yr*1i) + (2*xd*xrd)/abs(xc - xr + yc*1i - yr*1i) - (xr*xrdd)/abs(xc - xr + yc*1i - yr*1i) + (y*yrdd)/abs(xc - xr + yc*1i - yr*1i) + (2*yd*yrd)/abs(xc - xr + yc*1i - yr*1i) - (yr*yrdd)/abs(xc - xr + yc*1i - yr*1i) - (xrdd*imag(yc))/abs(xc - xr + yc*1i - yr*1i) + (yrdd*imag(xc))/abs(xc - xr + yc*1i - yr*1i) + (xrdd*imag(yr))/abs(xc - xr + yc*1i - yr*1i) - (yrdd*imag(xr))/abs(xc - xr + yc*1i - yr*1i) + (xrdd*real(xc))/abs(xc - xr + yc*1i - yr*1i) - (xrdd*real(xr))/abs(xc - xr + yc*1i - yr*1i) + (yrdd*real(yc))/abs(xc - xr + yc*1i - yr*1i) - (yrdd*real(yr))/abs(xc - xr + yc*1i - yr*1i) + (2*x*xrd^2*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*xrd^2*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (y*yrd^2*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yr*yrd^2*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (yrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (yrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (yrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrdd*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*y*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrdd*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*y*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xd*xrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yd*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrdd*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*yr*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xd*xrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yd*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrdd*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*yr*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (x*yrdd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (y*yrdd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*yrdd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (y*yrdd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xd*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yd*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*yrdd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yr*yrdd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xd*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yd*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*yrdd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yr*yrdd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrdd*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrdd*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xd*xrd*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrdd*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xd*xrd*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrdd*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (x*yrdd*real(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*yrdd*real(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xd*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*yrdd*real(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xd*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*yrdd*real(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*y*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*y*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yd*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*yr*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yd*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*yr*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (y*yrdd*real(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (y*yrdd*real(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yd*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yr*yrdd*real(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yd*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yr*yrdd*real(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*xrd^2*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*y*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*xrd^2*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*y*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*xrd^2*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*yr*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*xrd^2*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*yr*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*yrd^2*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*y*yrd^2*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*yrd^2*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*y*yrd^2*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*yrd^2*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*yr*yrd^2*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*yrd^2*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*yr*yrd^2*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*y*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*y*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*yr*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*yr*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*y*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*y*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*yr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*yr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrd*yrd*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrd*yrd*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*y*yrd*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yr*yrd*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*xrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*y*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*x*xrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*y*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*xrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*yr*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*xrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*yr*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*x*yrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*y*yrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*x*yrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*y*yrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*yrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*yr*yrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*yrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*yr*yrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*x*xrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*x*xrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*xrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*xrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*x*yrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*x*yrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*yrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*yrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*y*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*y*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*yr*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*yr*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*y*yrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*y*yrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*yr*yrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*yr*yrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (cx*xd*imag(yc))/(mx*abs(xc - xr + yc*1i - yr*1i)) + (cy*yd*imag(xc))/(my*abs(xc - xr + yc*1i - yr*1i)) + (cx*xd*imag(yr))/(mx*abs(xc - xr + yc*1i - yr*1i)) - (cy*yd*imag(xr))/(my*abs(xc - xr + yc*1i - yr*1i)) + (cx*xd*real(xc))/(mx*abs(xc - xr + yc*1i - yr*1i)) - (cx*xd*real(xr))/(mx*abs(xc - xr + yc*1i - yr*1i)) + (cy*yd*real(yc))/(my*abs(xc - xr + yc*1i - yr*1i)) - (cy*yd*real(yr))/(my*abs(xc - xr + yc*1i - yr*1i)) - (x*xrd*yrd*imag(yc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*y*yrd*imag(xc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrd*yrd*imag(yr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*y*yrd*imag(xr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrd*yrd*imag(yc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yr*yrd*imag(xc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrd*yrd*imag(yr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yr*yrd*imag(xr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*y*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*y*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yr*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yr*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrd*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*y*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (x*xrd*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*y*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xr*xrd*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*yr*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xr*xrd*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*yr*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (x*xrd*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (x*xrd*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xr*xrd*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xr*xrd*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*y*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*y*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*yr*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*yr*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3;
% subtr(2,1)=(x*yrdd)/abs(xc - xr + yc*1i - yr*1i) - (xrdd*y)/abs(xc - xr + yc*1i - yr*1i) + (2*xd*yrd)/abs(xc - xr + yc*1i - yr*1i) - (2*xrd*yd)/abs(xc - xr + yc*1i - yr*1i) - (xr*yrdd)/abs(xc - xr + yc*1i - yr*1i) + (xrdd*yr)/abs(xc - xr + yc*1i - yr*1i) + (xrdd*imag(xc))/abs(xc - xr + yc*1i - yr*1i) - (xrdd*imag(xr))/abs(xc - xr + yc*1i - yr*1i) + (yrdd*imag(yc))/abs(xc - xr + yc*1i - yr*1i) - (yrdd*imag(yr))/abs(xc - xr + yc*1i - yr*1i) + (xrdd*real(yc))/abs(xc - xr + yc*1i - yr*1i) - (yrdd*real(xc))/abs(xc - xr + yc*1i - yr*1i) - (xrdd*real(yr))/abs(xc - xr + yc*1i - yr*1i) + (yrdd*real(xr))/abs(xc - xr + yc*1i - yr*1i) + (x*yrd^2*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*y*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*yrd^2*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*yr*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (yrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (yrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (yrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrdd*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrdd*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xd*xrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrdd*imag(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xd*xrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrdd*imag(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (x*yrdd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*yrdd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xd*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*yrdd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xd*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*yrdd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*y*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*y*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yd*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*yr*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yd*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*yr*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (y*yrdd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (y*yrdd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yd*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yr*yrdd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yd*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yr*yrdd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrdd*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*y*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrdd*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*y*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xd*xrd*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yd*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrdd*real(yc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xrdd*yr*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xd*xrd*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd*yd*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrdd*real(yr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (xrdd*yr*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (x*yrdd*real(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (y*yrdd*real(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*yrdd*real(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (y*yrdd*real(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xd*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yd*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*yrdd*real(yc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yr*yrdd*real(xc)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xd*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (yd*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*yrdd*real(yr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 + (yr*yrdd*real(xr)*sign(xc - xr + yc*1i - yr*1i)*1i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*xrd^2*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*xrd^2*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*xrd^2*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*xrd^2*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*yrd^2*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*yrd^2*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*yrd^2*imag(xc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*yrd^2*imag(xr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*y*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*y*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*yr*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*yr*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*y*yrd^2*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*y*yrd^2*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*yr*yrd^2*imag(yc)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*yr*yrd^2*imag(yr)*dirac(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*y*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*y*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xrd^2*yr*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*xrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xrd^2*yr*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*y*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*y*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*xr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*yr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xc))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(yr))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*yr*yrd^2*dirac(xc - xr + yc*1i - yr*1i)*real(xr))/abs(xc - xr + yc*1i - yr*1i)^2 + (2*x*xrd*yrd*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (2*xr*xrd*yrd*sign(xc - xr + yc*1i - yr*1i))/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*y*yrd*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yr*yrd*sign(xc - xr + yc*1i - yr*1i)*2i)/abs(xc - xr + yc*1i - yr*1i)^2 - (2*x*xrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*x*xrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*xrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*xrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*x*yrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*x*yrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*yrd^2*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*yrd^2*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*y*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*y*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*yr*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*yr*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*y*yrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*y*yrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*yr*yrd^2*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*yr*yrd^2*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*x*xrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*y*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*x*xrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*y*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*xrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xrd^2*yr*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*xrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xrd^2*yr*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*x*yrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*y*yrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*x*yrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*y*yrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*xr*yrd^2*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*yr*yrd^2*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (2*xr*yrd^2*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 - (2*yr*yrd^2*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2)/abs(xc - xr + yc*1i - yr*1i)^3 + (cx*xd*imag(xc))/(mx*abs(xc - xr + yc*1i - yr*1i)) - (cx*xd*imag(xr))/(mx*abs(xc - xr + yc*1i - yr*1i)) + (cy*yd*imag(yc))/(my*abs(xc - xr + yc*1i - yr*1i)) - (cy*yd*imag(yr))/(my*abs(xc - xr + yc*1i - yr*1i)) + (cx*xd*real(yc))/(mx*abs(xc - xr + yc*1i - yr*1i)) - (cy*yd*real(xc))/(my*abs(xc - xr + yc*1i - yr*1i)) - (cx*xd*real(yr))/(mx*abs(xc - xr + yc*1i - yr*1i)) + (cy*yd*real(xr))/(my*abs(xc - xr + yc*1i - yr*1i)) + (x*xrd*yrd*imag(xc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrd*yrd*imag(xr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrd*yrd*imag(xc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrd*yrd*imag(xr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*y*yrd*imag(yc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*y*yrd*imag(yr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yr*yrd*imag(yc)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yr*yrd*imag(yr)*dirac(xc - xr + yc*1i - yr*1i)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (x*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*y*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*y*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xr*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xrd*yr*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xc)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 + (xr*xrd*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(yr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (xrd*yr*yrd*dirac(xc - xr + yc*1i - yr*1i)*real(xr)*4i)/abs(xc - xr + yc*1i - yr*1i)^2 - (x*xrd*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (x*xrd*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xr*xrd*yrd*imag(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xr*xrd*yrd*imag(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*y*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*y*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*yr*yrd*imag(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*yr*yrd*imag(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (x*xrd*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*y*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (x*xrd*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*y*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xr*xrd*yrd*real(yc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xrd*yr*yrd*real(xc)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 - (xr*xrd*yrd*real(yr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3 + (xrd*yr*yrd*real(xr)*sign(xc - xr + yc*1i - yr*1i)^2*4i)/abs(xc - xr + yc*1i - yr*1i)^3;
% 
% res=inv(B)*(inv(Kd)*(-inv(M)*Ks*(Kp*epsilon+Kd*epsilond)-Kp*epsilond)-subtr);
%  

 
