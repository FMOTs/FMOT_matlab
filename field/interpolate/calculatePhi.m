function phi = calculatePhi(mesh,phi,U,rho)
%计算面通量
%简介：
%函数重载:
%   phi = calculatePhi(phi,U)
%   phi = calculatePhi(phi,U,rho)
%输入参数
%   mesh - 网格结构数据体
%   phi - 面通量，必须为faceScalarField
%   U - 速度场，可以是faceScalarField或volVectorField
%   rho - 流体密度，默认值为1
global Nx Ny;
%物理场类型检测
if ~contains(phi.type,'faceScalarField')
    error('phi物理场类型错误，必须为(u)confaceScalarField');
end

if ~contains(U.type,'faceScalarField') ...
    &&~ contains(U.type,'volVectorField')
    error('U物理场类型错误，必须为(u)confaceScalarField或volVectorField');
end

%设置默认参数
if nargin == 3
    rho = 1;
end

%初始化
phix = zeros(Ny,Nx+2);
phiy = zeros(Ny+2,Nx);
phix(:,2:end-1) = reshape(U.fields.x,[Nx,Ny])';
phiy(2:end-1,:) = reshape(U.fields.y,[Nx,Ny])';
%计算面速度场
phi.fields.x = (phix(:,1:end-1) + phix(:,2:end))/2;
phi.fields.y = (phiy(1:end-1,:) + phiy(2:end,:))/2;
%计算U.*nf
phi.fields.x = phi.fields.x .* mesh.faces.nf.x;
phi.fields.y = phi.fields.y .* mesh.faces.nf.y;
%修正边界(必须在中间进行边界修正)
phi = conCorrcetBC_Sf(mesh,phi,U);
%计算rho*U.*Sf(nf*|S|)
phi.fields.x = rho * phi.fields.x .* mesh.faces.areas.x;
phi.fields.y = rho * phi.fields.y .* mesh.faces.areas.y;
end

