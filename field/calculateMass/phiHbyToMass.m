function mass = phiHbyToMass(phiHbyA)
%根据phiHbyAf计算压力方程的质量源项
%注意！！这个函数是重复的，可以和div_Fvc合并
global Nx Ny;

mass.A = sparse(Nx*Ny,Nx*Ny);
mass.b = zeros(Nx*Ny,1);
div_x = zeros(Ny,Nx);
div_y = zeros(Ny,Nx);
div_x = phiHbyA.fields.x(:,2:end)- phiHbyA.fields.x(:,1:end-1);
div_y = phiHbyA.fields.y(2:end,:) - phiHbyA.fields.y(1:end-1,:);
mass.b = reshape(div_x',[Nx*Ny,1]) + reshape(div_y',[Nx*Ny,1]);
mass.type = 'fvc::div::gauss';
end

