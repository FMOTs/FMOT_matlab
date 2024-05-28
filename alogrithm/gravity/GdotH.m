function gh = GdotH(mesh,g)
%计算重力场和网格中心坐标的点乘
%简介：
%函数重载：
%   gh = GdotH(mesh,g)
%输入参数：
%   mesh - 网格结构体数据
%   g - 重力场
%返回参数：
%   gh (volScalarField) - 不同水深受到的重力

gh = generatefield(mesh,fieldDimension.vol,fieldType.scalar);

gh.fields.x = g.fields.y .* mesh.cells.centroids(:,2);


end

