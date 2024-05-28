function mass = phiToMass(phi)
%依据网格面通量计算散度
%用来检测phi是否质量守恒

global Nx Ny;
div_x = phi.fields.x(:,2:end) - phi.fields.x(:,1:end-1);
div_y = phi.fields.y(2:end,:) - phi.fields.y(1:end-1,:);
mass = reshape(div_x',[Nx*Ny,1]) + reshape(div_y',[Nx*Ny,1]);
end

