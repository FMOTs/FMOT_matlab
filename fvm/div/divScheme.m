classdef divScheme < int32
%对流项(div)的离散格式选择枚举类
    %   此处显示详细说明
    enumeration
        center(1),
        upwind(2),
        upwind2(3)
    end
end

