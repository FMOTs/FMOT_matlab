function Ab = lap_center_vector(k,field,mesh)
%结构网格(cavity)数据类型的laplace算子计算
%简介：
%   通过遍历网格体的方式组装矩阵这种方式其实是不推荐的，因为会重复计算
%   网格面，高效的方式是通过遍历网格面来进行组装，但这就需要网格面和体
%   间的映射关系，结构网格是不显式存在这些关系的。

global Nx Ny;
%初始化linear System
    Ab.A.x = sparse(Nx*Ny,Nx*Ny);
    Ab.A.y = sparse(Nx*Ny,Nx*Ny);
    Ab.A.z = sparse(Nx*Ny,Nx*Ny);
    Ab.b.x = sparse(Nx*Ny,1);
    Ab.b.y = sparse(Nx*Ny,1);
    Ab.b.z = sparse(Nx*Ny,1);
%计算gdiff
    gdiff = calculateGdiff(mesh);
%计算kgdiff
    kgdiff.x = gdiff.x .* k;
    kgdiff.y = gdiff.y .* k;
%计算field边界对源项b的影响
    ALLS = extractVectorSu(kgdiff,field);
%修正kgdiff边界面值
%注意！laplace中的field的边界(1,2类)通过修正已经添加到kgdiff中
    kgdiff = correctLapB(mesh,kgdiff,field);
%将矩阵转化成行向量
    kgdiff.x = reshape(kgdiff.x,[numel(kgdiff.x),1]);
    kgdiff.y = reshape(kgdiff.y,[numel(kgdiff.y),1]);
%边界面对应索引
    indexBW = mesh.faces.neigh.x(:,1);
    indexBE = mesh.faces.owner.x(:,end);
    indexBS = mesh.faces.neigh.y(1,:)';
    indexBN = mesh.faces.owner.y(end,:)';
    ALLINDEX = [indexBW;indexBE;indexBS;indexBN];
%获取网格面与网格的链接关系
    [own,neigh] = getON(mesh);
%向量化组装A和b
    ALL_Y = [own.x;neigh.x;neigh.x;own.x;...
            own.y';neigh.y';own.y';neigh.y'];
    ALL_X = [own.x;neigh.x;own.x;neigh.x;...
            own.y';neigh.y';neigh.y';own.y'];
    ALLA = [kgdiff.x;kgdiff.x;-kgdiff.x;-kgdiff.x;...
            kgdiff.y;kgdiff.y;-kgdiff.y;-kgdiff.y];
    Aex = accumarray([ALL_Y,ALL_X],ALLA,[],[],[],true);

%处理A和b
    Ab.A.x = -1.0*Aex(2:end,2:end);
    Ab.A.y = -1.0*Aex(2:end,2:end);
    Ab.A.z = -1.0*Aex(2:end,2:end);
    Ab.b.x = -1.0*sparse(ALLINDEX,1,ALLS.x,Nx*Ny,1);   
    Ab.b.y = -1.0*sparse(ALLINDEX,1,ALLS.y,Nx*Ny,1); 
    Ab.b.z = -1.0*sparse(ALLINDEX,1,ALLS.z,Nx*Ny,1); 
    Ab.type = 'fvm::laplacian::center';
function ALLS = extractVectorSu(kgdiff,field)
        bw_x = kgdiff.x(:,1) * outputC2(field,'W','x');
        be_x = kgdiff.x(:,end) * outputC2(field,'E','x');
        bs_x = kgdiff.y(1,:)'* outputC2(field,'S','x');
        bn_x = kgdiff.y(end,:)'* outputC2(field,'N','x');

        bw_y = kgdiff.x(:,1) * outputC2(field,'W','y');
        be_y = kgdiff.x(:,end) * outputC2(field,'E','y');
        bs_y = kgdiff.y(1,:)'* outputC2(field,'S','y');
        bn_y = kgdiff.y(end,:)'* outputC2(field,'N','y');

        bw_z = kgdiff.x(:,1) * outputC2(field,'W','y');
        be_z = kgdiff.x(:,end) * outputC2(field,'E','y');
        bs_z = kgdiff.y(1,:)'* outputC2(field,'S','y');
        bn_z = kgdiff.y(end,:)'* outputC2(field,'N','y');
        
        ALLS.x = [bw_x;be_x;bs_x;bn_x];
        ALLS.y = [bw_y;be_y;bs_y;bn_y];
        ALLS.z = [bw_z;be_z;bs_z;bn_z];
end

end