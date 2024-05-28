function [massPrime,PEqn] = PRIME(mesh,DAp,UEqn,P,PEqn,Pgrad_Su)
%PRIME(PRessure Implicit Momentum Explicit)
%   用来多次修正压力场和速度场
%简介：
%函数重载：
%   mass = PWIM(mesh,UEqn,U,P)
%   mass = PWIM(mesh,UEqn,U,P,alphaU)
%输入参数：
%   mesh - 结构网格数据体
%   UEqn - 速度方程离散矩阵
%   U - 速度物理场
%   P - 压力物理场
%   alphaU - 速度场矩阵松弛因子
%             默认值 = 1
%返回参数：
%   mass(volScalarField) - 函数重载1返回不可压质量源项
%   DApf(faceScalarField) - 函数重载1返回Ap_{U}f.*nf
%   mass(volScalarField) - 函数重载2返回不可压质量源项(速度场松弛)
%   DApf(faceScalarField) - 函数重载2返回Ap_{U,relax}f.*nf

global Nx Ny;
%初始化场松弛
if nargin == 5
    falphaU = 1;
end

%根据P'计算U'
Pgrad = gradPC(mesh,P);
UPrime = generatefield(mesh,fieldDimension.vol,fieldType.vector);
UPrime.fields.x = - DAp.x .* Pgrad.fields.x;
UPrime.fields.y = - DAp.y .* Pgrad.fields.y;

%计算相邻网格的修正影响，UEqn的构建方式要修改一下，把压力源项分离出去
Ap1 = A1(UEqn);
Hby= sHbyA(Ap1,UEqn,UPrime);
%计算修正源项
phiHbyA = flux(mesh,Hby);
%修正边界面的massFLux
phiHbyA = conCorrectCPBC(phiHbyA);
%计算修正质量源项
massPrime = phiHbyToMass(phiHbyA);
massPrime.type = 'fvc::div::gauss';
% %添加massoldFields
% massPrime.oldFields = zeros(Nx*Ny,1);
end

