function mesh = ConstuctMesh(cellDim,varargin)
%生成cavity网格数据结构体
%简介：
%函数重载：
%   mesh = ConstuctMesh(cellDim)
%   mesh = ConstuctMesh(cellDim, physDim)
%输入参数：
%   cellDim - 向量，长度为1，2，计算区域各方向网格划分数目。
%   physDim - 向量，与cellDim维度必须保持一致，物理场的真实尺寸，
%             默认值 = cellDim    
%返回参数：
%   mesh - 结构网格数据结构体
%          包含变量：
%               - mesh.cells.centroids(网格体中心坐标)
%               - mesh.cells.v(网格体体积)
%               - mesh.cells.index(网格体索引编号)
%               - mesh.cells.number(网格单元总数)
%               - mesh.cells.index(网格体索引编号)
%               - mesh.faces.centroids(网格体中心坐标)
%               - mesh.faces.areas(网格面面积)
%               - mesh.faces.nf(网格面单位面法向量)
%               - mesh.faces.number(网格面总数)
%               - mesh.faces.owner(网格面own编号)
%               - mesh.faces.neigh(网格面neighbour编号)
%               - mesh.faces.index(网格体索引编号)
%               - mesh.points.coordinate(网格点坐标)
%               - mesh.points.number(网格点总数)
%               - mesh.dim(网格的维度)
%               - mesh.type(网格的类型)

%防御编程，保证网格维度为正数
if ~all(cellDim > 0)
   error('CELLDIM 必须为正数');
end
%提取物理场维度(默认操作)
physDim = cellDim;
%修正物理场维度
if nargin > 1 && isnumeric(varargin{1})
   physDim  = varargin{1};
end
mesh = generateConstructMesh(cellDim,physDim);


function mesh = generateConstructMesh(cellDim,physDim)
%生成网格
    mesh.dim = numel(cellDim);   
    switch  mesh.dim
    case 1
        %计算points
        mesh.points = calculatePoints1D(cellDim,physDim);
        %计算faces
        mesh.faces = calculateFaces1D(mesh.points);
        %计算cells
        mesh.cells = calculateCells1D(cellDim,physDim);
    case 2
        %计算points
        mesh.points = calculatePoints2D(cellDim,physDim);
        %计算faces
        mesh.faces = calculateFaces2D(mesh.points,cellDim);
        %计算cells
        mesh.cells = calculateCells2D(cellDim,physDim);
    otherwise
        error('网格维度错误/功能未实现，当前输入网格维度 = %d', dim);
    end
    mesh.type = 'construct';
end

function points = calculatePoints1D(cellDim,physDim)
%计算网格点1D(points)相关数据
    points.coordinate = linspace(0, physDim(1), cellDim(1)+1)';
    points.number = size(points.coordinate,1);
end

function points = calculatePoints2D(cellDim,physDim)
%计算网格点2D(points)相关数据
    px = linspace(0, physDim(1), cellDim(1)+1);
    py = linspace(0, physDim(2), cellDim(2)+1);
%储存分离的x,y坐标
    points.x = px;
    points.y = py;
    points.coordinate = [];
    for j = 1: length(py)
        yValue = py(j)* ones(length(px),1);
        points.coordinate = [points.coordinate;[px',yValue]];
    end
    points.number = size(points.coordinate,1);
end

function faces = calculateFaces1D(points)
%计算网格面1D(faces)相关数据
    faces.centroids = points.coordinate;
    faces.areas = ones(1,points.number);
    faces.index = linspace(1,points.number,points.number);
    faces.number = points.number;
end

function faces = calculateFaces2D(points,cellDim)
%计算网格面2D(faces)相关数据
%先处理x方向的face
    faces.centroids = [];
    faces.areas = [];
    %网格点坐标
    px = linspace(0, physDim(1), cellDim(1)+1);
    py = linspace(0, physDim(2), cellDim(2)+1);
    %网格点距离
    pdx = (px(2:1:end) - px(1:1:end-1));
    pdy = (py(2:1:end) - py(1:1:end-1));
    %网格中心坐标
    cx = linspace(0,physDim(1),2*cellDim(1)+1);
    cx = cx(2:2:end);
    cy = linspace(0,physDim(2),2*cellDim(2)+1);
    cy = cy(2:2:end);
    %网格维度
    Nx = cellDim(1);
    Ny = cellDim(2);
    %初始化面积
    A.x = ones(Ny,Nx + 1);
    A.y = ones(Ny+1,Nx);
    %计算face面积
    %列.*A保证每一行对应相乘
    faces.areas.x = pdy' .* A.x;
    %行.*A保证每一列对应相乘
    faces.areas.y = pdx .* A.y;
    %计算face中心坐标
    [faces.centroids.X.x,faces.centroids.X.y] = meshgrid(px,cy);  
    [faces.centroids.Y.x,faces.centroids.Y.y] = meshgrid(cx,py);  
    %初始化单位面法向量
    faces.nf.x = ones(Ny,Nx + 1);
    faces.nf.y = ones(Ny+1,Nx);
    %修正单位面法向量
    faces.nf.x(:,1) = -1;
    faces.nf.y(1,:) = -1;
    %修正单位面法向量
    faces.number = sum(numel(faces.nf.x) + numel(faces.nf.y));
    %计算own和neigh
    CINDEX = zeros(Nx+2,Ny+2);
    CINDEX(2:Nx+1,2:Ny+1) = reshape(1:Ny*Nx,[Nx,Ny]);
    CINDEX = CINDEX';
    faces.owner.x = CINDEX(2:Ny+1,1:Nx+1);
    faces.neigh.x = CINDEX(2:Ny+1,2:Nx+2);
    faces.owner.y = CINDEX(1:Ny+1,2:Nx+1);
    faces.neigh.y = CINDEX(2:Ny+2,2:Nx+1);
end

function cells = calculateCells1D(cellDim,physDim)
%计算网格体1D(cells)相关数据
    px = linspace(0, physDim(1), cellDim(1)+1);
    cx = linspace(0,physDim(1),2*cellDim(1)+1); 
    cells.centroids = cx(2:2:end);
    cells.number = cellDim;
    cells.v = px(2:end) - px(1:end-1);
end

function cells = calculateCells2D(cellDim,physDim)
%计算网格体2D(cells)相关数据
    cx = linspace(0,physDim(1),2*cellDim(1)+1);
    cx = cx(2:2:end);
    cy = linspace(0,physDim(2),2*cellDim(2)+1);
    cy = cy(2:2:end);
%储存分离的x,y坐标
    cells.cx = cx;
    cells.cy = cy;
    cells.centroids = [];
    for j = 1: cellDim(2)
        yValue = cy(j)* ones(cellDim(1),1);
        cells.centroids = [cells.centroids;[cx',yValue]];
    end
    cells.number = cellDim(1) * cellDim(2);
    cells.index = linspace(1,cells.number,cells.number)';
    cells.number = [cells.number;cellDim(1);cellDim(2)];
    %计算网格体积
    px = linspace(0, physDim(1), cellDim(1)+1);
    py = linspace(0, physDim(2), cellDim(2)+1);
    dx = px(2:end) - px(1:end-1);
    dy = py(2:end) - py(1:end-1);
    [Dx,Dy] = meshgrid(dx,dy);
    cells.v = reshape((Dx.*Dy)',[cellDim(1) * cellDim(2),1]);
end

end

