function g = setGravity(mesh)
%生成重力场
%简介：
%函数重载：
%   g = setGravity()
%输入参数：
%   mesh - 网格结构体数据
%返回参数：
%   g(volVectorField) - 重力场

g = generatefield(mesh,fieldDimension.vol,fieldType.vector);
g = initialFieldValue(g,[0,-9.8,0]);

end

