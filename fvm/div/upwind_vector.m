function Ab = upwind_vector(phi,field,mesh)
%向量场的一阶迎风离散处理函数y
    global Nx Ny;
    %提取面通量phi
    phiSf.x = phi.fields.x;
    phiSf.y = phi.fields.y;
    %处理field的边界面对矩阵的影响
    %提取边界
    field.LBC = linearBC(mesh,field);  
    %边界面对应索引
    indexBW = mesh.faces.neigh.x(:,1);
    indexBE = mesh.faces.owner.x(:,end);
    indexBS = mesh.faces.neigh.y(1,:)';
    indexBN = mesh.faces.owner.y(end,:)';
    ALLINDEX_B = [indexBW;indexBE;indexBS;indexBN];
    %计算field边界对源项b的影响
    %注意！div中的field的边界(1,2类)只对b有影响
    bw_x = phiSf.x(:,1) * outputC2(field,'W','x');
    be_x = phiSf.x(:,end) * outputC2(field,'E','x');
    bs_x = phiSf.y(1,:)' * outputC2(field,'S','x');
    bn_x = phiSf.y(end,:)' * outputC2(field,'N','x');
    bw_y = phiSf.x(:,1) * outputC2(field,'W','y');
    be_y = phiSf.x(:,end) * outputC2(field,'E','y');
    bs_y = phiSf.y(1,:)' * outputC2(field,'S','y');
    bn_y = phiSf.y(end,:)' * outputC2(field,'N','y');

    ALLS_x = [bw_x;be_x;bs_x;bn_x];
    ALLS_y = [bw_y;be_y;bs_y;bn_y];
    
    % phi、own、neigh转化成列。own+1，然后再扣掉
    phiSf.x = reshape(phiSf.x,[numel(phiSf.x),1]);
    phiSf.y = reshape(phiSf.y,[numel(phiSf.y),1]);
    %获取网格面与网格的链接关系
    [own,neigh] = getON(mesh);
    %向量化处理Aex
    % fluxEp =(abs(phiSf.x) + phiSf.x)/2;
    % fluxEe =-(abs(phiSf.x) - phiSf.x)/2;
    % fluxWp = (abs(phiSf.x) - phiSf.x)/2;
    % fluxWw = -(abs(phiSf.x) + phiSf.x)/2;
    % fluxNp =(abs(phiSf.y) + phiSf.y)/2;
    % fluxNn =-(abs(phiSf.y) - phiSf.y)/2;
    % fluxSp =(abs(phiSf.y) - phiSf.y)/2;
    % fluxSs =-(abs(phiSf.y) + phiSf.y)/2;

    fluxEp = max(-phiSf.x,0);
    fluxEe = -max(-phiSf.x,0);
    fluxWp = max(phiSf.x,0);
    fluxWw = -max(phiSf.x,0);
    fluxNp = max(-phiSf.y,0);
    fluxNn = -max(-phiSf.y,0);
    fluxSp = max(phiSf.y,0);
    fluxSs = -max(phiSf.y,0);
    
    %重复了需要优化一下
    ALL_Y = [own.x;neigh.x;own.x;neigh.x;...
            own.y';neigh.y';own.y';neigh.y'];
    ALL_X = [own.x;neigh.x;neigh.x;own.x;...
            own.y';neigh.y';neigh.y';own.y'];
    ALLA = [fluxEp;fluxWp;fluxEe;fluxWw;...
            fluxNp;fluxSp;fluxNn;fluxSs];
    Aex = accumarray([ALL_Y,ALL_X],ALLA,[],[],[],true);
    %处理A和b
    Ab.A.x = sparse(Nx*Ny,Nx*Ny);
    Ab.A.y = sparse(Nx*Ny,Nx*Ny);
    Ab.A.z = [];
    Ab.A.x = Aex(2:end,2:end);
    Ab.A.y = Aex(2:end,2:end);
    Ab.b.x = sparse(ALLINDEX_B,1,ALLS_x,Nx*Ny,1);    
    Ab.b.y = sparse(ALLINDEX_B,1,ALLS_y,Nx*Ny,1); 
    Ab.type = 'fvm::div::upwind';  
end