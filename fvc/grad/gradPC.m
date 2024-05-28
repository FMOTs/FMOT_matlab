function gradField = gradPC(mesh,field)
%修成压力特殊的梯度项生成
%简介：
%函数重载：
%   Ab = gradPC(mesh,field)
%输入参数：
%   mesh - 网格数据结构体
%   field - 计算物理场
%   gradScheme - 梯度项离散格式
%   gradType - 计算梯度的类型，分成计算volField和Su两种,
%              默认gradType = volField
%返回参数：
%   Ab(volVectorField) - 函数重载1返回gradP，单纯计算物理场梯度
%   Ab(volVectorField) - 函数重载2返回gradP * Vp(网格体积)，N-S方程需要
global Nx Ny;


% %初始化内存
%     faceField = generatefield(mesh,fieldDimension.face,fieldType.scalar);
%     field_x = zeros(Ny,Nx+2);
%     field_y  = zeros(Ny+2,Nx);
%     field_x (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
%     field_y (2:end-1,:) = reshape(field.fields.x,[Nx,Ny])';
% %计算面间距|d|
%     dx.x = zeros(1,Nx+1);
%     dx.y = zeros(1,Nx+1);
%     dx_x = zeros(1,Nx+2);
%     dx_y = zeros(1,Ny+2);
%     dx_x(2:end-1) = mesh.cells.cx;
%     dx_y(2:end-1) = mesh.cells.cy;
% %修正边界
%     dx_x(end) = mesh.points.x(end);
%     dx_y(end) = mesh.points.y(end);
% %计算dx和dy
%     dx.x = dx_x(1,2:end) - dx_x(1,1:end-1);
%     dx.y = dx_y(1,2:end) - dx_y(1,1:end-1);
% 
% %计算面物理场
%     gradField.fields.x = (field_x(:,2:end) - field_x(:,1:end-1))/2.*dx.x;
%     gradField.fields.y = (field_y(2:end,:) - field_y(1:end-1,:))/2.*dx.y';

gradField = generatefield(mesh,fieldDimension.vol,fieldType.vector);
field_f = cellToface_Sf(mesh,field);
        
% %修正边界面值
field_f.fields.x(:,1) = 0;
field_f.fields.x(:,end) = 0;
field_f.fields.y(1,:) = 0;
field_f.fields.y(end,:) = 0;

diff_fx = (field_f.fields.x(:,2:end)-...
           field_f.fields.x(:,1:end-1));
diff_fy = (field_f.fields.y(2:end,:)-...
           field_f.fields.y(1:end-1,:));
gradField.fields.x = reshape(diff_fx',[Nx*Ny,1])./mesh.cells.v;
gradField.fields.y = reshape(diff_fy',[Nx*Ny,1])./mesh.cells.v;
end

