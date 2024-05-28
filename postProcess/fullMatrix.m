function matrix = fullMatrix(operator)
%将离散算子的稀疏矩阵转为全矩阵
if contains(operator.type,'scalar')
    matrix.A =  full(operator.A);
    matrix.b =  full(operator.b);
elseif contains(operator.type,'vector')
    matrix.A.x =  full(operator.A.x);
    matrix.b.x =  full(operator.b.x);
    matrix.A.y =  full(operator.A.y);
    matrix.b.y =  full(operator.b.y);
else
 error('fullMatrix():operator.type错误');
end

end

