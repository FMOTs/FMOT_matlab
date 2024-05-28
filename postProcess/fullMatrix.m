function matrix = fullMatrix(operator)
%����ɢ���ӵ�ϡ�����תΪȫ����
if contains(operator.type,'scalar')
    matrix.A =  full(operator.A);
    matrix.b =  full(operator.b);
elseif contains(operator.type,'vector')
    matrix.A.x =  full(operator.A.x);
    matrix.b.x =  full(operator.b.x);
    matrix.A.y =  full(operator.A.y);
    matrix.b.y =  full(operator.b.y);
else
 error('fullMatrix():operator.type����');
end

end

