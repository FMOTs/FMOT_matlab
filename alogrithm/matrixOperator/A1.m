function Ap = A1(Eqn)
%提取矩阵1/diagonal coefficients 
%   
if strcmpi(Eqn.type,'scalarMatrix')
   Ap.x = 1./diag(Eqn.A); 
   Ap.type = 'scalarAp1';
elseif strcmpi(Eqn.type,'vectorMatrix')
   Ap.x = 1./diag(Eqn.A.x); 
   Ap.y = 1./diag(Eqn.A.y); 
   Ap.type = 'vectorAp1';
else
    error('A():Eqn.type错误')
end

end

