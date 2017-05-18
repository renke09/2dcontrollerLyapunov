% function globalStabilitySlidingControllerTemp

% Use SOS to find a Lyapunov function to certify the global stability of
% the damped pendulum.  Uses trig to poly substitution to perform exact
% analysis.  Recovers a Lyapunov function that looks a lot like the energy,
% but is better!  (doesn't require LaSalle's theorem)

checkDependency('spotless');
% checkDependency('mosek');

% set up state variables
% syms x y xd yd c s theta r;
x=msspoly('x',1);
y=msspoly('y',1);
xd=msspoly('xd',1);
yd=msspoly('yd',1);
s = msspoly('s',1);
c = msspoly('c',1);
theta=msspoly('th',1);
r=msspoly('r',1);
xc=msspoly('xc',1);
yc=msspoly('yc',1);
de=msspoly('de',1);
q=msspoly('q',1);
vars = [x; y; xd; yd; c; s; theta; r; xc; yc; de];

% polynomial dynamics (using parameters from the plant class) in terms of
% s,c, and thetadot
xr=0;yr=0; xrd=0; yrd=0; xrdd=0; yrdd=0;
M=[1,0;0,0.3];
C=[1 0; 0 1];
K=[100, 0; 0 ,1];

mx=M(1,1);
my=M(2,2);
cx=C(1,1); cy=C(2,2);
Kp=[5 0; 0 5];
Kd=[0.5 0; 0 0.5];
Ks=[10 0;0 2];

% Constructing the vector field dx/dt = f
epsilont=dot([xr - x; yr - y], [-s; c]);
epsilonn=dot([xr-x; yr-y],[-c;-s]);

epsilon=[epsilont;epsilonn];
epsilond=[(x.*xd+(-1).*xc.*xd+(y+(-1).*yc).*yd).*(xr.*(y+(-1).*yc)+x.*(yc+(-1).* ...
  yr)+xc.*((-1).*y+yr))+((x+(-1).*xc).^2+(y+(-1).*yc).^2).*(xrd.*((-1).*y+ ...
  yc)+xc.*yd+(-1).*xr.*yd+xd.*((-1).*yc+yr)+x.*yrd+(-1).*xc.*yrd),(1/2).*( ...
  (-2).*(x.*xd+(-1).*xc.*xd+(y+(-1).*yc).*yd).*(x.^2+xc.*xr+(-1).*x.*(xc+ ...
  xr)+(y+(-1).*yc).*(y+(-1).*yr))+2.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).*( ...
  2.*x.*xd+(-1).*xd.*(xc+xr)+(-1).*x.*xrd+xc.*xrd+yd.*(y+(-1).*yr)+(y+(-1) ...
  .*yc).*(yd+(-1).*yrd)))].';
epsilond(1)=epsilond(1)*r^3;
epsilond(2)=epsilond(2)*r^3;

remNum=[mx.^(-1).*my.^(-1).*(cx.*my.*xd.*(x.^2+(-2).*x.*xc+xc.^2+(y+(-1).*yc) ...
  .^2).*(y+(-1).*yc).*((-1).*xc.^2+x.*(xc+(-1).*xr)+xc.*xr+(y+(-1).*yc).*( ...
  yc+(-1).*yr))+mx.*((-1).*cy.*(x+(-1).*xc).*(x.^2+(-2).*x.*xc+xc.^2+(y+( ...
  -1).*yc).^2).*yd.*((-1).*xc.^2+x.*(xc+(-1).*xr)+xc.*xr+(y+(-1).*yc).*( ...
  yc+(-1).*yr))+my.*(xc.^4.*(xrdd.*((-1).*y+yc)+2.*(xd+(-1).*xrd).*yd)+(y+ ...
  (-1).*yc).^3.*(xd.^2.*xr+(-1).*xrdd.*(y+(-1).*yc).^2+2.*xd.*((-1).*yd.* ...
  yr+yc.*(yd+(-1).*yrd)+y.*yrd))+(-1).*xc.^2.*(y+(-1).*yc).*(2.*xd.^2.*xr+ ...
  2.*xrdd.*(y+(-1).*yc).^2+yd.*(2.*xrd.*y+(-2).*xrd.*yc+(-3).*xr.*yd)+2.* ...
  xd.*(2.*y.*yd+(-2).*yd.*yr+(-1).*y.*yrd+yc.*yrd))+x.^5.*yrdd+(-1).* ...
  xc.^5.*yrdd+(-1).*x.^4.*(xrdd.*(y+(-1).*yc)+2.*xrd.*yd+5.*xc.*yrdd)+ ...
  x.^3.*(yc.*yd.^2+2.*xd.*(xrd.*(y+(-1).*yc)+((-1).*xc+xr).*yd)+4.*xc.*( ...
  xrdd.*y+(-1).*xrdd.*yc+2.*xrd.*yd)+(-1).*yd.^2.*yr+(-2).*y.*yd.*yrd+2.* ...
  yc.*yd.*yrd+10.*xc.^2.*yrdd+2.*y.^2.*yrdd+(-4).*y.*yc.*yrdd+2.*yc.^2.* ...
  yrdd)+(-1).*xc.*(y+(-1).*yc).^2.*(2.*xd.*xrd.*(y+(-1).*yc)+(-4).*xd.* ...
  xr.*yd+xd.^2.*(y+2.*yc+(-3).*yr)+2.*yd.^2.*yr+(-2).*y.*yd.*yrd+y.^2.* ...
  yrdd+yc.^2.*yrdd+(-2).*yc.*(yd.^2+(-1).*yd.*yrd+y.*yrdd))+xc.^3.*(2.* ...
  xd.^2.*(y+(-1).*yc)+2.*yc.*yd.^2+(-2).*xd.*(xrd.*(y+(-1).*yc)+xr.*yd)+ ...
  yd.^2.*yr+(-2).*yc.*yd.*yrd+(-2).*y.^2.*yrdd+(-2).*yc.^2.*yrdd+y.*((-3) ...
  .*yd.^2+2.*yd.*yrd+4.*yc.*yrdd))+(-1).*x.^2.*(6.*xc.^2.*(xrdd.*y+(-1).* ...
  xrdd.*yc+(-1).*xd.*yd+2.*xrd.*yd)+(y+(-1).*yc).*(2.*xd.^2.*xr+2.*xrdd.*( ...
  y+(-1).*yc).^2+yd.*(2.*xrd.*y+(-2).*xrd.*yc+(-3).*xr.*yd)+2.*xd.*((-2).* ...
  yd.*yr+(-1).*y.*yrd+yc.*(2.*yd+yrd)))+10.*xc.^3.*yrdd+xc.*((-2).*xd.^2.* ...
  (y+(-1).*yc)+6.*xd.*(xrd.*(y+(-1).*yc)+xr.*yd)+(-3).*yd.^2.*yr+6.*yc.* ...
  yd.*yrd+6.*y.^2.*yrdd+6.*yc.^2.*yrdd+3.*y.*(yd.^2+(-2).*yd.*yrd+(-4).* ...
  yc.*yrdd)))+x.*(xc.^3.*(4.*xrdd.*(y+(-1).*yc)+(-6).*xd.*yd+8.*xrd.*yd)+ ...
  2.*xc.*(y+(-1).*yc).*(2.*xd.^2.*xr+2.*xrdd.*(y+(-1).*yc).^2+yd.*(2.* ...
  xrd.*(y+(-1).*yc)+(-3).*xr.*yd)+2.*xd.*((-2).*yd.*yr+y.*(yd+(-1).*yrd)+ ...
  yc.*(yd+yrd)))+5.*xc.^4.*yrdd+(y+(-1).*yc).^2.*(2.*xd.*xrd.*(y+(-1).*yc) ...
  +(-4).*xd.*xr.*yd+3.*xd.^2.*(yc+(-1).*yr)+2.*yd.^2.*yr+(-2).*y.*yd.*yrd+ ...
  y.^2.*yrdd+yc.^2.*yrdd+(-2).*yc.*(yd.^2+(-1).*yd.*yrd+y.*yrdd))+xc.^2.*( ...
  (-4).*xd.^2.*(y+(-1).*yc)+(-3).*yc.*yd.^2+6.*xd.*(xrd.*(y+(-1).*yc)+xr.* ...
  yd)+(-3).*yd.^2.*yr+6.*yc.*yd.*yrd+6.*y.^2.*yrdd+6.*yc.^2.*yrdd+6.*y.*( ...
  yd.^2+(-1).*yd.*yrd+(-2).*yc.*yrdd)))))),mx.^(-1).*my.^(-1).*((-1).*cx.* ...
  my.*xd.*(x.^2+(-2).*x.*xc+xc.^2+(y+(-1).*yc).^2).*(x.^3+(-3).*x.^2.*xc+ ...
  3.*x.*xc.^2+(-1).*xc.^3+(-1).*xr.*(y+(-1).*yc).^2+xc.*(y+(-1).*yc).*(yc+ ...
  (-1).*yr)+x.*(y+(-1).*yc).*(y+(-2).*yc+yr))+mx.*((-1).*cy.*(x.^2+(-2).* ...
  x.*xc+xc.^2+(y+(-1).*yc).^2).*yd.*(x.*xr.*(y+(-1).*yc)+(y+(-1).*yc).^3+ ...
  xc.*xr.*((-1).*y+yc)+x.^2.*(y+(-1).*yr)+xc.^2.*(2.*y+(-1).*yc+(-1).*yr)+ ...
  x.*xc.*((-3).*y+yc+2.*yr))+(-1).*my.*(x.^5.*xrdd+(-1).*xc.^5.*xrdd+ ...
  xc.^3.*((-2).*xrdd.*(y+(-1).*yc).^2+yd.*(2.*xrd.*y+(-2).*xrd.*yc+xr.*yd) ...
  +xd.*((-6).*y.*yd+4.*yc.*yd+2.*yd.*yr+2.*y.*yrd+(-2).*yc.*yrd))+(-1).* ...
  xc.*(y+(-1).*yc).^2.*((-3).*xd.^2.*xr+xrdd.*(y+(-1).*yc).^2+2.*yd.*((-1) ...
  .*xrd.*y+xrd.*yc+xr.*yd)+xd.*((-4).*yc.*yd+4.*yd.*yr+(-2).*y.*yrd+2.* ...
  yc.*yrd))+xc.^4.*((-2).*yd.^2+2.*yd.*yrd+(y+(-1).*yc).*yrdd)+(y+(-1).* ...
  yc).^3.*(2.*xd.*xrd.*(y+(-1).*yc)+(-2).*xd.*xr.*yd+(-1).*xd.^2.*(y+(-2) ...
  .*yc+yr)+(y+(-1).*yc).^2.*yrdd)+(-1).*x.^4.*(5.*xc.*xrdd+yd.^2+(-2).* ...
  yd.*yrd+((-1).*y+yc).*yrdd)+xc.^2.*(y+(-1).*yc).*(2.*xd.*xrd.*(y+(-1).* ...
  yc)+4.*xd.*xr.*yd+2.*yc.*yd.^2+(-3).*yd.^2.*yr+2.*xd.^2.*((-2).*y+yc+yr) ...
  +(-2).*yc.*yd.*yrd+2.*y.^2.*yrdd+2.*yc.^2.*yrdd+y.*(yd.^2+2.*yd.*yrd+( ...
  -4).*yc.*yrdd))+x.^3.*(10.*xc.^2.*xrdd+2.*xrdd.*(y+(-1).*yc).^2+2.*xd.* ...
  y.*yd+(-2).*xrd.*y.*yd+2.*xrd.*yc.*yd+(-1).*xr.*yd.^2+(-2).*xd.*yd.*yr+( ...
  -2).*xd.*y.*yrd+2.*xd.*yc.*yrd+xc.*(5.*yd.^2+(-8).*yd.*yrd+4.*((-1).*y+ ...
  yc).*yrdd))+x.*(5.*xc.^4.*xrdd+(y+(-1).*yc).^2.*((-3).*xd.^2.*xr+xrdd.*( ...
  y+(-1).*yc).^2+2.*yd.*((-1).*xrd.*y+xrd.*yc+xr.*yd)+2.*xd.*((-3).*yc.* ...
  yd+2.*yd.*yr+y.*(yd+(-1).*yrd)+yc.*yrd))+xc.^2.*(6.*xrdd.*(y+(-1).*yc) ...
  .^2+(-3).*yd.*(2.*xrd.*y+(-2).*xrd.*yc+xr.*yd)+2.*xd.*(7.*y.*yd+(-4).* ...
  yc.*yd+(-3).*yd.*yr+(-3).*y.*yrd+3.*yc.*yrd))+xc.^3.*(7.*yd.^2+(-8).* ...
  yd.*yrd+4.*((-1).*y+yc).*yrdd)+(-1).*xc.*(y+(-1).*yc).*(4.*xd.*xrd.*(y+( ...
  -1).*yc)+8.*xd.*xr.*yd+(-6).*yd.^2.*yr+xd.^2.*((-5).*y+yc+4.*yr)+4.*y.* ...
  yd.*yrd+4.*y.^2.*yrdd+4.*yc.^2.*yrdd+yc.*(6.*yd.^2+(-4).*yd.*yrd+(-8).* ...
  y.*yrdd)))+x.^2.*((-10).*xc.^3.*xrdd+xc.*((-6).*xrdd.*(y+(-1).*yc).^2+ ...
  3.*yd.*(2.*xrd.*y+(-2).*xrd.*yc+xr.*yd)+xd.*((-10).*y.*yd+4.*yc.*yd+6.* ...
  yd.*yr+6.*y.*yrd+(-6).*yc.*yrd))+xc.^2.*((-9).*yd.^2+12.*yd.*yrd+6.*(y+( ...
  -1).*yc).*yrdd)+(-1).*(y+(-1).*yc).*((-4).*yc.*yd.^2+(-2).*xd.*(xrd.*(y+ ...
  (-1).*yc)+2.*xr.*yd)+xd.^2.*(y+yc+(-2).*yr)+3.*yd.^2.*yr+2.*yc.*yd.*yrd+ ...
  (-2).*y.^2.*yrdd+(-2).*yc.^2.*yrdd+y.*(yd.^2+(-2).*yd.*yrd+4.*yc.*yrdd)) ...
  ))))].';
remNum(1)=remNum(1)*r.^5;
remNum(2)=remNum(2)*r.^5;


coeffMatInv=[(-yc+yr), (-xc+xr); (xc-xr), (-yc+yr)]*r;
coeffMatInv(1,1)=-((mx *(x* xr* (y - yc) + (y - yc)^3 + xc *xr* (-y + yc) + x^2* (y - yr) + ...
    xc^2 *(2* y - yc - yr) + x* xc* (-3* y + yc + 2* yr)))*r);
coeffMatInv(1,1)=coeffMatInv(1,1)*de;
% 
% coeffMat(1,1)=(y - yc)* (-xc^2 + x* (xc - xr) + xc* xr + (y - yc)* (yc - yr))/mx*r.^3;
% coeffMat(1,2)=(x - xc) *(-xc^2 + x* (xc - xr) + xc *xr + (y - yc)* (yc - yr))/my*r.^3;
% coeffMat(2,1)=(x^3 - 3 *x^2* xc + 3 *x* xc^2 - xc^3 - xr* (y - yc)^2 + ...
%     xc* (y - yc) *(yc - yr) + x* (y - yc)* (y - 2 *yc + yr))/mx*r.^3;
% coeffMat(2,2)=(x* xr* (y - yc) + (y - yc)^3 + xc *xr* (-y + yc) + x^2* (y - yr) + ...
%   xc^2 *(2 *y - yc - yr) + x* xc *(-3* y + yc + 2 *yr))/my*r.^3;
% coefffMatInv(1,2)=1;
% coefffMatInv(2,1)=1;
% coefffMatInv(2,2)=1;
rem=remNum;
U=coeffMatInv*(inv(Kd)*(-Ks*(Kp*epsilon+Kd*epsilond)-Kp*epsilond)-rem);
Xdd=inv(M)*(U-C*[xd;yd]);
xdd=Xdd(1);
ydd=Xdd(2);
thetad=(-xd*y+yd*x)*r;
rd=(x*xd+y*yd)*r^3;
ded=-(xd*(xc-xr)+yd*(yc-yr))*de^2;

f = [xd;yd;xdd;ydd;-s*thetad;c*thetad;thetad;rd;0;0;0];

prog = spotsosprog;
prog = prog.withIndeterminate(vars);

deg_V = 4;
[prog,V] = prog.newSOSPoly(monomials(vars,0:deg_V));
Vdot = diff(V,vars)*f; 

deg_lambda = 2;
lambda_monom = monomials(vars,0:deg_lambda);
[prog,lambda] = prog.newFreePoly(lambda_monom);


%prog = prog.withSOS( -Vdot - lambda*(s^2+c^2-1) );  % asympotic stability
prog = prog.withSOS(lambda);
prog = prog.withSOS( -Vdot - lambda*(s^2+c^2-1));  % exponential stability
% note: thought I might need s^2*Vdot but didn't actually need to leave out the
% upright

% prog = prog.withEqs( subs(V,vars,[0;1;0]) );  % V(0) = 0

% solver = @spot_mosek;
solver = @spot_sedumi;
options = spot_sdp_default_options();
options.verbose = 1;

sol = prog.minimize(0,solver,options);

V = sol.eval(V)
Vdot = sol.eval(Vdot)


[Theta,ThetaDot] = meshgrid(-pi:0.1:pi, -8:0.25:8);  % for surfs

% first plot contours
% 
% figure(1);
% subplot(1,2,1);
% ezcontour(@(theta,thetadot)dmsubs(V,vars,[sin(theta');cos(theta');thetadot']),[-2*pi,2*pi,-8,8]);
% title('$$ V $$','interpreter','latex','fontsize',20) 
% xlabel('$$ \theta $$','interpreter','latex','fontsize',15)
% ylabel('$$ \dot{\theta} $$','interpreter','latex','fontsize',15)
% subplot(1,2,2);
% Vmesh = dmsubs(V,vars,[sin(Theta(:)');cos(Theta(:)');ThetaDot(:)']);
% surf(Theta,ThetaDot,reshape(Vmesh,size(Theta)));
% title('$$ V $$','interpreter','latex','fontsize',20) 
% xlabel('$$ \theta $$','interpreter','latex','fontsize',15)
% ylabel('$$ \dot{\theta} $$','interpreter','latex','fontsize',15)
% 
% figure(2);
% subplot(1,2,1);
% ezcontour(@(theta,thetadot)dmsubs(Vdot,vars,[sin(theta');cos(theta');thetadot']),[-2*pi,2*pi,-8,8]);
% title('$$ \dot{V} $$','interpreter','latex','fontsize',20) 
% xlabel('$$ \theta $$','interpreter','latex','fontsize',15)
% ylabel('$$ \dot{\theta} $$','interpreter','latex','fontsize',15)
% subplot(1,2,2);
% Vdotmesh = dmsubs(Vdot,vars,[sin(Theta(:)');cos(Theta(:)');ThetaDot(:)']);
% surf(Theta,ThetaDot,reshape(Vdotmesh,size(Theta)));
% title('$$ \dot{V} $$','interpreter','latex','fontsize',20) 
% xlabel('$$ \theta $$','interpreter','latex','fontsize',15)
% ylabel('$$ \dot{\theta} $$','interpreter','latex','fontsize',15)

% end
