T=[(-1).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc),(x+(-1).* ...
  xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2);(-1).*(x+(-1).*xc).*((x+( ...
  -1).*xc).^2+(y+(-1).*yc).^2).^(-1/2),(-1).*((x+(-1).*xc).^2+(y+(-1).*yc) ...
  .^2).^(-1/2).*(y+(-1).*yc)];
Td=[(-1).*(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(xd.*(( ...
  x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc).*((x+( ...
  -1).*xc).^2+(y+(-1).*yc).^2).^(-1).*yd),(-1).*((x+(-1).*xc).^2+(y+(-1).* ...
  yc).^2).^(-1/2).*(y+(-1).*yc).*(xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^( ...
  -1).*((-1).*y+yc)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1) ...
  .*yd);((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*(xd.*((x+ ...
  (-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc).*((x+(-1) ...
  .*xc).^2+(y+(-1).*yc).^2).^(-1).*yd),(-1).*(x+(-1).*xc).*((x+(-1).*xc) ...
  .^2+(y+(-1).*yc).^2).^(-1/2).*(xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^( ...
  -1).*((-1).*y+yc)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1) ...
  .*yd)];
Tdd=[((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*(xd.*((x+(-1) ...
  .*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc).*((x+(-1).* ...
  xc).^2+(y+(-1).*yc).^2).^(-1).*yd).^2+(-1).*(x+(-1).*xc).*((x+(-1).*xc) ...
  .^2+(y+(-1).*yc).^2).^(-1/2).*((-1).*xd.*((x+(-1).*xc).^2+(y+(-1).*yc) ...
  .^2).^(-2).*((-1).*y+yc).*(2.*(x+(-1).*xc).*xd+2.*(y+(-1).*yc).*yd)+(-1) ...
  .*(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-2).*yd.*(2.*(x+(-1) ...
  .*xc).*xd+2.*(y+(-1).*yc).*yd)+((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).* ...
  ((-1).*y+yc).*xdd+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2) ...
  .^(-1).*ydd),(-1).*(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2) ...
  .^(-1/2).*(xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc)+(x+ ...
  (-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*yd).^2+(-1).*((x+( ...
  -1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*((-1).*xd.*((x+(-1) ...
  .*xc).^2+(y+(-1).*yc).^2).^(-2).*((-1).*y+yc).*(2.*(x+(-1).*xc).*xd+2.*( ...
  y+(-1).*yc).*yd)+(-1).*(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2) ...
  .^(-2).*yd.*(2.*(x+(-1).*xc).*xd+2.*(y+(-1).*yc).*yd)+((x+(-1).*xc).^2+( ...
  y+(-1).*yc).^2).^(-1).*((-1).*y+yc).*xdd+(x+(-1).*xc).*((x+(-1).* ...
  xc).^2+(y+(-1).*yc).^2).^(-1).*ydd);(x+(-1).*xc).*((x+(-1).*xc).^2+ ...
  (y+(-1).*yc).^2).^(-1/2).*(xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).* ...
  ((-1).*y+yc)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*yd) ...
  .^2+((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*((-1).*xd.* ...
  ((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-2).*((-1).*y+yc).*(2.*(x+(-1).*xc) ...
  .*xd+2.*(y+(-1).*yc).*yd)+(-1).*(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).* ...
  yc).^2).^(-2).*yd.*(2.*(x+(-1).*xc).*xd+2.*(y+(-1).*yc).*yd)+((x+(-1).* ...
  xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc).*xdd+(x+(-1).*xc).*((x+ ...
  (-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*ydd),((x+(-1).*xc).^2+(y+(-1) ...
  .*yc).^2).^(-1/2).*(y+(-1).*yc).*(xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2) ...
  .^(-1).*((-1).*y+yc)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^( ...
  -1).*yd).^2+(-1).*(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^( ...
  -1/2).*((-1).*xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-2).*((-1).*y+yc) ...
  .*(2.*(x+(-1).*xc).*xd+2.*(y+(-1).*yc).*yd)+(-1).*(x+(-1).*xc).*((x+(-1) ...
  .*xc).^2+(y+(-1).*yc).^2).^(-2).*yd.*(2.*(x+(-1).*xc).*xd+2.*(y+(-1).* ...
  yc).*yd)+((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc).*xdd ...
  +(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*ydd)];
epsilon=[(x+(-1).*xr).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc)+( ...
  x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*((-1).*y+yr),(x+ ...
  (-1).*xc).*(x+(-1).*xr).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2)+((x+( ...
  -1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*(y+(-1).*yr)];
epsilond=[(xd+(-1).*xrd).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc) ...
  +(x+(-1).*xc).*(x+(-1).*xr).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).* ...
  (xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc) ...
  .*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*yd)+(-1).*((x+(-1).*xc).^2+( ...
  y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*(xd.*((x+(-1).*xc).^2+(y+(-1).* ...
  yc).^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc) ...
  .^2).^(-1).*yd).*((-1).*y+yr)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).* ...
  yc).^2).^(-1/2).*((-1).*yd+yrd),(x+(-1).*xc).*(xd+(-1).*xrd).*((x+(-1).* ...
  xc).^2+(y+(-1).*yc).^2).^(-1/2)+(-1).*(x+(-1).*xr).*((x+(-1).*xc).^2+(y+ ...
  (-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*(xd.*((x+(-1).*xc).^2+(y+(-1).*yc) ...
  .^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2) ...
  .^(-1).*yd)+(x+(-1).*xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1/2).*( ...
  xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc).* ...
  ((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*yd).*(y+(-1).*yr)+((x+(-1).*xc) ...
  .^2+(y+(-1).*yc).^2).^(-1/2).*(y+(-1).*yc).*(yd+(-1).*yrd)];
theta=atan(x+(-1).*xc,y+(-1).*yc);
thetad=xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc)+(x+(-1).*xc).* ...
  ((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*yd;
thetadd=(-1).*xd.*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-2).*((-1).*y+yc).*(2.*(x+ ...
  (-1).*xc).*xd+2.*(y+(-1).*yc).*yd)+(-1).*(x+(-1).*xc).*((x+(-1).*xc).^2+ ...
  (y+(-1).*yc).^2).^(-2).*yd.*(2.*(x+(-1).*xc).*xd+2.*(y+(-1).*yc).*yd)+(( ...
  x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*((-1).*y+yc).*xdd+(x+(-1).* ...
  xc).*((x+(-1).*xc).^2+(y+(-1).*yc).^2).^(-1).*ydd;
