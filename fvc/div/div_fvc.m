function source = div_fvc(mesh,Uf,rho)
%显式计算网格内散度
%简介：
%函数重载:
%   b = div_fvc(mesh,Uf)
%   b = div_fvc(mesh,Uf,rho)
%输入参数
%   mesh - 网格数据结构体
%   Uf - 面速度场(faceScalarField)
%   rho - 密度，默认值 = 1
%返回参数
%   b = rho * uf.*Sf
global Nx Ny;

if nargin == 2
    rho = 1;
end
source.A = sparse(Nx*Ny,Nx*Ny);
source.b = zeros(Nx*Ny,1);
div_x = zeros(Ny,Nx);
div_y = zeros(Ny,Nx);
div_x = Uf.fields.xx(:,2:end).*mesh.faces.areas.x(:,2:end)...
      - Uf.fields.xx(:,1:end-1).*mesh.faces.areas.x(:,1:end-1);
div_y = Uf.fields.yy(2:end,:).*mesh.faces.areas.y(2:end,:)...
      - Uf.fields.yy(1:end-1,:).*mesh.faces.areas.y(1:end-1,:);
div_x = div_x .* rho;
div_y = div_y .* rho;
source.b = reshape(div_x',[Nx*Ny,1]) + reshape(div_y',[Nx*Ny,1]);
source.type = 'fvc::div::gauss';
end

