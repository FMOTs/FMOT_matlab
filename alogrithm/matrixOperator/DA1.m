function DAp = DA1(mesh,A1)
%计算Vp./Ap
%简介：
%函数重载:
%   DAp = DA1(mesh,A1)
%输入参数
%   mesh - 网格结构数据体
%   A1 - 1/Ap

if strcmpi(A1.type,'scalarAp1')
   DAp.x = mesh.cells.v .* A1.x; 
   DAp.type = 'scalarDAp1';
elseif strcmpi(A1.type,'vectorAp1')
   DAp.x = mesh.cells.v .* A1.x; 
   DAp.y = mesh.cells.v .* A1.y; 
   DAp.type = 'vectorDAp1';
else
    error('DA1():A1.type错误')
end

end

