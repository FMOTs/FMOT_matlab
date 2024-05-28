function field = generatefield(mesh,fieldDimension,fieldType)
%�����������ݽṹ��
%��飺
%�������
%   mesh - �������ݽṹ��
%   fieldDimension - ����ά�ȣ�����vol��face��point���֣�
%   fieldType -  �������ͣ�����scalar��vector��tensor���֣�
%���ز���
%   field - �������ݽṹ��
%          ����������
%               - field.fields(����)
%               - field.type(��������)
global Nx Ny;
%��ȷ��������
switch fieldDimension
    case 1
        fdim = 'vol';
    case 2
        if strcmpi(mesh.type,'construct')                              
            fdim = 'conface';
        elseif strcmpi(mesh.type,'unconstruct')
            fdim = 'unconface';
        end
        
    otherwise
        error('generatefield():fieldDimension����');
end
ftype = 'Scalar';
if fieldType > 1
    switch fieldType
        case 2
            ftype = 'Vector';
        otherwise
        error('generatefield():fieldType����');
    end
end
%���������γɵĳ�����,��Ӧ���ɳ����ݽṹ��
field.type = strcat(fdim,ftype,'Field');

if strcmpi(field.type,'volScalarField')
    field = volScalarField(field);
elseif strcmpi(field.type,'volVectorField')
    field = volVectorField(field);
elseif strcmpi(field.type,'confaceScalarField')
    field = confaceScalarField(field);
elseif strcmpi(field.type,'unconfaceScalarField')
    field = unconfaceVectorField(mesh,field);
elseif strcmpi(field.type,'confaceVectorField')
    field = confaceVectorField(field);
elseif strcmpi(field.type,'unconfaceVectorField')
    field = unconfaceVectorField(mesh,field);
else
    error('generatefield():��������ʧ��');
end

%����faceVectorFieldҪ������������������
%��Ϊ���ڽṹ����ÿһ���棬������(x,y,z)��������ķ���
function field = volScalarField(field)
    field.fields.x = zeros(Nx*Ny,1);
end

function field = volVectorField(field)
    field.fields.x = zeros(Nx*Ny,1);
    field.fields.y = zeros(Nx*Ny,1);
    field.fields.z = zeros(Nx*Ny,1);
end

function field = confaceScalarField(field)
%construct�������⴦�� 
    field.fields.x = zeros(Ny,Nx+1);
    field.fields.y = zeros(Ny+1,Nx); 
end

function field = unconfaceScalarField(field)
%construct�������⴦�� 
    field.fields.x = zeros(mesh.faces.number,1);
end

function field = confaceVectorField(field)
%construct�������⴦�� 
%xx����x����������洢����ٶ�u
%xy����x����������洢����ٶ�v
%�Դ�����......
    cfields.xx = zeros(Ny,Nx+1);
    cfields.xy = zeros(Ny+1,Nx); 
    cfields.xz = []; 
    cfields.yx = zeros(Ny,Nx+1);
    cfields.yy = zeros(Ny+1,Nx); 
    cfields.yz = []; 
    cfields.zx = []; 
    cfields.zy = []; 
    cfields.zz = []; 
    field.fields = cfields;
end

function field = unconfaceVectorField(mesh,field)
    field.fields.x = zeros(mesh.faces.number,1);
    field.fields.y = zeros(mesh.faces.number,1);
    field.fields.z = zeros(mesh.faces.number,1);
end

end


