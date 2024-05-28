function copyField = copyField(mesh,field)
%物理场值传递
%   此处显示详细说明
if contains(field.type,'Scalar')
%初始化物理场
copyField = generatefield(mesh,fieldDimension.vol,fieldType.scalar);
%传递场值
copyField.fields.x = field.fields.x;
elseif contains(field.type,'Vector')
%初始化物理场
copyField = generatefield(mesh,fieldDimension.vol,fieldType.vector);
%传递场值
copyField.fields.x = field.fields.x;
copyField.fields.y = field.fields.y;
end

