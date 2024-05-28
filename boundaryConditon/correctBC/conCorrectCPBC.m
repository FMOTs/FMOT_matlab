function faceField = conCorrectCPBC(faceField)
%压力修正方程的边界面值修正（结构网格）
faceField.fields.x(:,1) = 0;
faceField.fields.x(:,end) = 0;
faceField.fields.y(1,:) = 0;
faceField.fields.y(end,:)= 0;
end

