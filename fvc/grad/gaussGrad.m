function gradField = gaussGrad(mesh,field,gradType)
%高斯定理计算梯度
%简介：
%   目前只支持计算标量的梯度
global Nx Ny;

if gradType == 1
    gradField = calcualteGrad_field(mesh,field);
elseif gradType == 2
    gradField = calcualteGrad_Su(mesh,field);
else
    error('gaussGrad():gradType输入错误');
end

function gradField = calcualteGrad_field(mesh,field)
%计算物理场梯度
    if contains(field.type,'Scalar')
        %初始化内存
        gradField = generatefield(mesh,fieldDimension.vol,fieldType.vector);
        field_f = cellToface_Sf(mesh,field);
        diff_fx = (field_f.fields.x(:,2:end)-...
                  field_f.fields.x(:,1:end-1));
        diff_fy = (field_f.fields.y(2:end,:)-...
                  field_f.fields.y(1:end-1,:));
        gradField.fields.x = reshape(diff_fx',[Nx*Ny,1])./mesh.cells.v;
        gradField.fields.y = reshape(diff_fy',[Nx*Ny,1])./mesh.cells.v;
    else
        error('grad_fvc():gaussGrad():field.type错误，目前仅支持标量场');
    end
end

function gradField = calcualteGrad_Su(mesh,field)
%计算物理场梯度的体积分(N-S方程压力梯度源项)
    if contains(field.type,'Scalar')
        %初始化内存
        gradField = generatefield(mesh,fieldDimension.vol,fieldType.vector);
        field_f = cellToface_Sf(mesh,field);
        diff_fx = (field_f.fields.x(:,2:end)-...
                  field_f.fields.x(:,1:end-1));
        diff_fy = (field_f.fields.y(2:end,:)-...
                  field_f.fields.y(1:end-1,:));
        gradField.A.x = sparse(Nx*Ny,Nx*Ny);
        gradField.A.y = sparse(Nx*Ny,Nx*Ny);
        gradField.A.z = sparse(Nx*Ny,Nx*Ny);
        gradField.b.x = reshape(diff_fx',[Nx*Ny,1]);
        gradField.b.y = reshape(diff_fy',[Nx*Ny,1]);
        gradField.b.z = sparse(Nx*Ny,1);
        gradField.type = 'fvc::grad_su::Gauss';
        gradField = rmfield(gradField,'fields');
    else
        error('grad_fvc():gaussGrad():field.type错误，目前仅支持标量场');
    end
end
end

