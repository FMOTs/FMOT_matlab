function isC = checkBC(field)
%检测结构体网格(Cavity)边界完整性
%检查物理场类型
if ~strcmpi(field.type,'volScalarField') ...
   && ~strcmpi(field.type,'volVectorField')...
   && ~strcmpi(field.type,'volTensorField')
    error('CheckBC()函数传入的物理场类型错误');  
end
%检查边界初始化
if ~isfield(field.BC,'W')
    error('物理场缺少W边界');  
end
if ~isfield(field.BC,'E')
    error('物理场缺少E边界');  
end
if ~isfield(field.BC,'S')
    error('物理场缺少S边界');     
end
if ~isfield(field.BC,'N')
    error('物理场缺少N边界');  
end
isC = 1;
end

