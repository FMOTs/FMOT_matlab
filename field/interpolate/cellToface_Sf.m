function faceField = cellToface_Sf(mesh,field)
%根据边界条件修正结构网格(Cavity)边界面的值
%简介：
%重要！:这个函数计算的不是计算的fieldf,而是fieldf.*Sf
%重要！:这里面是默认mesh为结构网格数据体了！！！！
%重要！:这个功能与calculatephi重复了，后期要优化一下
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
%计算fieldf.*nf
    faceField.fields.x = faceField.fields.x .* mesh.faces.nf.x;
    faceField.fields.y = faceField.fields.y .* mesh.faces.nf.y;
%修正边界(必须在中间进行边界修正)
    faceField = conCorrcetBC_Sf(mesh,faceField,field);
%计算feildf(vector).*Sf(nf*|S|)
    faceField.fields.x = faceField.fields.x .* mesh.faces.areas.x;
    faceField.fields.y = faceField.fields.y .* mesh.faces.areas.y;

elseif contains(field.type,'Vector')
%初始化内存
    faceField = generatefield(mesh,fieldDimension.face,fieldType.vector);
    field_x = zeros(Ny,Nx+2);
    field_y = zeros(Ny+2,Nx);
    field_x(:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_y(2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
%计算面速度场
    faceField.fields.x = (field_x(:,1:end-1) + field_x(:,2:end))/2;
    faceField.fields.y = (field_y(1:end-1,:) + field_y(2:end,:))/2;
%计算fieldf.*nf
    faceField.fields.x = faceField.fields.x .* mesh.faces.nf.x;
    faceField.fields.y = faceField.fields.y .* mesh.faces.nf.y;
%修正边界(必须在中间进行边界修正)
    faceField = conCorrcetBC_Sf(mesh,faceField,field);
%计算feildf(vector).*Sf(nf*|S|)
    faceField.fields.x = faceField.fields.x .* mesh.faces.areas.x;
    faceField.fields.y = faceField.fields.y .* mesh.faces.areas.y;
else
    error('cellToface():field.type参数错误');
end

end

