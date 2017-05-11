function globalStabilitySlidingController

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
vars = [x; y; xd; yd; c; s; theta; r; xc; yc];

% polynomial dynamics (using parameters from the plant class) in terms of
% s,c, and thetadot
xr=0;yr=0; xrd=0; yrd=0; xrdd=0; yrdd=0;
M=[1,0;0,0.3];
C=[1 0; 0 1];
K=[100, 0; 0 ,1];

cx=C(1,1); cy=C(2,2);
Kp=[5 0; 0 5];
Kd=[0.5 0; 0 0.5];
Ks=[10 0;0 2];

% Constructing the vector field dx/dt = f
epsilont=dot([xr - x; yr - y], [-s; c]);
epsilonn=dot([xr-x; yr-y],[-c;-s]);

epsilon=[epsilont;epsilonn];
epsilond=[r.^3.*(xrd.*((xc+(-1).*xr).^2+(yc+(-1).*yr).^2).*((-1).*y+yr)+(-1).*(( ...
  -1).*xd+xrd).*((xc+(-1).*xr).^2+(yc+(-1).*yr).^2).*((-1).*yc+yr)+(-1).*( ...
  (-1).*x+xr).*((xc+(-1).*xr).^2+(yc+(-1).*yr).^2).*yrd+((-1).*xc+xr).*(( ...
  xc+(-1).*xr).^2+(yc+(-1).*yr).^2).*((-1).*yd+yrd)+(xc+(-1).*xr).*(y+(-1) ...
  .*yr).*(xc.*xrd+(-1).*xr.*xrd+(yc+(-1).*yr).*yrd)+(x+(-1).*xr).*(yc+(-1) ...
  .*yr).*((-1).*xc.*xrd+xr.*xrd+((-1).*yc+yr).*yrd)),r.^3.*((-2).*((-1).* ...
  x+xr).*xrd.*((xc+(-1).*xr).^2+(yc+(-1).*yr).^2)+(-2).*((-1).*xc+xr).*(( ...
  -1).*xd+xrd).*((xc+(-1).*xr).^2+(yc+(-1).*yr).^2)+(-2).*((xc+(-1).*xr) ...
  .^2+(yc+(-1).*yr).^2).*((-1).*y+yr).*yrd+(-2).*((xc+(-1).*xr).^2+(yc+( ...
  -1).*yr).^2).*((-1).*yc+yr).*((-1).*yd+yrd)+(-2).*(x+(-1).*xr).*((-1).* ...
  xc+xr).*((-1).*xc.*xrd+xr.*xrd+((-1).*yc+yr).*yrd)+(-2).*(y+(-1).*yr).*( ...
  (-1).*yc+yr).*((-1).*xc.*xrd+xr.*xrd+((-1).*yc+yr).*yrd))].';

remNum=[2.*xd.*xr.^3.*xrd.*yc+(-2).*x.*xr.^2.*xrd.^2.*yc+x.*xr.^3.*xrdd.*yc+3.* ...
  xr.*xrd.^2.*y.*yc.^2+(-1).*xr.^2.*xrdd.*y.*yc.^2+2.*xd.*xr.*xrd.*yc.^3+ ...
  x.*xrd.^2.*yc.^3+(-3).*xr.*xrd.^2.*yc.^3+x.*xr.*xrdd.*yc.^3+xr.^2.* ...
  xrdd.*yc.^3+(-1).*xrdd.*y.*yc.^4+xrdd.*yc.^5+cy.*xr.^5.*yd+2.*cy.* ...
  xr.^3.*yc.^2.*yd+(-2).*xr.^2.*xrd.*yc.^2.*yd+cy.*xr.*yc.^4.*yd+(-2).* ...
  xrd.*yc.^4.*yd+cx.*xd.*(xc.^2+(-2).*xc.*xr+xr.^2+(yc+(-1).*yr).^2).^2.*( ...
  yc+(-1).*yr)+(-2).*xd.*xr.^3.*xrd.*yr+2.*x.*xr.^2.*xrd.^2.*yr+(-1).*x.* ...
  xr.^3.*xrdd.*yr+(-6).*xr.*xrd.^2.*y.*yc.*yr+2.*xr.^2.*xrdd.*y.*yc.*yr+( ...
  -6).*xd.*xr.*xrd.*yc.^2.*yr+(-3).*x.*xrd.^2.*yc.^2.*yr+6.*xr.*xrd.^2.* ...
  yc.^2.*yr+(-3).*x.*xr.*xrdd.*yc.^2.*yr+(-2).*xr.^2.*xrdd.*yc.^2.*yr+4.* ...
  xrdd.*y.*yc.^3.*yr+(-4).*xrdd.*yc.^4.*yr+(-4).*cy.*xr.^3.*yc.*yd.*yr+4.* ...
  xr.^2.*xrd.*yc.*yd.*yr+(-4).*cy.*xr.*yc.^3.*yd.*yr+8.*xrd.*yc.^3.*yd.* ...
  yr+3.*xr.*xrd.^2.*y.*yr.^2+(-1).*xr.^2.*xrdd.*y.*yr.^2+6.*xd.*xr.*xrd.* ...
  yc.*yr.^2+3.*x.*xrd.^2.*yc.*yr.^2+(-3).*xr.*xrd.^2.*yc.*yr.^2+3.*x.*xr.* ...
  xrdd.*yc.*yr.^2+xr.^2.*xrdd.*yc.*yr.^2+(-6).*xrdd.*y.*yc.^2.*yr.^2+6.* ...
  xrdd.*yc.^3.*yr.^2+2.*cy.*xr.^3.*yd.*yr.^2+(-2).*xr.^2.*xrd.*yd.*yr.^2+ ...
  6.*cy.*xr.*yc.^2.*yd.*yr.^2+(-12).*xrd.*yc.^2.*yd.*yr.^2+(-2).*xd.*xr.* ...
  xrd.*yr.^3+(-1).*x.*xrd.^2.*yr.^3+(-1).*x.*xr.*xrdd.*yr.^3+4.*xrdd.*y.* ...
  yc.*yr.^3+(-4).*xrdd.*yc.^2.*yr.^3+(-4).*cy.*xr.*yc.*yd.*yr.^3+8.*xrd.* ...
  yc.*yd.*yr.^3+(-1).*xrdd.*y.*yr.^4+xrdd.*yc.*yr.^4+cy.*xr.*yd.*yr.^4+( ...
  -2).*xrd.*yd.*yr.^4+2.*xd.*xr.^4.*yrd+(-2).*x.*xr.^3.*xrd.*yrd+4.* ...
  xr.^2.*xrd.*y.*yc.*yrd+2.*xd.*xr.^2.*yc.^2.*yrd+4.*x.*xr.*xrd.*yc.^2.* ...
  yrd+(-4).*xr.^2.*xrd.*yc.^2.*yrd+(-2).*xrd.*y.*yc.^3.*yrd+2.*xrd.* ...
  yc.^4.*yrd+(-2).*xr.^3.*yc.*yd.*yrd+(-2).*xr.*yc.^3.*yd.*yrd+(-4).* ...
  xr.^2.*xrd.*y.*yr.*yrd+(-4).*xd.*xr.^2.*yc.*yr.*yrd+(-8).*x.*xr.*xrd.* ...
  yc.*yr.*yrd+4.*xr.^2.*xrd.*yc.*yr.*yrd+6.*xrd.*y.*yc.^2.*yr.*yrd+(-6).* ...
  xrd.*yc.^3.*yr.*yrd+2.*xr.^3.*yd.*yr.*yrd+6.*xr.*yc.^2.*yd.*yr.*yrd+2.* ...
  xd.*xr.^2.*yr.^2.*yrd+4.*x.*xr.*xrd.*yr.^2.*yrd+(-6).*xrd.*y.*yc.* ...
  yr.^2.*yrd+6.*xrd.*yc.^2.*yr.^2.*yrd+(-6).*xr.*yc.*yd.*yr.^2.*yrd+2.* ...
  xrd.*y.*yr.^3.*yrd+(-2).*xrd.*yc.*yr.^3.*yrd+2.*xr.*yd.*yr.^3.*yrd+ ...
  xr.^3.*y.*yrd.^2+3.*x.*xr.^2.*yc.*yrd.^2+(-1).*xr.^3.*yc.*yrd.^2+(-2).* ...
  xr.*y.*yc.^2.*yrd.^2+2.*xr.*yc.^3.*yrd.^2+(-3).*x.*xr.^2.*yr.*yrd.^2+4.* ...
  xr.*y.*yc.*yr.*yrd.^2+(-4).*xr.*yc.^2.*yr.*yrd.^2+(-2).*xr.*y.*yr.^2.* ...
  yrd.^2+2.*xr.*yc.*yr.^2.*yrd.^2+x.*xr.^4.*yrdd+(-1).*xr.^3.*y.*yc.*yrdd+ ...
  x.*xr.^2.*yc.^2.*yrdd+xr.^3.*yc.^2.*yrdd+(-1).*xr.*y.*yc.^3.*yrdd+xr.* ...
  yc.^4.*yrdd+xr.^3.*y.*yr.*yrdd+(-2).*x.*xr.^2.*yc.*yr.*yrdd+(-1).* ...
  xr.^3.*yc.*yr.*yrdd+3.*xr.*y.*yc.^2.*yr.*yrdd+(-3).*xr.*yc.^3.*yr.*yrdd+ ...
  x.*xr.^2.*yr.^2.*yrdd+(-3).*xr.*y.*yc.*yr.^2.*yrdd+3.*xr.*yc.^2.*yr.^2.* ...
  yrdd+xr.*y.*yr.^3.*yrdd+(-1).*xr.*yc.*yr.^3.*yrdd+(-1).*xc.^5.*(cy.*yd+ ...
  yrdd)+xc.^4.*(5.*cy.*xr.*yd+xrdd.*(yc+(-1).*yr)+2.*xd.*yrd+(-2).*xrd.* ...
  yrd+x.*yrdd+4.*xr.*yrdd)+(-1).*xc.^3.*(x.*xrdd.*yc+3.*xr.*xrdd.*yc+10.* ...
  cy.*xr.^2.*yd+2.*cy.*yc.^2.*yd+(-2).*xrd.^2.*(yc+(-1).*yr)+(-1).*x.* ...
  xrdd.*yr+(-3).*xr.*xrdd.*yr+(-4).*cy.*yc.*yd.*yr+2.*cy.*yd.*yr.^2+(-2).* ...
  (x+3.*xr).*xrd.*yrd+(-2).*yc.*yd.*yrd+2.*yd.*yr.*yrd+y.*yrd.^2+2.*yc.* ...
  yrd.^2+(-3).*yr.*yrd.^2+2.*xd.*(xrd.*(yc+(-1).*yr)+4.*xr.*yrd)+4.*x.* ...
  xr.*yrdd+6.*xr.^2.*yrdd+(-1).*y.*yc.*yrdd+2.*yc.^2.*yrdd+y.*yr.*yrdd+( ...
  -3).*yc.*yr.*yrdd+yr.^2.*yrdd)+xc.^2.*((-4).*xr.*xrd.^2.*yc+3.*xr.^2.* ...
  xrdd.*yc+(-1).*xrdd.*y.*yc.^2+2.*xrdd.*yc.^3+10.*cy.*xr.^3.*yd+6.*cy.* ...
  xr.*yc.^2.*yd+(-2).*xrd.*yc.^2.*yd+4.*xr.*xrd.^2.*yr+(-3).*xr.^2.*xrdd.* ...
  yr+2.*xrdd.*y.*yc.*yr+(-5).*xrdd.*yc.^2.*yr+(-12).*cy.*xr.*yc.*yd.*yr+ ...
  4.*xrd.*yc.*yd.*yr+(-1).*xrdd.*y.*yr.^2+4.*xrdd.*yc.*yr.^2+6.*cy.*xr.* ...
  yd.*yr.^2+(-2).*xrd.*yd.*yr.^2+(-1).*xrdd.*yr.^3+(-6).*xr.^2.*xrd.*yrd+ ...
  4.*xrd.*y.*yc.*yrd+(-6).*xr.*yc.*yd.*yrd+(-4).*xrd.*y.*yr.*yrd+(-4).* ...
  xrd.*yc.*yr.*yrd+6.*xr.*yd.*yr.*yrd+4.*xrd.*yr.^2.*yrd+3.*xr.*y.*yrd.^2+ ...
  3.*xr.*yc.*yrd.^2+(-6).*xr.*yr.*yrd.^2+2.*xd.*(3.*xr.*xrd.*(yc+(-1).*yr) ...
  +6.*xr.^2.*yrd+(yc+(-1).*yr).^2.*yrd)+4.*xr.^3.*yrdd+(-3).*xr.*y.*yc.* ...
  yrdd+5.*xr.*yc.^2.*yrdd+3.*xr.*y.*yr.*yrdd+(-7).*xr.*yc.*yr.*yrdd+2.* ...
  xr.*yr.^2.*yrdd+x.*((-2).*xrd.^2.*(yc+(-1).*yr)+3.*xr.*xrdd.*(yc+(-1).* ...
  yr)+(-6).*xr.*xrd.*yrd+6.*xr.^2.*yrdd+(yc+(-1).*yr).*(3.*yrd.^2+yc.* ...
  yrdd+(-1).*yr.*yrdd)))+(-1).*xc.*((-2).*xr.^2.*xrd.^2.*yc+xr.^3.*xrdd.* ...
  yc+3.*xrd.^2.*y.*yc.^2+(-2).*xr.*xrdd.*y.*yc.^2+(-2).*xrd.^2.*yc.^3+3.* ...
  xr.*xrdd.*yc.^3+5.*cy.*xr.^4.*yd+6.*cy.*xr.^2.*yc.^2.*yd+(-4).*xr.*xrd.* ...
  yc.^2.*yd+cy.*yc.^4.*yd+2.*xr.^2.*xrd.^2.*yr+(-1).*xr.^3.*xrdd.*yr+(-6) ...
  .*xrd.^2.*y.*yc.*yr+4.*xr.*xrdd.*y.*yc.*yr+3.*xrd.^2.*yc.^2.*yr+(-7).* ...
  xr.*xrdd.*yc.^2.*yr+(-12).*cy.*xr.^2.*yc.*yd.*yr+8.*xr.*xrd.*yc.*yd.*yr+ ...
  (-4).*cy.*yc.^3.*yd.*yr+3.*xrd.^2.*y.*yr.^2+(-2).*xr.*xrdd.*y.*yr.^2+5.* ...
  xr.*xrdd.*yc.*yr.^2+6.*cy.*xr.^2.*yd.*yr.^2+(-4).*xr.*xrd.*yd.*yr.^2+6.* ...
  cy.*yc.^2.*yd.*yr.^2+(-1).*xrd.^2.*yr.^3+(-1).*xr.*xrdd.*yr.^3+(-4).* ...
  cy.*yc.*yd.*yr.^3+cy.*yd.*yr.^4+(-2).*xr.^3.*xrd.*yrd+8.*xr.*xrd.*y.* ...
  yc.*yrd+(-4).*xr.*xrd.*yc.^2.*yrd+(-6).*xr.^2.*yc.*yd.*yrd+(-2).*yc.^3.* ...
  yd.*yrd+(-8).*xr.*xrd.*y.*yr.*yrd+6.*xr.^2.*yd.*yr.*yrd+6.*yc.^2.*yd.* ...
  yr.*yrd+4.*xr.*xrd.*yr.^2.*yrd+(-6).*yc.*yd.*yr.^2.*yrd+2.*yd.*yr.^3.* ...
  yrd+3.*xr.^2.*y.*yrd.^2+(-2).*y.*yc.^2.*yrd.^2+2.*yc.^3.*yrd.^2+(-3).* ...
  xr.^2.*yr.*yrd.^2+4.*y.*yc.*yr.*yrd.^2+(-4).*yc.^2.*yr.*yrd.^2+(-2).*y.* ...
  yr.^2.*yrd.^2+2.*yc.*yr.^2.*yrd.^2+2.*xd.*(3.*xr.^2.*xrd.*(yc+(-1).*yr)+ ...
  xrd.*(yc+(-1).*yr).^3+4.*xr.^3.*yrd+2.*xr.*(yc+(-1).*yr).^2.*yrd)+ ...
  xr.^4.*yrdd+(-3).*xr.^2.*y.*yc.*yrdd+4.*xr.^2.*yc.^2.*yrdd+(-1).*y.* ...
  yc.^3.*yrdd+yc.^4.*yrdd+3.*xr.^2.*y.*yr.*yrdd+(-5).*xr.^2.*yc.*yr.*yrdd+ ...
  3.*y.*yc.^2.*yr.*yrdd+(-3).*yc.^3.*yr.*yrdd+xr.^2.*yr.^2.*yrdd+(-3).*y.* ...
  yc.*yr.^2.*yrdd+3.*yc.^2.*yr.^2.*yrdd+y.*yr.^3.*yrdd+(-1).*yc.*yr.^3.* ...
  yrdd+x.*(3.*xr.^2.*(xrdd.*yc+(-1).*xrdd.*yr+(-2).*xrd.*yrd)+(yc+(-1).* ...
  yr).^2.*(xrdd.*yc+(-1).*xrdd.*yr+4.*xrd.*yrd)+4.*xr.^3.*yrdd+2.*xr.*(yc+ ...
  (-1).*yr).*((-2).*xrd.^2+3.*yrd.^2+yc.*yrdd+(-1).*yr.*yrdd))),xc.^5.* ...
  xrdd+(-1).*xr.^5.*xrdd+(-2).*xr.^2.*xrd.^2.*y.*yc+xr.^3.*xrdd.*y.*yc+2.* ...
  xd.*xr.^2.*xrd.*yc.^2+(-3).*x.*xr.*xrd.^2.*yc.^2+xr.^2.*xrd.^2.*yc.^2+ ...
  x.*xr.^2.*xrdd.*yc.^2+(-3).*xr.^3.*xrdd.*yc.^2+xrd.^2.*y.*yc.^3+xr.* ...
  xrdd.*y.*yc.^3+2.*xd.*xrd.*yc.^4+(-2).*xrd.^2.*yc.^4+x.*xrdd.*yc.^4+(-2) ...
  .*xr.*xrdd.*yc.^4+cy.*xr.^4.*yc.*yd+2.*xr.^3.*xrd.*yc.*yd+2.*cy.*xr.^2.* ...
  yc.^3.*yd+2.*xr.*xrd.*yc.^3.*yd+cy.*yc.^5.*yd+cx.*xd.*(xc+(-1).*xr).*( ...
  xc.^2+(-2).*xc.*xr+xr.^2+(yc+(-1).*yr).^2).^2+2.*xr.^2.*xrd.^2.*y.*yr+( ...
  -1).*xr.^3.*xrdd.*y.*yr+(-4).*xd.*xr.^2.*xrd.*yc.*yr+6.*x.*xr.*xrd.^2.* ...
  yc.*yr+(-2).*x.*xr.^2.*xrdd.*yc.*yr+5.*xr.^3.*xrdd.*yc.*yr+(-3).* ...
  xrd.^2.*y.*yc.^2.*yr+(-3).*xr.*xrdd.*y.*yc.^2.*yr+(-8).*xd.*xrd.*yc.^3.* ...
  yr+7.*xrd.^2.*yc.^3.*yr+(-4).*x.*xrdd.*yc.^3.*yr+7.*xr.*xrdd.*yc.^3.*yr+ ...
  (-1).*cy.*xr.^4.*yd.*yr+(-2).*xr.^3.*xrd.*yd.*yr+(-6).*cy.*xr.^2.* ...
  yc.^2.*yd.*yr+(-6).*xr.*xrd.*yc.^2.*yd.*yr+(-5).*cy.*yc.^4.*yd.*yr+2.* ...
  xd.*xr.^2.*xrd.*yr.^2+(-3).*x.*xr.*xrd.^2.*yr.^2+(-1).*xr.^2.*xrd.^2.* ...
  yr.^2+x.*xr.^2.*xrdd.*yr.^2+(-2).*xr.^3.*xrdd.*yr.^2+3.*xrd.^2.*y.*yc.* ...
  yr.^2+3.*xr.*xrdd.*y.*yc.*yr.^2+12.*xd.*xrd.*yc.^2.*yr.^2+(-9).*xrd.^2.* ...
  yc.^2.*yr.^2+6.*x.*xrdd.*yc.^2.*yr.^2+(-9).*xr.*xrdd.*yc.^2.*yr.^2+6.* ...
  cy.*xr.^2.*yc.*yd.*yr.^2+6.*xr.*xrd.*yc.*yd.*yr.^2+10.*cy.*yc.^3.*yd.* ...
  yr.^2+(-1).*xrd.^2.*y.*yr.^3+(-1).*xr.*xrdd.*y.*yr.^3+(-8).*xd.*xrd.* ...
  yc.*yr.^3+5.*xrd.^2.*yc.*yr.^3+(-4).*x.*xrdd.*yc.*yr.^3+5.*xr.*xrdd.* ...
  yc.*yr.^3+(-2).*cy.*xr.^2.*yd.*yr.^3+(-2).*xr.*xrd.*yd.*yr.^3+(-10).* ...
  cy.*yc.^2.*yd.*yr.^3+2.*xd.*xrd.*yr.^4+(-1).*xrd.^2.*yr.^4+x.*xrdd.* ...
  yr.^4+(-1).*xr.*xrdd.*yr.^4+5.*cy.*yc.*yd.*yr.^4+(-1).*cy.*yd.*yr.^5+( ...
  -2).*xr.^3.*xrd.*y.*yrd+2.*xd.*xr.^3.*yc.*yrd+(-4).*x.*xr.^2.*xrd.*yc.* ...
  yrd+4.*xr.*xrd.*y.*yc.^2.*yrd+2.*xd.*xr.*yc.^3.*yrd+2.*x.*xrd.*yc.^3.* ...
  yrd+(-6).*xr.*xrd.*yc.^3.*yrd+2.*xr.^4.*yd.*yrd+2.*xr.^2.*yc.^2.*yd.* ...
  yrd+(-2).*xd.*xr.^3.*yr.*yrd+4.*x.*xr.^2.*xrd.*yr.*yrd+2.*xr.^3.*xrd.* ...
  yr.*yrd+(-8).*xr.*xrd.*y.*yc.*yr.*yrd+(-6).*xd.*xr.*yc.^2.*yr.*yrd+(-6) ...
  .*x.*xrd.*yc.^2.*yr.*yrd+14.*xr.*xrd.*yc.^2.*yr.*yrd+(-4).*xr.^2.*yc.* ...
  yd.*yr.*yrd+4.*xr.*xrd.*y.*yr.^2.*yrd+6.*xd.*xr.*yc.*yr.^2.*yrd+6.*x.* ...
  xrd.*yc.*yr.^2.*yrd+(-10).*xr.*xrd.*yc.*yr.^2.*yrd+2.*xr.^2.*yd.*yr.^2.* ...
  yrd+(-2).*xd.*xr.*yr.^3.*yrd+(-2).*x.*xrd.*yr.^3.*yrd+2.*xr.*xrd.* ...
  yr.^3.*yrd+(-1).*x.*xr.^3.*yrd.^2+(-1).*xr.^4.*yrd.^2+3.*xr.^2.*y.*yc.* ...
  yrd.^2+2.*x.*xr.*yc.^2.*yrd.^2+(-4).*xr.^2.*yc.^2.*yrd.^2+(-3).*xr.^2.* ...
  y.*yr.*yrd.^2+(-4).*x.*xr.*yc.*yr.*yrd.^2+5.*xr.^2.*yc.*yr.*yrd.^2+2.* ...
  x.*xr.*yr.^2.*yrd.^2+(-1).*xr.^2.*yr.^2.*yrd.^2+xr.^4.*y.*yrdd+x.* ...
  xr.^3.*yc.*yrdd+xr.^2.*y.*yc.^2.*yrdd+x.*xr.*yc.^3.*yrdd+xr.^2.*yc.^3.* ...
  yrdd+yc.^5.*yrdd+(-1).*x.*xr.^3.*yr.*yrdd+(-1).*xr.^4.*yr.*yrdd+(-2).* ...
  xr.^2.*y.*yc.*yr.*yrdd+(-3).*x.*xr.*yc.^2.*yr.*yrdd+(-4).*xr.^2.*yc.^2.* ...
  yr.*yrdd+(-5).*yc.^4.*yr.*yrdd+xr.^2.*y.*yr.^2.*yrdd+3.*x.*xr.*yc.* ...
  yr.^2.*yrdd+5.*xr.^2.*yc.*yr.^2.*yrdd+10.*yc.^3.*yr.^2.*yrdd+(-1).*x.* ...
  xr.*yr.^3.*yrdd+(-2).*xr.^2.*yr.^3.*yrdd+(-10).*yc.^2.*yr.^3.*yrdd+5.* ...
  yc.*yr.^4.*yrdd+(-1).*yr.^5.*yrdd+xc.^4.*((-5).*xr.*xrdd+cy.*yd.*(yc+( ...
  -1).*yr)+2.*yd.*yrd+(-2).*yrd.^2+y.*yrdd+yc.*yrdd+(-2).*yr.*yrdd)+ ...
  xc.^3.*(10.*xr.^2.*xrdd+(-2).*xrd.*yc.*yd+2.*xrd.*yd.*yr+(-1).*xrdd.*( ...
  yc+(-1).*yr).*(y+(-2).*yc+yr)+2.*xrd.*y.*yrd+(-2).*xd.*yc.*yrd+4.*xrd.* ...
  yc.*yrd+2.*xd.*yr.*yrd+(-6).*xrd.*yr.*yrd+x.*yrd.^2+(-1).*x.*yc.*yrdd+ ...
  x.*yr.*yrdd+xr.*(4.*cy.*yd.*((-1).*yc+yr)+(-8).*yd.*yrd+7.*yrd.^2+(-4).* ...
  y.*yrdd+(-3).*yc.*yrdd+7.*yr.*yrdd))+xc.^2.*((-10).*xr.^3.*xrdd+3.* ...
  xr.^2.*(2.*cy.*yd.*(yc+(-1).*yr)+4.*yd.*yrd+(-3).*yrd.^2+2.*y.*yrdd+yc.* ...
  yrdd+(-3).*yr.*yrdd)+xr.*(xrdd.*(yc+(-1).*yr).*(3.*y+(-7).*yc+4.*yr)+6.* ...
  xd.*yc.*yrd+(-6).*xd.*yr.*yrd+(-3).*x.*yrd.^2+2.*xrd.*(3.*yc.*yd+(-3).* ...
  yd.*yr+(-3).*y.*yrd+(-4).*yc.*yrd+7.*yr.*yrd)+3.*x.*yc.*yrdd+(-3).*x.* ...
  yr.*yrdd)+(yc+(-1).*yr).*(2.*cy.*yc.^2.*yd+(-2).*xrd.^2.*(y+yc+(-2).*yr) ...
  +x.*xrdd.*(yc+(-1).*yr)+(-4).*cy.*yc.*yd.*yr+2.*cy.*yd.*yr.^2+2.*yc.* ...
  yd.*yrd+(-2).*yd.*yr.*yrd+3.*y.*yrd.^2+(-2).*yc.*yrd.^2+(-1).*yr.* ...
  yrd.^2+2.*xrd.*(xd.*(yc+(-1).*yr)+(-2).*x.*yrd)+y.*yc.*yrdd+2.*yc.^2.* ...
  yrdd+(-1).*y.*yr.*yrdd+(-5).*yc.*yr.*yrdd+3.*yr.^2.*yrdd))+xc.*(5.* ...
  xr.^4.*xrdd+(-1).*xr.^3.*(4.*cy.*yd.*(yc+(-1).*yr)+8.*yd.*yrd+(-5).* ...
  yrd.^2+4.*y.*yrdd+yc.*yrdd+(-5).*yr.*yrdd)+xr.^2.*(xrdd.*((-3).*y+8.*yc+ ...
  (-5).*yr).*(yc+(-1).*yr)+(-6).*xd.*yc.*yrd+6.*xd.*yr.*yrd+3.*x.*yrd.^2+ ...
  xrd.*((-6).*yc.*yd+6.*yd.*yr+6.*y.*yrd+4.*yc.*yrd+(-10).*yr.*yrd)+(-3).* ...
  x.*yc.*yrdd+3.*x.*yr.*yrdd)+xr.*(yc+(-1).*yr).*((-4).*cy.*yc.^2.*yd+ ...
  xrd.^2.*(4.*y+yc+(-5).*yr)+8.*cy.*yc.*yd.*yr+(-4).*cy.*yd.*yr.^2+2.*x.* ...
  xrdd.*((-1).*yc+yr)+(-4).*yc.*yd.*yrd+4.*yd.*yr.*yrd+(-6).*y.*yrd.^2+6.* ...
  yc.*yrd.^2+xrd.*((-4).*xd.*yc+4.*xd.*yr+8.*x.*yrd)+(-2).*y.*yc.*yrdd+( ...
  -3).*yc.^2.*yrdd+2.*y.*yr.*yrdd+8.*yc.*yr.*yrdd+(-5).*yr.^2.*yrdd)+(yc+( ...
  -1).*yr).^2.*((-2).*xrd.*yc.*yd+(-1).*xrdd.*(y+(-1).*yc).*(yc+(-1).*yr)+ ...
  2.*xrd.*yd.*yr+(-4).*xrd.*y.*yrd+(-2).*xd.*yc.*yrd+4.*xrd.*yc.*yrd+2.* ...
  xd.*yr.*yrd+x.*(3.*xrd.^2+(-2).*yrd.^2+(-1).*yc.*yrdd+yr.*yrdd)))].';

coeffMatInv=[(-yc+yr), (-xc+xr); (xc-xr), (-yc+yr)]*r;
rem=remNum*r^5;
U=coeffMatInv*(inv(Kd)*(-Ks*(Kp*epsilon+Kd*epsilond)-Kp*epsilond)-rem);
Xdd=inv(M)*(U-C*[xd;yd]);
xdd=Xdd(1);
ydd=Xdd(2);
thetad=(-xd*y+yd*x)*r;
rd=(x*xd+y*yd)*r^3;

f = [xd;yd;xdd;ydd;-s*thetad;c*thetad;thetad;rd;0;0];

prog = spotsosprog;
prog = prog.withIndeterminate(vars);

deg_V = 2;
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

end
