function [solve,field] = matrixSystem(field,operator,sign,varargin)
%组装物理场包含的所有算子
%注意！！！b的松弛因为没有额外的体积力，因此直接松弛了，后面要修正！！
%简介：
%函数重载：
%   solve = matrixSystem(operator)
%   solve = matrixSystem(operator,isSolve)
%   solve = matrixSystem(operator,isSolve,alpha)
%输入参数：
%   field - 代求物理场
%   operator - 代求物理场的离散算子数组
%              例：[ddt_F,div_F,lap_F]
%   sign - 代求物理场的离散算子符号数组
%              例：['+','+','-']
%   isSolve - 控制是否对矩阵系统进行求解
%             默认值 = 0(不求解) 
%   alpha - 矩阵松弛因子
%             默认值 = 1
%--------------------------------------------------------------------------
%   operator和sign必须是一一对应的，sign代表对应离散算子在公式中的加减
%           [ddt_F,div_F,lap_F],['+','+','-']
%           = ddt_F + div_F - lap_F
%--------------------------------------------------------------------------
%返回参数：
%   solve - 矩阵系统
%           包含变量：
%               - solve.A(矩阵)：field为scalar时为solve.A，
%                               vector时包含A.x、A.y和A.z分量
%               - solve.b(源项)：field为scalar时为solve.b，
%                                vector时包含b.x、b.y和b.z分量
%               - solve.type(矩阵系统类型)
%   solve - 函数重载1返回A和b
%   solve - 函数重载2返回A、b和field
%   solve - 函数重载3返回松弛后的A、b和field
%   field - 求解后的物理场，matlab语法需求


global Nx Ny;
warning('off');
%初始化
doSolve = 0;
alpha = 1;

if nargin == 4 && isnumeric(varargin{1})
    doSolve = varargin{1};
end

if nargin == 5 && isnumeric(varargin{2})
    doSolve = varargin{1};
    alpha = varargin{2};
end

%判断物理场类型(矩阵系统只能传入体场)
if strcmpi(field.type,'volScalarField')
    solve = generateScalarM(operator,sign);
    solve.type = 'scalarMatrix';
    if doSolve
       %储存旧时间步物理场
       solve.oldFields = field.fields.x;
       %计算矩阵
       % 直接法
       field.fields.x = solve.A\solve.b;
       %双稳定共轭梯度
       % field.fields.x = bicgstab(solve.A,solve.b);
    end
elseif strcmpi(field.type,'volVectorField')
    solve = generateVectorM(operator,sign);
    solve.type = 'vectorMatrix';
    if doSolve
       %储存旧时间步物理场
       solve.oldFields.x = field.fields.x;
       solve.oldFields.y = field.fields.y;
       solve.oldFields.z = field.fields.z;
       %计算矩阵
       % field.fields.x = solve.A.x\solve.b.x;
       % field.fields.y = solve.A.x\solve.b.y;
       % field.fields.z = solve.A.x\solve.b.z;
       %双稳定共轭梯度
       field.fields.x = bicgstab(solve.A.x,solve.b.x);
       field.fields.y = bicgstab(solve.A.y,solve.b.y);
       % field.fields.z = bicgstab(solve.A,solve.b);
    end
else
    error('矩阵组装失败，传入物理场类型错误')
end


function solve = generateScalarM(operator,sign)
%组装标量场(Scalar)的矩阵系统:A,b
    %初始化内存
    dim = Nx*Ny;
    solve.A = sparse(dim,dim);
    solve.b = sparse(dim,1);
    %组装矩阵
    for i = 1:numel(operator)
        if sign(i) == '+'
            solve.A = solve.A + operator(i).A;
            solve.b = solve.b + operator(i).b;
        elseif sign(i) == '-'
            solve.A = solve.A - operator(i).A;
            solve.b = solve.b - operator(i).b;
        else
            error('matrixSystem()传入参数sign错误');
        end
    end
    %施加松弛
    if alpha ~= 1
        %提取主元
        diagA_x = diag(solve.A.x);
        p = sparse(Nx*Ny,Nx*Ny,pi);
        I = eye(Nx*Ny,'like',p);
        solve.A.x(I == 1) = solve.A.x(I == 1)./alpha;
        solve.b = solve.b + ((1-alpha)/alpha) .*diagA_x .* field.fields.x;
    end
end

function solve = generateVectorM(operator,sign)
%组装向量场(Vector)的矩阵系统A.x,A.y,A.z,b.x,b.y.b.z
    %初始化内存
    dim = Nx*Ny;
    solve.A.x = sparse(dim,dim);
    solve.A.y = sparse(dim,dim);
    solve.A.z = sparse(dim,dim);
    solve.b.x = sparse(dim,1);
    solve.b.y = sparse(dim,1);
    solve.b.z = sparse(dim,1);
    %组装矩阵
    for i = 1:numel(operator)
        if sign(i) == '+'
            solve.A.x = solve.A.x + operator(i).A.x;
            solve.A.y = solve.A.y + operator(i).A.y;
            % solve.A.z = solve.A.z + operator(i).A.z;
            solve.b.x = solve.b.x + operator(i).b.x;
            solve.b.y = solve.b.y + operator(i).b.y;
            % solve.b.z = solve.b.z + operator(i).b.z;
        elseif sign(i) == '-'
            solve.A.x = solve.A.x - operator(i).A.x;
            solve.A.y = solve.A.y - operator(i).A.y;
            % solve.A.z = solve.A.z - operator(i).A.z;
            solve.b.x = solve.b.x - operator(i).b.x;
            solve.b.y = solve.b.y - operator(i).b.y;
            % solve.b.z = solve.b.z - operator(i).b.z;
        else
            error('matrixSystem()传入参数sign错误');
        end
    end

    %施加松弛
    if alpha ~= 1
        %提取主元
        diagA_x = diag(solve.A.x);
        diagA_y = diag(solve.A.y);
        %施加松弛
        p = sparse(Nx*Ny,Nx*Ny,pi);
        I = eye(Nx*Ny,'like',p);
        solve.A.x(I == 1) = solve.A.x(I == 1)./alpha;
        solve.A.y(I == 1) = solve.A.y(I == 1)./alpha;
        solve.b.x = solve.b.x + ((1-alpha)/alpha) .*diagA_x .*field.fields.x;
        solve.b.y = solve.b.y + ((1-alpha)/alpha) .*diagA_y .*field.fields.y;
    end

end
end

