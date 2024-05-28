function LBC = linearBC(mesh,field,varargin)
%���߽������������Ի�����
%��飺
%��������:
%   mesh = ConstuctMesh(cellDim);
%   mesh = ConstuctMesh(cellDim, physDim);
%�������
%   faceField - ��Ҫ�����߽���泡
%   field - ���ݱ߽�����������

%���߽�������
checkBC(field);
%����W�߽�
    LBC.W = extractBC(field.BC.W);
%����E�߽�
    LBC.E = extractBC(field.BC.E);
%����S�߽�
    LBC.S = extractBC(field.BC.S);
%����N�߽�
    LBC.N = extractBC(field.BC.N);
%���Ի�
    if strcmpi(field.type,'volScalarField')
       LBC = linearScalarCalculate(mesh,LBC);
    elseif strcmpi(field.type,'volVectorField')
       LBC = linearVectorCalculate(mesh,field,LBC);
    else
        error('LinearBC()����������������ʹ���');
    end
       
function BCPara = extractBC(BC)
%���ݱ߽�������ȡ��Ӧ��a,b
    if strcmpi(BC.type,'Dirichlet')
        BCPara.a = 1;
        BCPara.b = 0;
        BCPara.c = BC.value;
    elseif strcmpi(BC.type,'Neumann')
        BCPara.a = 0;
        BCPara.b = 1;
        BCPara.c = BC.value;
    else
       error('�߽�������Ϣ��ȡʧ�ܣ�Ŀǰ����дDirichlet��Neumann');   
    end
end

function LBC = linearScalarCalculate(mesh,LBC)
%����a,b,c���Ի��߽�
%����߽������dx��dy
    endx = mesh.points.x(end);
    endy = mesh.points.y(end);   
    bcdx_b = (mesh.cells.cx(1) - 0);%W
    bcdx_e = (endx - mesh.cells.cx(end));%E
    bcdy_b = (mesh.cells.cy(1) - 0);%S
    bcdy_e = (endy - mesh.cells.cy(end));%N
%����W
    LBC.W = calculateSC(LBC.W,bcdx_b);
%����E
    LBC.E = calculateSC(LBC.E,bcdx_e);
%����S
    LBC.S = calculateSC(LBC.S,bcdy_b);
%����N
    LBC.N = calculateSC(LBC.N,bcdy_e);
end

function BCC = calculateSC(BCC,d)
%����c1��c2    
    BCC.c1 = ((BCC.b/d))/(BCC.a + (BCC.b/d));
    BCC.c2.x= BCC.c/(BCC.a + (BCC.b/d));
end

function LBC = linearVectorCalculate(mesh,field,LBC)
%����a,b,c���Ի��߽�
%����߽������dx��dy
    endx = mesh.points.x(end);
    endy = mesh.points.y(end);   
    bcdx_b = (mesh.cells.cx(1) - 0);%W
    bcdx_e = (endx - mesh.cells.cx(end));%E
    bcdy_b = (mesh.cells.cy(1) - 0);%S
    bcdy_e = (endy - mesh.cells.cy(end));%N
%����W
    if strcmpi(field.BC.W.type,'Dirichlet')
        LBC.W = calculateVC_D(LBC.W,bcdx_b);
    elseif strcmpi(field.BC.W.type,'Neumann')
        LBC.W = calculateVC_N(LBC.W,bcdx_b);
    end
%����E
    if strcmpi(field.BC.E.type,'Dirichlet')
        LBC.E = calculateVC_D(LBC.E,bcdx_e);
    elseif strcmpi(field.BC.E.type,'Neumann')
        LBC.E = calculateVC_N(LBC.E,bcdx_e);
    end
%����S
    if strcmpi(field.BC.S.type,'Dirichlet')
        LBC.S = calculateVC_D(LBC.S,bcdy_b);
    elseif strcmpi(field.BC.S.type,'Neumann')
        LBC.S = calculateVC_N(LBC.S,bcdy_b);
    end
%����N
    if strcmpi(field.BC.N.type,'Dirichlet')
        LBC.N = calculateVC_D(LBC.N,bcdy_e);
    elseif strcmpi(field.BC.N.type,'Neumann')
        LBC.N = calculateVC_N(LBC.N,bcdy_e);
    end
end

function BCC = calculateVC_D(BCC,d)
%����vectorfield�ĵ�һ��߽�c1��c2
%���c�Ƿ�����ά����ȷ
    if numel(BCC.c)~=3 
        error('linearBC():volVectorField��һ��߽���������ֵά�ȴ���');
    end
    if ~isnumeric(BCC.c)
        error('linearBC():volVectorField��һ��߽�����ֻ����������');
    end
    BCC.c1 = (BCC.b/d)/(BCC.a + (BCC.b/d));
    BCC.c2.x = BCC.c(1)/(BCC.a + (BCC.b/d));
    BCC.c2.y = BCC.c(2)/(BCC.a + (BCC.b/d));
    BCC.c2.z = BCC.c(3)/(BCC.a + (BCC.b/d));
end
function BCC = calculateVC_N(BCC,d)
%����vectorfield�ĵڶ���߽�c1��c2    
    BCC.c1 = ((BCC.b/d))/(BCC.a + (BCC.b/d));
    BCC.c2.x = BCC.c/(BCC.a + (BCC.b/d));
    BCC.c2.y = BCC.c/(BCC.a + (BCC.b/d));
    BCC.c2.y = BCC.c/(BCC.a + (BCC.b/d));
end
end

