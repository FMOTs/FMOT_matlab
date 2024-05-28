function Ap = A(Eqn,alpha)
%提取离散矩阵主元值
%简介：
%函数重载:
%   Ap = A(Eqn)
%   Ap = A(Eqn,alpha)
%输入参数
%   Eqn - 物理场离散矩阵
%   alpha - 物理场矩阵松弛因子，默认值 = 1

%初始化默认值
if nargin == 1
    alpha = 1;
end
if strcmpi(Eqn.type,'scalarMatrix')
   Ap.x = diag(Eqn.A)./alpha; 
   Ap.type = 'scalarAp';
elseif strcmpi(Eqn.type,'vectorMatrix')
   Ap.x = diag(Eqn.A.x)./alpha;
   Ap.y = diag(Eqn.A.y)./alpha; 
   Ap.type = 'vectorAp';
else
    error('A():Eqn.type错误')
end

end

