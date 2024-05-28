function Ab = ddt_fvm(mesh,time,ddtScheme,field,varargin)
%根据离散格式生成对流项(div)的隐式线代系统
%简介：
%函数重载:
%   field = ddt_fvm(mesh,t,ddtScheme,field)
%   field = ddt_fvm(mesh,t,ddtScheme,field,rho)
%输入参数
%   mesh - 网格数据结构体
%   time - 算例时间控制类的实例化对象
%   ddtScheme - 时间项离散格式
%   field - 离散物理场
%   rho - 流体密度，若不输入默认为1

global Nx Ny;
%初始化默认变量
rho = 1;

if nargin > 4 && isnumeric(varargin{1})
    rho = varargin{1};
end

if ddtScheme == 1
   Ab = Euler(mesh,time,field,rho);
else
   error('ddt离散格式错误，目前仅支持Euler离散');
end


function Ab = Euler(mesh,time,field,rho)
%一阶向后Euler时间离散格式
   if contains(field.type,'Scalar')
        rho_dt = rho / time.dt;
        dv = rho_dt * mesh.cells.v;
        Ab.A = spdiags(dv,0,Nx*Ny,Nx*Ny);
        Ab.b = dv .* field.fields.x;
   elseif contains(field.type,'Vector')
        rho_dt = rho / time.dt;
        dv = rho_dt * mesh.cells.v;
        Ab.A.x = spdiags(dv,0,Nx*Ny,Nx*Ny);
        Ab.A.y = spdiags(dv,0,Nx*Ny,Nx*Ny);
        Ab.A.z = spdiags(dv,0,Nx*Ny,Nx*Ny);
        Ab.b.x = dv .* field.fields.x;
        Ab.b.y = dv .* field.fields.y;
        Ab.b.z = dv .* field.fields.z;
   end
   Ab.type = 'fvm::ddt'; 
end

end

