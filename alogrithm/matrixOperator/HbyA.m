function Hby = HbyA(Ap1,UEqn,U,Pgrad_Su)
%计算网格非压力驱动向量 计算公式：Hby = 1/Ap * H
Hby.fields = H(UEqn,U,Pgrad_Su);
Hby.fields.x = Ap1.x .* Hby.fields.x;
Hby.fields.y = Ap1.y .* Hby.fields.y;
Hby.type = 'volVectorField';



end

