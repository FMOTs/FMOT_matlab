function faceField = cellToface_vf(mesh,field)
%根据体场生成面场,只是单纯的插值
%重要！这里面是默认mesh为结构网格数据体了！！！！
% 简介：
%函数重载:
%   faceField = cellToface_vf(mesh,field)
%输入参数
%   mesh - 网格数据结构体
%   field - 物理场
%返回参数
%   faceField(faceScalarField) - 返回volField的linear interpolation


global Nx Ny;
if contains(field.type,'Scalar')
%初始化内存
    faceField = generatefield(mesh,fieldDimension.face,fieldType.scalar);
    field_x = zeros(Ny,Nx+2);
    field_y  = zeros(Ny+2,Nx);
    field_x (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_y (2:end-1,:) = reshape(field.fields.x,[Nx,Ny])';
%计算面物理场
    faceField.fields.x = (field_x(:,1:end-1) + field_x(:,2:end))/2;
    faceField.fields.y = (field_y(1:end-1,:) + field_y(2:end,:))/2;
%修正边界(必须在中间进行边界修正)
    faceField = conCorrcetBC_vf(mesh,faceField,field);

elseif contains(field.type,'Vector')
%初始化内存
    faceField = generatefield(mesh,fieldDimension.face,fieldType.vector);
    %xx代表速度U的X方向面,xy代表速度U的Y方向面
    field_xx = zeros(Ny,Nx+2);
    field_xy = zeros(Ny+2,Nx);
    %yx代表速度V的X方向面,yy代表速度V的Y方向面
    field_yx  = zeros(Ny,Nx+2);
    field_yy  = zeros(Ny+2,Nx);

    field_xx (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_xy (2:end-1,:) = reshape(field.fields.x,[Nx,Ny])';
    field_yx (:,2:end-1) = reshape(field.fields.y,[Nx,Ny])';
    field_yy (2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
    % field_xx (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    % field_xy (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    % field_yx (2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
    % field_yy (2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
%计算面速度场
    %xx-xy维度要一致，yx-yy维度要一致
    faceField.fields.xx = (field_xx(:,1:end-1) + field_xx(:,2:end))/2;
    faceField.fields.xy = (field_xy(1:end-1,:) + field_xy(2:end,:))/2;
    faceField.fields.yx = (field_yx(:,1:end-1) + field_yx(:,2:end))/2;
    faceField.fields.yy = (field_yy(1:end-1,:) + field_yy(2:end,:))/2;
%修正边界(必须在中间进行边界修正)   
    faceField = conCorrcetBC_vf(mesh,faceField,field);
else
    error('cellToface():field.type参数错误');
end

end

