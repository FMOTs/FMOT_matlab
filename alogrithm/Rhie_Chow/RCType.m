classdef RCType < int32
%Rhie-Chow插值类型选择
%变量说明：
%   ur - 仅包含欠松弛的稳态RC插值
%   t - 仅包含BE瞬态格式的RC插值
%   b - 仅包含体积力的插值
    enumeration
        ur(1),
        t(2),
        b(3)
    end

end

