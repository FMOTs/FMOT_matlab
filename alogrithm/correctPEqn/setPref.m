function PEqn = setPref(PEqn,refCell,refValue)
%为压力方程设置压力参考网格和参考值
%简介：
%函数重载：
%   PEqn = setPref(PEqn,mass)
%   PEqn = setPref(PEqn,mass,refCell,refValue)
%输入参数：
%   PEqn - 压力方程矩阵系统
%   mass - 质量源项
%   refCell - 参考压力网格编号，默认值 = 1
%   refValue - 参考压力值，默认值 = 0
%返回参数：
%   PEqn - 修正后压力方程矩阵系统
%   mass - 修正后质量源项
if nargin == 2
    refCell = 1;
    refValue = 0;
end
    PEqn.A(refCell, :) = 0;
    PEqn.A(refCell, refCell) = -1e16; %必须为负数，这样才能与矩阵对应
    PEqn.b(refCell) = PEqn.b(refCell) + refValue*PEqn.A(refCell, refCell);

end

