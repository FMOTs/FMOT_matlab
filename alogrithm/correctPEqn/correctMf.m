function phi = correctMf(mesh,phi,Uf,P,DApf,rho)
%根据压力修正值，修正
% 面通量场phi
%   此处显示详细说明

%初始化默认值
if nargin == 5
    rho = 1;
end

%计算PWIM后的质量通量
Uf.fields.xx = rho .* Uf.fields.xx .* mesh.faces.areas.x;
Uf.fields.yy = rho .* Uf.fields.yy .* mesh.faces.areas.y;

PsnGrad = snGrad_fvc(mesh,P,mesh.faces.areas);
phi.fields.x = (Uf.fields.xx - rho .* DApf.xx .* PsnGrad.fields.x);
phi.fields.y = (Uf.fields.yy - rho .* DApf.yy .* PsnGrad.fields.y);

end

