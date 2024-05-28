function RES = iteraRes(i,RES,field,filedEqn,name)
%计算物理场迭代残差
%   此处显示详细说明

%判断物理场维度
if contains(field.type,'Vector')
    %计算物理场的残差r的L2
    % res.x = sum(abs(filedEqn.A.x * filedEqn.oldFields.x -  filedEqn.b.x));
    % res.y = sum(abs(filedEqn.A.y * filedEqn.oldFields.y -  filedEqn.b.y));
    res.x = norm((filedEqn.A.x * filedEqn.oldFields.x -  filedEqn.b.x),1);
    res.y = norm((filedEqn.A.y * filedEqn.oldFields.y -  filedEqn.b.y),1);
    %计算物理场平均值(代表残差)
    xMean = mean(filedEqn.oldFields.x).* ones(length(filedEqn.oldFields.x),1);
    yMean = mean(filedEqn.oldFields.y).* ones(length(filedEqn.oldFields.y),1);
    %计算归一化因子的L2
    nX = norm((filedEqn.A.x * xMean -  filedEqn.b.x),1);
    nY = norm((filedEqn.A.y * yMean -  filedEqn.b.y),1);
    %计算残差
    res.x = res.x / max(max(nX), 1e-6);
    res.y = res.y / max(max(nY), 1e-6);
    %计算残差赋值
    RES.(name)(i,1) = res.x;
    RES.(name)(i,2) = res.y;
elseif contains(field.type,'Scalar')
    %计算物理场的残差的L1
    res.x = norm((filedEqn.A * filedEqn.oldFields -  filedEqn.b),1);
    %计算物理场平均值(代表残差)
    xMean = mean(filedEqn.oldFields).* ones(length(filedEqn.oldFields),1);
    %计算归一化因子的L1
    nX = norm((filedEqn.A * xMean -  filedEqn.b),1);
    %计算残差
    res.x = res.x / max(max(nX), 1e-6);
    %计算残差赋值
    RES.(name)(i,1) = res.x;
end
    

end


