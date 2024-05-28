function HS = H(Eqn,field,Pgrad_Su)
%提取矩阵off-diagonal coefficients + source
%   
global Nx Ny;
if strcmpi(Eqn.type,'scalarMatrix')
   HS.x = (sum(Eqn.A,2) - diag(Eqn.A)) .* field.fields.x; 
   HS.type = 'volScalarField';
elseif strcmpi(Eqn.type,'vectorMatrix')
   %提取非主元位置索引
   offIndex = find(Eqn.A.x < 0);
   [row,col] = ind2sub([Nx*Ny,Nx*Ny],offIndex);
   AnUn_x = Eqn.A.x(offIndex) .* field.fields.x(col);
   HS.x = accumarray(row,AnUn_x) - Eqn.b.x + Pgrad_Su.b.x;
   AnUn_y = Eqn.A.y(offIndex) .* field.fields.y(col);
   HS.y = accumarray(row,AnUn_y) - Eqn.b.y + Pgrad_Su.b.y;


   HS.type = 'volVectorField';
else
    error('H():Eqn.type错误')
end

end

