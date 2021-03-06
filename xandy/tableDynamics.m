function res=tableDynamics(t,X,timeSamples,Xr,model)

[~, index] = min(abs(timeSamples-t));
U=getU(X,Xr(index,:).',model);
% U=[-0.1;0];
ux=U(1);
uy=U(2);
x=X(1);
y=X(2);
xd=X(3);
yd=X(4);
Fspindle=[0;0];

if (model.r+model.spRad)>norm(model.spPos-[x;y])
    theta=atan2(-model.spPos(2)+y,-model.spPos(1)+x);
    Fspindle=model.spK*((model.r+model.spRad)-norm(model.spPos-[x;y]))*...
        [cos(theta);sin(theta)];
end

F=Fspindle+[ux;uy];
res=[X(3);X(4);(F(1)-model.cx*X(3))/model.mx; (F(2)-model.cy*X(4))/model.my];
end
    