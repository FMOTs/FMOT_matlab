function Ab = grad_fvc(mesh,field,gradScheme,gradType)
%梯度项生成
%简介：
%函数重载：
%   Ab = grac_fvc(mesh,field,gradScheme)
%   Ab = grac_fvc(mesh,field,gradScheme,gradType)
%输入参数：
%   mesh - 网格数据结构体
%   field - 计算物理场
%   gradScheme - 梯度项离散格式
%   gradType - 计算梯度的类型，分成计算volField和Su两种,
%              默认gradType = volField
%返回参数：
%   Ab(volVectorField) - 函数重载1返回gradP，单纯计算物理场梯度
%   Ab(volVectorField) - 函数重载2返回gradP * Vp(网格体积)，N-S方程需要

if nargin == 3
    gradType = 1;
end

%根据离散格式计算梯度
if gradScheme == 1
    Ab = gaussGrad(mesh,field,gradType);
else
    error('grac_fvc():gradScheme参数输入错误');
end

end


