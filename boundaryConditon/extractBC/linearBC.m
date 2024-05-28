function LBC = linearBC(mesh,field,varargin)
%将边界条件进行线性化处理
%简介：
%函数重载:
%   mesh = ConstuctMesh(cellDim);
%   mesh = ConstuctMesh(cellDim, physDim);
%输入参数
%   faceField - 需要修正边界的面场
%   field - 传递边界条件的物理场

%检查边界完整性
checkBC(field);
%处理W边界
    LBC.W = extractBC(field.BC.W);
%处理E边界
    LBC.E = extractBC(field.BC.E);
%处理S边界
    LBC.S = extractBC(field.BC.S);
%处理N边界
    LBC.N = extractBC(field.BC.N);
%线性化
    if strcmpi(field.type,'volScalarField')
       LBC = linearScalarCalculate(mesh,LBC);
    elseif strcmpi(field.type,'volVectorField')
       LBC = linearVectorCalculate(mesh,field,LBC);
    else
        error('LinearBC()函数传入的物理场类型错误');
    end
       
function BCPara = extractBC(BC)
%根据边界条件提取对应的a,b
    if strcmpi(BC.type,'Dirichlet')
        BCPara.a = 1;
        BCPara.b = 0;
        BCPara.c = BC.value;
    elseif strcmpi(BC.type,'Neumann')
        BCPara.a = 0;
        BCPara.b = 1;
        BCPara.c = BC.value;
    else
       error('边界条件信息提取失败，目前仅编写Dirichlet和Neumann');   
    end
end

function LBC = linearScalarCalculate(mesh,LBC)
%根据a,b,c线性化边界
%计算边界网格的dx和dy
    endx = mesh.points.x(end);
    endy = mesh.points.y(end);   
    bcdx_b = (mesh.cells.cx(1) - 0);%W
    bcdx_e = (endx - mesh.cells.cx(end));%E
    bcdy_b = (mesh.cells.cy(1) - 0);%S
    bcdy_e = (endy - mesh.cells.cy(end));%N
%处理W
    LBC.W = calculateSC(LBC.W,bcdx_b);
%处理E
    LBC.E = calculateSC(LBC.E,bcdx_e);
%处理S
    LBC.S = calculateSC(LBC.S,bcdy_b);
%处理N
    LBC.N = calculateSC(LBC.N,bcdy_e);
end

function BCC = calculateSC(BCC,d)
%计算c1和c2    
    BCC.c1 = ((BCC.b/d))/(BCC.a + (BCC.b/d));
    BCC.c2.x= BCC.c/(BCC.a + (BCC.b/d));
end

function LBC = linearVectorCalculate(mesh,field,LBC)
%根据a,b,c线性化边界
%计算边界网格的dx和dy
    endx = mesh.points.x(end);
    endy = mesh.points.y(end);   
    bcdx_b = (mesh.cells.cx(1) - 0);%W
    bcdx_e = (endx - mesh.cells.cx(end));%E
    bcdy_b = (mesh.cells.cy(1) - 0);%S
    bcdy_e = (endy - mesh.cells.cy(end));%N
%处理W
    if strcmpi(field.BC.W.type,'Dirichlet')
        LBC.W = calculateVC_D(LBC.W,bcdx_b);
    elseif strcmpi(field.BC.W.type,'Neumann')
        LBC.W = calculateVC_N(LBC.W,bcdx_b);
    end
%处理E
    if strcmpi(field.BC.E.type,'Dirichlet')
        LBC.E = calculateVC_D(LBC.E,bcdx_e);
    elseif strcmpi(field.BC.E.type,'Neumann')
        LBC.E = calculateVC_N(LBC.E,bcdx_e);
    end
%处理S
    if strcmpi(field.BC.S.type,'Dirichlet')
        LBC.S = calculateVC_D(LBC.S,bcdy_b);
    elseif strcmpi(field.BC.S.type,'Neumann')
        LBC.S = calculateVC_N(LBC.S,bcdy_b);
    end
%处理N
    if strcmpi(field.BC.N.type,'Dirichlet')
        LBC.N = calculateVC_D(LBC.N,bcdy_e);
    elseif strcmpi(field.BC.N.type,'Neumann')
        LBC.N = calculateVC_N(LBC.N,bcdy_e);
    end
end

function BCC = calculateVC_D(BCC,d)
%计算vectorfield的第一类边界c1和c2
%检测c是否输入维度正确
    if numel(BCC.c)~=3 
        error('linearBC():volVectorField第一类边界条件输入值维度错误');
    end
    if ~isnumeric(BCC.c)
        error('linearBC():volVectorField第一类边界条件只能输入数字');
    end
    BCC.c1 = (BCC.b/d)/(BCC.a + (BCC.b/d));
    BCC.c2.x = BCC.c(1)/(BCC.a + (BCC.b/d));
    BCC.c2.y = BCC.c(2)/(BCC.a + (BCC.b/d));
    BCC.c2.z = BCC.c(3)/(BCC.a + (BCC.b/d));
end
function BCC = calculateVC_N(BCC,d)
%计算vectorfield的第二类边界c1和c2    
    BCC.c1 = ((BCC.b/d))/(BCC.a + (BCC.b/d));
    BCC.c2.x = BCC.c/(BCC.a + (BCC.b/d));
    BCC.c2.y = BCC.c/(BCC.a + (BCC.b/d));
    BCC.c2.y = BCC.c/(BCC.a + (BCC.b/d));
end
end

