function faceField = conCorrcetBC_Sf(mesh,faceField,field)
%���ݱ߽����������ṹ����(Cavity)�߽����ֵ
%��飺
%��Ҫ��������������ڱ߽���������Ǽ����fieldf,����fieldf.*Sf
%��������:
%   facefield = corrcetFaceFieldBC_Sf(facefield,field)
%�������
%   faceField - ��Ҫ�����߽���泡
%   field - ���ݱ߽�����������

global Nx Ny;
%���߽�������
    checkBC(field);
%��ȡ�߽�
    field.LBC = linearBC(mesh,field);  
%�����߽�
%�������������������ʵ��̫�ԣ�������Ĭ��field��volVectorField�ˣ�Ӧ������
%�����ж�һ��,��ΪvolScalarField��û��field.fields.y��
% (������һ�£���û����ȫ����)

    if strcmpi(field.type,'volScalarField')  
        REU.x = reshape(field.fields.x,[Nx,Ny])'; 
        BCVALUE_W = REU.x(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.x;
        BCVALUE_E = REU.x(:,end) * field.LBC.E.c1 + field.LBC.E.c2.x;
        BCVALUE_S = REU.x(1,:) * field.LBC.S.c1 + field.LBC.S.c2.x;
        BCVALUE_N = REU.x(end,:) * field.LBC.N.c1 + field.LBC.N.c2.x;
    elseif strcmpi(field.type,'volVectorField')
        %��Ϊ��fieldf.*Sf����W-Eֱ��.*U,S-Nֱ��.*V
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