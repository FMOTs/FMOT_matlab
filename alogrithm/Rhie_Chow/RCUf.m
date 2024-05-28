function Uf = RCUf(mesh,U,Uf,type,DApf,PsnGrad,Pcorrect,varargin)
%Rhie-Chow面速度修正
%简介：
%函数重载：
%   Uf = RCUf(mesh,U,Uf,type,DApf,PsnGrad,Pcorrect)
%   Uf = RCUf(mesh,U,Uf,type,DApf,PsnGrad,Pcorrect,Uold)
%输入参数：
%   mesh - 网格数据结构体
%   U - 当前时间/迭代步的速度场(边界条件传递)
%   Uf - 未经过R-C修正的面速度场
%   type - R-C插值类型，根据欠松弛、时间格式和体积力来选择
%   DApf - 面权重场
%   PsnGrad - 面压力梯度场
%   Pcorrect - 体心压力梯度的插值面场
%   Uold - 上一时间的速度场(transientRC需要)
%返回参数：
%   Uf(faceScalarField) - 函数重载1返回欠松弛R-C修正后的面速度场
%   Uf(faceScalarField) - 函数重载2返回瞬态R-C修正后的面速度场

switch type 
    case 1
        Uf = underRelaxRC(mesh,U,Uf,DApf,PsnGrad,Pcorrect);
    case 2
        Uf = transientRC(mesh,U,Uf,DApf,PsnGrad,Pcorrect,Uold);
    otherwise
        error('RCUf():RCType参数输入错误');
end

function Uf = underRelaxRC(mesh,U,Uf,DApf,PsnGrad,Pcorrect)
%仅欠松弛的R-C修正
%计算Uf^c = Uf_i - Dapf*snGrad(p) + Correct_grad(P)
% Uf为单纯的线性插值,但由于是矩形网格，
% 所以Uf.fields.xx为Uf.* nf(1,0)，
% Uf.fields.yy为Uf.* nf(0,1)
     Uf.fields.xx = Uf.fields.xx ...
                 - (DApf.xx .* PsnGrad.fields.x...
                 - DApf.xx .* Pcorrect.fields.x);
    Uf.fields.yy = Uf.fields.yy ...
                 - (DApf.yy .* PsnGrad.fields.y...
                 - DApf.yy .* Pcorrect.fields.y); 
    Uf = conCorrcetBC_vf(mesh,Uf,U);
end

function Uf = transientRC(mesh,U,Uf,DApf,PsnGrad,Pcorrect,Uold)
%仅欠松弛的R-C修正
%计算Uf^c = Uf_i - Dapf*snGrad(p) + Correct_grad(P)
% Uf为单纯的线性插值,但由于是矩形网格，
% 所以Uf.fields.xx为Uf.* nf(1,0)，
% Uf.fields.yy为Uf.* nf(0,1)

%计算Uold插值
    Ufold = cellToface_vf(mesh,Uold);

    Uf.fields.xx = Uf.fields.xx ...
                 - (DApf.xx .* PsnGrad.fields.x...
                 - DApf.xx .* Pcorrect.fields.x ...
                 - Ufold.fields.xx);
    Uf.fields.yy = Uf.fields.yy ...
                 - (DApf.yy .* PsnGrad.fields.y...
                 - DApf.yy .* Pcorrect.fields.y ...
                 - Ufold.fields.yy); 
    Uf = conCorrcetBC_vf(mesh,Uf,U);
end

end

