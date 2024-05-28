function Ab = lap_center_scalar(k,field,mesh)
%结构网格(cavity)数据类型的laplace算子计算
%简介：
%   通过遍历网格体的方式组装矩阵这种方式其实是不推荐的，因为会重复计算
%   网格面，高效的方式是通过遍历网格面来进行组装，但这就需要网格面和体
%   间的映射关系，结构网格是不显式存在这些关系的。
%函数重载：
%   Ab = lap_center_scalar(k,field,mesh)
%输入参数：
%   field - 代求物理场
%   operator - 代求物理场的离散算子数组
%              例：[ddt_F,div_F,lap_F]
%   sign - 代求物理场的离散算子符号数组
%              例：['+','+','-']
%   isSolve - 控制是否对矩阵系统进行求解
%             默认值 = 0(不求解) 
%   alpha - 矩阵松弛因子
%             默认值 = 1

global Nx Ny;
%初始化linear System
    Ab.A = sparse(Nx*Ny,Nx*Ny);
    Ab.b = sparse(Nx*Ny,1);
%计算gdiff(nf *|Sf|/d)
    gdiff = calculateGdiff(mesh);
%计算kgdiff(K. * nf *|Sf|/d)
if isfield(k,'type')
    if contains(k.type,'scalar')
        kgdiff.x = gdiff.x .* k.x;
        kgdiff.y = gdiff.y .* k.y;
    elseif contains(k.type,'vector')
    %因为只考虑与网格面垂直的方向，因此xx和yy就是k.*nf
        kgdiff.x = gdiff.x .* k.xx;
        kgdiff.y = gdiff.y .* k.yy;
    end
else
    kgdiff.x = gdiff.x .* k;
    kgdiff.y = gdiff.y .* k;
end

%计算field边界对源项b的影响
    ALLS = extractScalarSu(kgdiff,field);
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
    ALL_Y = [own.x;neigh.x;own.x;neigh.x;...
            own.y';neigh.y';own.y';neigh.y'];
    ALL_X = [own.x;neigh.x;neigh.x;own.x;...
            own.y';neigh.y';neigh.y';own.y'];

    ALLA = [kgdiff.x;kgdiff.x;-kgdiff.x;-kgdiff.x;...
            kgdiff.y;kgdiff.y;-kgdiff.y;-kgdiff.y];
    Aex = accumarray([ALL_Y,ALL_X],ALLA,[],[],[],true);

%处理A和b
    Ab.A = -1.0*Aex(2:end,2:end);
    Ab.b = -1.0*sparse(ALLINDEX,1,ALLS,Nx*Ny,1); 
    Ab.type = 'fvm::laplacian::center';
function ALLS = extractScalarSu(kgdiff,field)
        bw = kgdiff.x(:,1) * outputC2(field,'W');
        be = kgdiff.x(:,end) * outputC2(field,'E');
        bs = kgdiff.y(1,:)'* outputC2(field,'S');
        bn = kgdiff.y(end,:)'* outputC2(field,'N');       
        ALLS = [bw;be;bs;bn];
end

end