function [mass,DAp,DApf,Uf] = PWIM(mesh,UEqn,U,P,RCType)
%Rhie-chow插值计算m_source
%   传入速度场和压力，通过Rhie-chow计算质量守恒
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


if nargin == 4
    RCType = 1;
end

%计算Ap/alpha(volVectorField),因为UEqn本身已经施加了松弛，不需要再次松弛
    Ap = A(UEqn);
%计算Vp/Ap(volVectorField)
    DAp = DA(mesh,UEqn); 
%计算(Vp/Ap)f(faceVectorField):(Vp*alphaU/Ap|p + Vp*alphaU/Ap|E)/2
    DApf = AToAf(DAp);
%计算Uf(faceVectorField)
    Uf = cellToface_vf(mesh,U);
%计算gradP(gradP)(volVectorField):0.5*(PE-PW)/2
    Pgrad_field = grad_fvc(mesh,P,gradScheme.Gauss,gradType.field);
%计算snGradPf(faceScalarField):(PE-PP)/dx
    PsnGrad = snGrad_fvc(mesh,P);
%计算(dP/dx|p + dP/dx|e)/2(faceScalarField)
    Pcorrect = correctP(mesh,Ap,Pgrad_field);
%计算R-C修正
    Uf = RCUf(mesh,U,Uf,RCType,DApf,PsnGrad,Pcorrect);



%计算质量源项
    mass = div_fvc(mesh, Uf);
end

