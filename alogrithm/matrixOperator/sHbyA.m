function Hby = sHbyA(Ap1,UEqn,U)
%提取矩阵off-diagonal coefficients + source
Hby.fields = sH(UEqn,U);
Hby.fields.x = - Ap1.x .* Hby.fields.x;
Hby.fields.y = - Ap1.y .* Hby.fields.y;
Hby.type = 'volVectorField';

end

