function [phiHbyA,DAp,DApf] = constrainHbyA(mesh,phiHbyA,A1,U,P)
%通过速度场和压力场来修正phiHbyA的边界值
%计算公式：phiHbyAf(HbyA * Sf) = Uf.Sf + Vpf/Apf*gradPf.Sf

global Nx Ny;

%计算Vp/A1(volVectorField)
    DAp = DA1(mesh,A1);
%计算(Vp/Ap)f(faceVectorField):(Vp*alphaU/Ap|p + Vp*alphaU/Ap|E)/2
    DApf = AToAf(DAp);
%计算边界面Uf(faceVectorField)
%提取边界
    U.LBC = linearBC(mesh,U);  
    REU.x = reshape(U.fields.x,[Nx,Ny])';
    REU.y = reshape(U.fields.y,[Nx,Ny])';
    Uf_W = REU.x(:,1) .* U.LBC.W.c1 + U.LBC.W.c2.x;
    Uf_W = Uf_W .* mesh.faces.areas.x(:,1);
    Uf_E = REU.x(:,end) * U.LBC.E.c1 + U.LBC.E.c2.x;
    Uf_E = Uf_E .* mesh.faces.areas.x(:,end);
    Uf_S = REU.y(1,:) * U.LBC.S.c1 + U.LBC.S.c2.y;
    Uf_S = Uf_S .* mesh.faces.areas.y(1,:);
    Uf_N = REU.y(end,:) * U.LBC.N.c1 + U.LBC.N.c2.y;
    Uf_N = Uf_N .* mesh.faces.areas.y(end,:);
%计算snGradPf_sf(faceScalarField):(PE-PP)/dx * sf
%计算边界网格的dx和dy
    endx = mesh.points.x(end);
    endy = mesh.points.y(end);   
    bcdx_b = (mesh.cells.cx(1) - 0);%W
    bcdx_e = (endx - mesh.cells.cx(end));%E
    bcdy_b = (mesh.cells.cy(1) - 0);%S
    bcdy_e = (endy - mesh.cells.cy(end));%N
    %计算边界值
    Pf = reshape(P.fields.x,[Nx,Ny])'; 
    gradPf_W = calculateSnGrad_scalar(P.BC.W,Pf(:,1),bcdx_b);
    gradPf_W = gradPf_W .* mesh.faces.areas.x(:,1);
    gradPf_E = calculateSnGrad_scalar(P.BC.E,Pf(:,end),bcdx_e);
    gradPf_E = gradPf_E .* mesh.faces.areas.x(:,end);
    gradPf_S = calculateSnGrad_scalar(P.BC.S,Pf(1,:),bcdy_b);
    gradPf_S = gradPf_S .* mesh.faces.areas.y(1,:);
    gradPf_N = calculateSnGrad_scalar(P.BC.N,Pf(end,:),bcdy_e);
    gradPf_N = gradPf_N .* mesh.faces.areas.y(end,:);

%修正phiHbyAf
phiHbyA.fields.x(:,1) = Uf_W + DApf.xx(:,1) .* gradPf_W;
phiHbyA.fields.x(:,end) = Uf_E + DApf.xx(:,end) .* gradPf_E;
phiHbyA.fields.y(1,:) = Uf_S + DApf.yy(1,:) .* gradPf_S;
phiHbyA.fields.y(end,:) = Uf_N + DApf.yy(end,:) .* gradPf_N;


function BCsngrad = calculateSnGrad_scalar(BC,PHIc,Dcb)
%计算边界梯度值
if strcmpi(BC.type,'Dirichlet')
    BCsngrad = (PHIc - BC.value)/Dcb;
elseif strcmpi(BC.type,'Neumann')
    BCsngrad = BC.value;
else
    error('conCorrectSnGrad_vf():calculateSnGrad_scalar():边界类型错误');
end
end

end
