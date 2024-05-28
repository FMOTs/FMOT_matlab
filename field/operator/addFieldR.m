function field1 = addFieldR(field1,field2)
%两个物理场相加,并返回修正后的field1
%   此处显示详细说明

%判断2场类型是否相同
if field1.type ~= field2.type
    error('addField():相加物理场类型不相同');
end
%常规物理场相加
if contains(field1.type,'Scalar')
field1.fields.x = field1.fields.x + field2.fields.x;
elseif contains(field1.type,'Vector')
%初始化物理场
newField = generatefield(mesh,fieldDimension.vol,fieldType.vector);
%传递场值
field1.fields.x = field1.fields.x + field2.fields.x;
field1.fields.y = field1.fields.y + field2.fields.y;
end
%算子物理场相加
if contains(field1.type,'::')
    field1.A = field1.A + field2.A;
    field1.b = field1.b + field2.b;
    newField.type = field1.type;
end

end

