function fluxf = flux(mesh,field,rho)
%计算物理场的面通量
%简介：
%   flux函数是单纯的插值计算物理场，
%   与cellToFace_Sf()的区别在于flux()不进行边界修正，
%   需要搭配adjustPhi()函数来修正边界面
%函数重载：
%   fluxf = flux(mesh,field)
%   fluxf = flux(mesh,field,rho)
%输入参数：
%   mesh - 结构网格数据结构体
%   field - 计算通量物理场
%   rho - 流体密度
%返回参数：
%   fluxf(faceScalarFieldfvgg) - 物理场通量

global Nx Ny;

if nargin == 2
    rho = 1;
end
if contains(field.type,'Scalar')
%初始化内存
    fluxf = generatefield(mesh,fieldDimension.face,fieldType.scalar);
    field_x = zeros(Ny,Nx+2);
    field_y  = zeros(Ny+2,Nx);
    field_x (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_y (2:end-1,:) = reshape(field.fields.x,[Nx,Ny])';
%计算面物理场
    fluxf.fields.x = (field_x(:,1:end-1) + field_x(:,2:end))/2;
    fluxf.fields.y = (field_y(1:end-1,:) + field_y(2:end,:))/2;
%计算fieldf.*nf
    fluxf.fields.x = fluxf.fields.x .* mesh.faces.nf.x;
    fluxf.fields.y = fluxf.fields.y .* mesh.faces.nf.y;
%计算feildf(vector).*Sf(nf*|S|)
    fluxf.fields.x = fluxf.fields.x .* mesh.faces.areas.x.*rho;
    fluxf.fields.y = fluxf.fields.y .* mesh.faces.areas.y.*rho;

elseif contains(field.type,'Vector')
%初始化内存
    fluxf = generatefield(mesh,fieldDimension.face,fieldType.scalar);
    field_x = zeros(Ny,Nx+2);
    field_y = zeros(Ny+2,Nx);
    field_x(:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_y(2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
%计算面速度场
    fluxf.fields.x = (field_x(:,1:end-1) + field_x(:,2:end))/2;
    fluxf.fields.y = (field_y(1:end-1,:) + field_y(2:end,:))/2;
%计算fieldf.*nf
    fluxf.fields.x = fluxf.fields.x .* mesh.faces.nf.x;
    fluxf.fields.y = fluxf.fields.y .* mesh.faces.nf.y;
%计算feildf(vector).*Sf(nf*|S|)
    fluxf.fields.x = fluxf.fields.x .* mesh.faces.areas.x .* rho;
    fluxf.fields.y = fluxf.fields.y .* mesh.faces.areas.y .* rho;
else
    error('flux():field.type参数错误');
end


end

