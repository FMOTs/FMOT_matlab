function kgdiff = correctLapB(mesh,kgdiff,field)
%根据边界条件，修正kgdiff的值
%检查边界完整性
checkBC(field);
%提取边界
field.LBC = linearBC(mesh,field);
%extroplate计算边界
kgdiff.x(:,1) = kgdiff.x(:,1).* (1 - field.LBC.W.c1);
kgdiff.x(:,end) = kgdiff.x(:,end).* (1 - field.LBC.E.c1);
kgdiff.y(1,:) = kgdiff.y(1,:) .* (1 - field.LBC.S.c1);
kgdiff.y(end,:) = kgdiff.y(end,:) .* (1 - field.LBC.N.c1) ;
end