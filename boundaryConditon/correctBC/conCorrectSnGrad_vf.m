function gradf = conCorrectSnGrad_vf(mesh,gradf,field)
%结构网格的snGrad边界值修正
%  注意！目前只支持标量场修正 
global Nx Ny;
%检查边界完整性
    checkBC(field);
%提取边界
    field.LBC = linearBC(mesh,field); 
%修正边界,目前只支持标量场修正
    if strcmpi(field.type,'volScalarField')  
        %计算边界网格的dx和dy
        endx = mesh.points.x(end);
        endy = mesh.points.y(end);   
        bcdx_b = (mesh.cells.cx(1) - 0);%W
        bcdx_e = (endx - mesh.cells.cx(end));%E
        bcdy_b = (mesh.cells.cy(1) - 0);%S
        bcdy_e = (endy - mesh.cells.cy(end));%N
        %计算边界值
        PHI = reshape(field.fields.x,[Nx,Ny])'; 
        BCVALUE_W = calculateSnGrad_scalar(field.BC.W,PHI(:,1),bcdx_b);
        BCVALUE_E = calculateSnGrad_scalar(field.BC.E,PHI(:,end),bcdx_e);
        BCVALUE_S = calculateSnGrad_scalar(field.BC.S,PHI(1,:),bcdy_b);
        BCVALUE_N = calculateSnGrad_scalar(field.BC.N,PHI(end,:),bcdy_e);
        %修正边界面值
        gradf.fields.x(:,1) = BCVALUE_W;
        gradf.fields.x(:,end) = BCVALUE_E;
        gradf.fields.y(1,:) = BCVALUE_S;
        gradf.fields.y(end,:) = BCVALUE_N;
    elseif strcmpi(field.type,'volVectorField')
        error('conCorrectSnGrad_vf():filed.type目前未编写volVectorField的修正');
    else
        error('conCorrectSnGrad_vf():filed.type错误');
    end

function BCsngrad = calculateSnGrad_scalar(BC,PHIc,Dcb)
%计算边界梯度值
if strcmpi(BC.type,'Dirichlet')
    BCsngrad = (PHIc - BC.value)/Dcb;
elseif strcmpi(BC.type,'Neumann')
    BCsngrad = BC.value;
else
    error('conCorrectSnGrad_vf():calculateSnGrad_scalar():边界类型错误');
end
end

end

