function faceField = conCorrcetBC_vf(mesh,faceField,field)
%根据边界条件修正结构网格(Cavity)边界面的值
%简介：
%重要！：这个函数对于边界的修正计算的是fieldf
%函数重载:
%   facefield = corrcetFaceFieldBC_vf(facefield,field)
%输入参数
%   faceField - 需要修正边界的面场
%   field - 传递边界条件的物理场

global Nx Ny;
%检查边界完整性
    checkBC(field);
%提取边界
    field.LBC = linearBC(mesh,field);  
%修正边界
    if strcmpi(field.type,'volScalarField')  
        REU.x = reshape(field.fields.x,[Nx,Ny])'; 
        BCVALUE_W = REU.x(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.x;
        BCVALUE_E = REU.x(:,end) * field.LBC.E.c1 + field.LBC.E.c2.x;
        BCVALUE_S = REU.x(1,:) * field.LBC.S.c1 + field.LBC.S.c2.x;
        BCVALUE_N = REU.x(end,:) * field.LBC.N.c1 + field.LBC.N.c2.x;
        %修正边界面值
        faceField.fields.x(:,1) = BCVALUE_W;
        faceField.fields.x(:,end) = BCVALUE_E;
        faceField.fields.y(1,:) = BCVALUE_S;
        faceField.fields.y(end,:) = BCVALUE_N;
    elseif strcmpi(field.type,'volVectorField') 
        REU.x = reshape(field.fields.x,[Nx,Ny])';
        REU.y = reshape(field.fields.y,[Nx,Ny])'; 
        %x方向网格面
        BCVALUE_W.x = REU.x(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.x;
        BCVALUE_E.x = REU.x(:,end) * field.LBC.E.c1 + field.LBC.E.c2.x;
        BCVALUE_S.x = REU.x(1,:) * field.LBC.S.c1 + field.LBC.S.c2.x;
        BCVALUE_N.x = REU.x(end,:) * field.LBC.N.c1 + field.LBC.N.c2.x;
        %y方向网格面
        BCVALUE_W.y = REU.y(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.y;
        BCVALUE_E.y = REU.y(:,end) * field.LBC.E.c1 + field.LBC.E.c2.y;
        BCVALUE_S.y = REU.y(1,:) * field.LBC.S.c1 + field.LBC.S.c2.y;
        BCVALUE_N.y = REU.y(end,:) * field.LBC.N.c1 + field.LBC.N.c2.y;
        %修正边界面值
        %注意，x面只受到W-E边界面的影响
        faceField.fields.xx(:,1) = BCVALUE_W.x;
        faceField.fields.xx(:,end) = BCVALUE_E.x;
        faceField.fields.xy(1,:) = BCVALUE_S.y;
        faceField.fields.xy(end,:) = BCVALUE_N.y;
        %注意，y面只受到S-N边界面的影响
        faceField.fields.yx(:,1) = BCVALUE_W.x;
        faceField.fields.yx(:,end) = BCVALUE_E.x;
        faceField.fields.yy(1,:) = BCVALUE_S.y;
        faceField.fields.yy(end,:) = BCVALUE_N.y;
    end
end