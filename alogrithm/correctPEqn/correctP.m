function correct = correctP(mesh,Ap,gradP)
%计算Rhie-chow的压力修正项
%简介：
%函数重载:
%   mcorrect = correctP(Ap,gradP,alpha)
%输入参数
%   Ap - 速度场离散矩阵主元值
%   gradP - 压力梯度，实质为gradP_Su(grad(Pp)*Vp)
%   alpha - 速度场矩阵松弛因子
%返回参数
%   correct(faceScalarField) - gradPf.*nf,R-C插值压力修正面场
 
global Nx Ny;
if strcmpi(Ap.type,'scalarAp')
    error('correctP():Ap.type错误');
end
%初始化内存
    %初始化Ap
    Ap_x = ones(Ny,Nx+2);
    Ap_y  = ones(Ny+2,Nx);
    Ap_x (:,2:end-1) = reshape(Ap.x,[Nx,Ny])';
    Ap_y (2:end-1,:) = reshape(Ap.y,[Nx,Ny])';
    %初始化Pgrad
    P_x = zeros(Ny,Nx+2);
    P_y  = zeros(Ny+2,Nx);
    P_x (:,2:end-1) = reshape(gradP.fields.x,[Nx,Ny])';
    P_y (2:end-1,:) = reshape(gradP.fields.y,[Nx,Ny])';
    %初始化V
    V_x = zeros(Ny,Nx+2);
    V_y = zeros(Ny+2,Nx);
    V_x(:,2:end-1) = reshape(mesh.cells.v,[Nx,Ny])';
    V_y(2:end-1,:) = reshape(mesh.cells.v,[Nx,Ny])';

%计算Vp/Ap * dp/dx|p 
    correct.fields.x = zeros(Ny,Nx+1);
    correct.fields.y = zeros(Ny,Nx+1);
    % correct.fields.x =  (V_x(:,1:end-1)./Ap_x(:,1:end-1).*P_x(:,1:end-1)...
    %                  + V_x(:,2:end)./Ap_x(:,2:end).*P_x(:,2:end))/2;
    % correct.fields.y = (V_y(1:end-1,:)./Ap_y(1:end-1,:).*P_y(1:end-1,:)...
    %                  + V_y(2:end,:)./Ap_y(2:end,:).*P_y(2:end,:))/2;
    correct.fields.x =  (P_x(:,1:end-1)+ P_x(:,2:end))/2;
    correct.fields.y =  (P_y(1:end-1,:) + P_y(2:end,:))/2;
%修正边界面
    correct.fields.x(:,1) = 0;
    correct.fields.x(:,end) = 0;
    correct.fields.y(1,:) = 0;
    correct.fields.y(end,:) = 0;
end


