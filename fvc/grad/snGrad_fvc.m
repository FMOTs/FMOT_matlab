function gradf = snGrad_fvc(mesh,field,s)
%计算面梯度场
% 简介：
%函数重载：
%   gradf = snGrad_fvc(mesh,field)
%   gradf = snGrad_fvc(mesh,field,s)
%输入参数：
%   Ap - 各网格对应的离散矩阵主元值
%   s - 网格面面积，默认值 = 1
%返回参数：
%   gradf(faceScalarField) - 函数重载1返回snGrad .* nf
%   gradf(faceScalarField) - 函数重载2返回snGrad .* Sf(nf * |Sf| )

global Nx Ny;

if nargin == 2
    s.x = ones(Ny,Nx+1);
    s.y = ones(Ny+1,Nx);
end

global Nx Ny;
if strcmpi(field.type,'volScalarField')
    gradf = calculateSG_scalar(mesh,field,s);
elseif strcmpi(field.type,'volVectorField')
    error('snGrad_fvc():field.type错误');
else 
    error('snGrad_fvc():field.type错误');
end

function gradf = calculateSG_scalar(mesh,field,s)
%标量场的面梯度场计算
    gradf = generatefield(mesh,fieldDimension.face,fieldType.scalar);
    %初始化内存
    field_x = zeros(Ny,Nx+2);
    field_y  = zeros(Ny+2,Nx);
    field_x (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_y (2:end-1,:) = reshape(field.fields.x,[Nx,Ny])';
    %计算面间距|d|
    dx.x = zeros(1,Nx+1);
    dx.y = zeros(1,Nx+1);
    dx_x = zeros(1,Nx+2);
    dx_y = zeros(1,Ny+2);
    dx_x(2:end-1) = mesh.cells.cx;
    dx_y(2:end-1) = mesh.cells.cy;
    %修正边界
    dx_x(end) = mesh.points.x(end);
    dx_y(end) = mesh.points.y(end);
    %计算dx和dy
    dx.x = dx_x(1,2:end) - dx_x(1,1:end-1);
    dx.y = dx_y(1,2:end) - dx_y(1,1:end-1);
    %计算面梯度场 sngrad_f * Sf
    gradf.fields.x = (field_x(:,2:end) - field_x(:,1:end-1))./dx.x;
    gradf.fields.x = gradf.fields.x .* mesh.faces.nf.x .* s.x ;
    gradf.fields.y = (field_y(2:end,:) - field_y(1:end-1,:))./dx.y';
    gradf.fields.y = gradf.fields.y .* mesh.faces.nf.y .* s.y;
    %修正边界(实质上边界面的nf对物理场没有影响)
    gradf = conCorrectSnGrad_vf(mesh,gradf,field);

end


end

