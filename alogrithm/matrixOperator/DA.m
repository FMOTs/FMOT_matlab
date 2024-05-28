function DAp = DA(mesh,Eqn,alpha)
%计算Vp./Ap
%简介：
%函数重载:
%   DAp = DA(mesh,Eqn)
%   DAp = DA(mesh,Eqn,alpha)
%输入参数
%   mesh - 网格数据结构体
%   Eqn - 物理场离散矩阵
%   alpha - 物理场矩阵松弛因子，默认值 = 1

%初始化默认值
if nargin == 2
    alpha = 1;
end
if strcmpi(Eqn.type,'scalarMatrix')
   DAp.x = mesh.cells.v ./ diag(Eqn.A) ./alpha; 
   DAp.type = 'scalarDAp';
elseif strcmpi(Eqn.type,'vectorMatrix')
   DAp.x = mesh.cells.v ./diag(Eqn.A.x)./alpha;
   DAp.y = mesh.cells.v ./diag(Eqn.A.y)./alpha; 
   DAp.type = 'vectorDAp';
else
    error('DA():Eqn.type错误')
end

end

