function [U,P] = correctUP(mesh,U,DAp,P,PEqn,PEqnType,varargin)
%根据修正压力更新速度场和压力场
%函数重载:
%   [U,P] = correctUP(mesh,U,DAp,P,PEqn,PEqnType)
%   [U,P] = correctUP(mesh,U,DAp,P,PEqn,PEqnType,falphaP)
%   [U,P] = correctUP(mesh,U,DAp,P,PEqn,PEqnType,falphaU,falphaP)
%输入参数
%   mesh - 网格数据结构体
%   U - 当前速度场
%   DAp - 基于速度矩阵建立的权重系数
%   P - 压力场
%   PEqn - 压力场矩阵，包含上一迭代的压力场
%   PEqnType - 压力场类型选择,包含修正压力cp和完整压力场p
%   falphaU - 速度场显式欠松弛 
%   falphaP - 压力场显式欠松弛 

if PEqnType == 1
    %初始化默认参数
    if nargin == 6
        falphaU = 1;
        falphaP = 1;
    end
    if nargin == 7 && isnumeric(varargin{1})
        falphaU = 1;
        falphaP = varargin{1};
    end
    if nargin == 8 && isnumeric(varargin{:})
        falphaU = varargin{1};
        falphaP = varargin{2};
    end
    [U,P] = correctPEqn(mesh,U,DAp,P,PEqn,falphaU,falphaP);
elseif PEqnType == 2
    %初始化默认参数
    if nargin == 7
        Hby = varargin{1};
        falphaU = 1;
        falphaP = 1;
    end
    if nargin == 8 && isnumeric(varargin{2})
        Hby = varargin{1};
        falphaU = 1;
        falphaP = varargin{2};
    end
    if nargin == 9 && isnumeric(varargin{2:end})
        Hby = varargin{1};
        falphaU = varargin{2};
        falphaP = varargin{3};
    end
    [U,P] = completePEqn(mesh,U,DAp,P,PEqn,Hby,falphaU,falphaP);
else
    error('coorectUP():PEqnType错误');
end

function [U,P] = correctPEqn(mesh,U,DAp,P,PEqn,falphaU,falphaP)
%压力修正方程修正U和P  
    %压力场松弛
    %计算压力体心场Pgrad
    Pgrad = gradPC(mesh,P);
    %修正速度
    U.fields.x = U.fields.x - falphaU .* DAp.x .* Pgrad.fields.x;
    U.fields.y = U.fields.y - falphaU .* DAp.y .* Pgrad.fields.y;
    %压力场松弛
    P.fields.x = PEqn.oldFields + falphaP.* P.fields.x;
end

function [U,P] = completePEqn(mesh,U,DAp,P,PEqn,Hby,falphaU,falphaP)
%压力方程修正U和P 
     %压力场松弛
    P.fields.x = PEqn.oldFields + falphaP.* (P.fields.x - PEqn.oldFields);
    %计算压力体心场Pgrad
    Pgrad = grad_fvc(mesh,P,gradScheme.Gauss,gradType.field);
    %修正速度，Hby要*-1来修正，因为FMOT的laplace项默认是负数
    U.fields.x = -Hby.fields.x - falphaU .* DAp.x .* Pgrad.fields.x;
    U.fields.y = -Hby.fields.y - falphaU .* DAp.y .* Pgrad.fields.y;
end

end

