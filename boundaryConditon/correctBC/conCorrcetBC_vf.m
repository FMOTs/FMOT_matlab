function faceField = conCorrcetBC_vf(mesh,faceField,field)
%���ݱ߽����������ṹ����(Cavity)�߽����ֵ
%��飺
%��Ҫ��������������ڱ߽�������������fieldf
%��������:
%   facefield = corrcetFaceFieldBC_vf(facefield,field)
%�������
%   faceField - ��Ҫ�����߽���泡
%   field - ���ݱ߽�����������

global Nx Ny;
%���߽�������
    checkBC(field);
%��ȡ�߽�
    field.LBC = linearBC(mesh,field);  
%�����߽�
    if strcmpi(field.type,'volScalarField')  
        REU.x = reshape(field.fields.x,[Nx,Ny])'; 
        BCVALUE_W = REU.x(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.x;
        BCVALUE_E = REU.x(:,end) * field.LBC.E.c1 + field.LBC.E.c2.x;
        BCVALUE_S = REU.x(1,:) * field.LBC.S.c1 + field.LBC.S.c2.x;
        BCVALUE_N = REU.x(end,:) * field.LBC.N.c1 + field.LBC.N.c2.x;
        %�����߽���ֵ
        faceField.fields.x(:,1) = BCVALUE_W;
        faceField.fields.x(:,end) = BCVALUE_E;
        faceField.fields.y(1,:) = BCVALUE_S;
        faceField.fields.y(end,:) = BCVALUE_N;
    elseif strcmpi(field.type,'volVectorField') 
        REU.x = reshape(field.fields.x,[Nx,Ny])';
        REU.y = reshape(field.fields.y,[Nx,Ny])'; 
        %x����������
        BCVALUE_W.x = REU.x(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.x;
        BCVALUE_E.x = REU.x(:,end) * field.LBC.E.c1 + field.LBC.E.c2.x;
        BCVALUE_S.x = REU.x(1,:) * field.LBC.S.c1 + field.LBC.S.c2.x;
        BCVALUE_N.x = REU.x(end,:) * field.LBC.N.c1 + field.LBC.N.c2.x;
        %y����������
        BCVALUE_W.y = REU.y(:,1) .* field.LBC.W.c1 + field.LBC.W.c2.y;
        BCVALUE_E.y = REU.y(:,end) * field.LBC.E.c1 + field.LBC.E.c2.y;
        BCVALUE_S.y = REU.y(1,:) * field.LBC.S.c1 + field.LBC.S.c2.y;
        BCVALUE_N.y = REU.y(end,:) * field.LBC.N.c1 + field.LBC.N.c2.y;
        %�����߽���ֵ
        %ע�⣬x��ֻ�ܵ�W-E�߽����Ӱ��
        faceField.fields.xx(:,1) = BCVALUE_W.x;
        faceField.fields.xx(:,end) = BCVALUE_E.x;
        faceField.fields.xy(1,:) = BCVALUE_S.y;
        faceField.fields.xy(end,:) = BCVALUE_N.y;
        %ע�⣬y��ֻ�ܵ�S-N�߽����Ӱ��
        faceField.fields.yx(:,1) = BCVALUE_W.x;
        faceField.fields.yx(:,end) = BCVALUE_E.x;
        faceField.fields.yy(1,:) = BCVALUE_S.y;
        faceField.fields.yy(end,:) = BCVALUE_N.y;
    end
end