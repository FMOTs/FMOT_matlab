function Apf = AToAf(Ap)
%由Ap计算1/Apf的线性插值函数，边界面Ap直接等于边界网格值
% 简介：
%函数重载:
%   Apf = AToAf(Ap)
%   Apf = AToAf(Ap,V)
%输入参数
%   Ap - 各网格对应的离散矩阵主元值
%   v - 各网格单元体积，默认值 = 1
%   %返回参数
%   Apf - 函数重载1返回Apf 
%   Apf - 函数重载1返回Apf.*Vf，这个是单独计算R-C的DApf时使用的
%   注意:ScalarField为Apf.x,Apf.y
%        VectorFiedl为Apf.xx,Apf.xy;Apf.yx,Apf.yy
global Nx Ny;


if contains(Ap.type,'scalarAp') 
    Apf = calculateApf_scalar(Ap);
    Apf.type = 'scalarApf';
elseif contains(Ap.type,'scalarDAp')
    Apf = calculateApf_scalar(Ap);
    Apf.type = 'scalarDApf';    
elseif contains(Ap.type,'scalarAp1')
    Apf = calculateApf_scalar(Ap);
    Apf.type = 'scalarApf1';
elseif contains(Ap.type,'vectorAp') 
    Apf = calculateApf_vector(Ap);
    Apf.type = 'vectorApf';
elseif contains(Ap.type,'vectorDAp') 
    Apf = calculateApf_vector(Ap);
    Apf.type = 'vectorDApf';    
elseif contains(Ap.type,'vectorAp1')
    Apf = calculateApf_vector(Ap);
    Apf.type = 'vectorApf1';
else
    error('ApToApf():Ap类型错误');
end

function Apf = calculateApf_scalar(Ap)
%scalarAp的插值函数
%初始化内存
    Ap_x = zeros(Ny,Nx+2);
    Ap_y  = zeros(Ny+2,Nx);
    % V_x = ones(Ny,Nx+2);
    % V_y = ones(Ny+2,Nx);
    % V_x(:,2:end-1) = reshape(v,[Nx,Ny])';
    % V_y(2:end-1,:) = reshape(v,[Nx,Ny])';
    Ap_x (:,2:end-1) = reshape(Ap.x,[Nx,Ny])';
    Ap_y (2:end-1,:) = reshape(Ap.x,[Nx,Ny])';
%计算内部面插值(目前仅考虑均一网格)
    Apf.x = (Ap_x(:,1:end-1) + Ap_x(:,2:end))/2;
    Apf.y = (Ap_y(1:end-1,:) + Ap_y(2:end,:))/2;    
%修正边界面
    Apf.x(:,1) = Ap_x(:,2);
    Apf.x(:,end) = Ap_x(:,end-1);
    Apf.y(1,:) = Ap_y(2,:);
    Apf.y(end,:) = Ap_y(end,:);
end

function Apf = calculateApf_vector(Ap)
%scalarAp的插值函数
%初始化内存
    %U的Ap
    Ap_xx = zeros(Ny,Nx+2);
    Ap_xy = zeros(Ny+2,Nx);
    Ap_xx (:,2:end-1) = reshape(Ap.x,[Nx,Ny])';
    Ap_xy (2:end-1,:) = reshape(Ap.x,[Nx,Ny])';
    %V的Ap
    Ap_yx  = zeros(Ny,Nx+2);
    Ap_yy  = zeros(Ny+2,Nx);
    Ap_yx (:,2:end-1) = reshape(Ap.y,[Nx,Ny])';
    Ap_yy (2:end-1,:) = reshape(Ap.y,[Nx,Ny])';
%计算内部面插值
    %计算U的Apf
    Apf.xx = (Ap_xx(:,1:end-1) + Ap_xx(:,2:end))/2;
    Apf.xy = (Ap_xy(1:end-1,:) + Ap_xy(2:end,:))/2;
    %计算V的Apf
    Apf.yx = (Ap_yx(:,1:end-1) + Ap_yx(:,2:end))/2;   
    Apf.yy = (Ap_yy(1:end-1,:) + Ap_yy(2:end,:))/2;   
%修正边界面
    %修正U的Apf
    Apf.xx(:,1) = Ap_xx(:,2);
    Apf.xx(:,end) = Ap_xx(:,end-1);
    Apf.xy(1,:) = Ap_xy(2,:);
    Apf.xy(end,:) = Ap_xy(end-1,:);
    %修正V的Apf
    Apf.yx(:,1) = Ap_yx(:,2);
    Apf.yx(:,end) = Ap_yx(:,end-1);
    Apf.yy(1,:) = Ap_yy(2,:);
    Apf.yy(end,:) = Ap_yy(end-1,:);
end
end

