function faceField = conCorrcetBC_Sf(mesh,faceField,field)
%根据边界条件修正结构网格(Cavity)边界面的值
%简介：
%重要！：这个函数对于边界的修正不是计算的fieldf,而是fieldf.*Sf
%函数重载:
%   facefield = corrcetFaceFieldBC_Sf(facefield,field)
%输入参数
%   faceField - 需要修正边界的面场
%   field - 传递边界条件的物理场

global Nx Ny;
%检查边界完整性
    checkBC(field);
%提取边界
    field.LBC = linearBC(mesh,field);  
%修正边界
%！！！！！这个函数其实不太对，这里面默认field是volVectorField了，应该修正
%并且判断一下,因为volScalarField是没有field.fields.y的
% (修正了一下，但没有完全测试)

    if strcmpi(field.type,'volScalarField')  
        REU.x = reshape(field.fields.x,[Nx,Ny])'; 
        BCVALUE_W = REU.x(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.x;
        BCVALUE_E = REU.x(:,end) * field.LBC.E.c1 + field.LBC.E.c2.x;
        BCVALUE_S = REU.x(1,:) * field.LBC.S.c1 + field.LBC.S.c2.x;
        BCVALUE_N = REU.x(end,:) * field.LBC.N.c1 + field.LBC.N.c2.x;
    elseif strcmpi(field.type,'volVectorField')
        %因为是fieldf.*Sf所以W-E直接.*U,S-N直接.*V
        REU.x = reshape(field.fields.x,[Nx,Ny])';
        REU.y = reshape(field.fields.y,[Nx,Ny])'; 
        BCVALUE_W = REU.x(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.x;
        BCVALUE_E = REU.x(:,end) * field.LBC.E.c1 + field.LBC.E.c2.x;
        BCVALUE_S = REU.y(1,:) * field.LBC.S.c1 + field.LBC.S.c2.y;
        BCVALUE_N = REU.y(end,:) * field.LBC.N.c1 + field.LBC.N.c2.y;
    end
    faceField.fields.x(:,1) = BCVALUE_W;
    faceField.fields.x(:,end) = BCVALUE_E;
    faceField.fields.y(1,:) = BCVALUE_S;
    faceField.fields.y(end,:) = BCVALUE_N;
end