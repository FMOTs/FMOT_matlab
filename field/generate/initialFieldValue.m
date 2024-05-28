function field = initialFieldValue(field,varargin)
%初始化物理场的值
%简介：
%函数重载:
%   field = initialFieldValue(field) 
%   field = initialFieldValue(field,field2) 
%   field = initialFieldValue(field,value) 
%输入参数
%   field - 被初始化的物理场
%   field2 - 被复制的物理场，将field的值改为field2
%            field2的维度必须与field相同
%   value - 初始化的值，分成scalar和vector两种情况
%         - scalar：当value为1个值时，将field的所有方向的场全部初始化为value
%         - vector：当value(x,y,z)为向量时，将field对应方向的场初始化为value
%         - default：当value不传入时，默认value = 0，将物理场现有的值清空
if contains(field.type,'Scalar')
    field.fields.x(:) = 0;
end

if contains(field.type,'Vector')
    field.fields.x(:) = 0;
    field.fields.y(:) = 0;
    field.fields.z(:) = 0;
end

if nargin > 1 && ~isnumeric(varargin{1})
    if contains(field.type,'Scalar')
        dim1 = numerl(field.fields.x);
        dim2 = numerl(varargin{1}.fields.x);
        if dim1 ~= dim2
            error('initialFieldValue()传入的复制物理场与被初始化物理场维度不同');
        end
        field.fields.x = varargin{1}.fields.x;
    end
    if contains(field.type,'Vector')
        dim1.x = numerl(field.fields.x);
        dim1.y = numerl(field.fields.x);
        dim1.z = numerl(field.fields.x);
        dim2.x = numerl(varargin{1}.fields.x);
        dim2.y = numerl(varargin{1}.fields.y);
        dim2.z = numerl(varargin{1}.fields.z);
        if dim1.x ~= dim2.x || dim1.y ~= dim2.y || dim1.z ~= dim2.z
            error('initialFieldValue()传入的复制物理场与被初始化物理场维度不同');
        end
        field.fields.x = varargin{1}.fields.x;
        field.fields.y = varargin{1}.fields.y;
        field.fields.z = varargin{1}.fields.z;
    end
end

if nargin > 1 && isnumeric(varargin{1})
    if contains(field.type,'Scalar')
        field.fields.x(:) = varargin{1}(1);
    end
    if contains(field.type,'Vector')
        field.fields.x(:) = varargin{1}(1);
        field.fields.y(:) = varargin{1}(2);
        field.fields.z(:) = varargin{1}(3);
    end    
end

end

