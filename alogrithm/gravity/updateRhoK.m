function rhok = updateRhoK(rhok,beta,Tref,T)
%更新bounssinesq假设浮力项
%简介：
%函数重载：
%   rhok = updateRhoK(rhok,beta,Tref,T)
%输入参数：
%   rhok - 原始浮力项
%   beta - 流体热膨胀系数
%   Tref - 流体参考温度
%   T - 新的温度场
%返回参数：
%   gh (volScalarField) - 不同水深受到的重力

rhok.fields.x = 1 - beta*(Tref - T.fields.x);

end

