function field = generatefield(mesh,fieldDimension,fieldType)
%生成物理场数据结构体
%简介：
%输入参数
%   mesh - 网格数据结构体
%   fieldDimension - 物理场维度，包含vol、face和point三种，
%   fieldType -  物理场类型，包含scalar、vector和tensor三种，
%返回参数
%   field - 物理场数据结构体
%          包含变量：
%               - field.fields(物理场)
%               - field.type(物理场类型)
global Nx Ny;
%先确定场类型
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
        error('generatefield():fieldDimension错误');
end
ftype = 'Scalar';
if fieldType > 1
    switch fieldType
        case 2
            ftype = 'Vector';
        otherwise
        error('generatefield():fieldType错误');
    end
end
%根据最终形成的场类型,对应生成场数据结构体
field.type = strcat(fdim,ftype,'Field');

if strcmpi(field.type,'volScalarField')
    field = volScalarField(field);
elseif strcmpi(field.type,'volVectorField')
    field = volVectorField(field);
elseif strcmpi(field.type,'confaceScalarField')
    field = confaceScalarField(field);
elseif strcmpi(field.type,'unconfaceScalarField')
    field = unconfaceScalarField(mesh,field);
elseif strcmpi(field.type,'confaceVectorField')
    field = confaceVectorField(field);
elseif strcmpi(field.type,'unconfaceVectorField')
    field = unconfaceVectorField(mesh,field);
else
    error('generatefield():物理场生成失败');
end

%对于faceVectorField要二次重新生成物理场，
%因为对于结构网格每一个面，他都有(x,y,z)三个方向的分量
function field = volScalarField(field)
    field.fields.x = zeros(Nx*Ny,1);
end

function field = volVectorField(field)
    field.fields.x = zeros(Nx*Ny,1);
    field.fields.y = zeros(Nx*Ny,1);
    field.fields.z = zeros(Nx*Ny,1);
end

function field = confaceScalarField(field)
%construct的面特殊处理 
    field.fields.x = zeros(Ny,Nx+1);
    field.fields.y = zeros(Ny+1,Nx); 
end

function field = unconfaceScalarField(field)
%construct的面特殊处理 
    field.fields.x = zeros(mesh.faces.number,1);
end

function field = confaceVectorField(field)
%construct的面特殊处理 
%xx代表x方向的网格面储存的速度u
%xy代表x方向的网格面储存的速度v
%以此类推......
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


