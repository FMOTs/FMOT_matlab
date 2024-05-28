function mesh = ConstuctMesh(cellDim,varargin)
%����cavity�������ݽṹ��
%��飺
%�������أ�
%   mesh = ConstuctMesh(cellDim)
%   mesh = ConstuctMesh(cellDim, physDim)
%���������
%   cellDim - ����������Ϊ1��2������������������񻮷���Ŀ��
%   physDim - ��������cellDimά�ȱ��뱣��һ�£���������ʵ�ߴ磬
%             Ĭ��ֵ = cellDim    
%���ز�����
%   mesh - �ṹ�������ݽṹ��
%          ����������
%               - mesh.cells.centroids(��������������)
%               - mesh.cells.v(���������)
%               - mesh.cells.index(�������������)
%               - mesh.cells.number(����Ԫ����)
%               - mesh.cells.index(�������������)
%               - mesh.faces.centroids(��������������)
%               - mesh.faces.areas(���������)
%               - mesh.faces.nf(�����浥λ�淨����)
%               - mesh.faces.number(����������)
%               - mesh.faces.owner(������own���)
%               - mesh.faces.neigh(������neighbour���)
%               - mesh.faces.index(�������������)
%               - mesh.points.coordinate(���������)
%               - mesh.points.number(���������)
%               - mesh.dim(�����ά��)
%               - mesh.type(���������)

%������̣���֤����ά��Ϊ����
if ~all(cellDim > 0)
   error('CELLDIM ����Ϊ����');
end
%��ȡ����ά��(Ĭ�ϲ���)
physDim = cellDim;
%��������ά��
if nargin > 1 && isnumeric(varargin{1})
   physDim  = varargin{1};
end
mesh = generateConstructMesh(cellDim,physDim);


function mesh = generateConstructMesh(cellDim,physDim)
%��������
    mesh.dim = numel(cellDim);   
    switch  mesh.dim
    case 1
        %����points
        mesh.points = calculatePoints1D(cellDim,physDim);
        %����faces
        mesh.faces = calculateFaces1D(mesh.points);
        %����cells
        mesh.cells = calculateCells1D(cellDim,physDim);
    case 2
        %����points
        mesh.points = calculatePoints2D(cellDim,physDim);
        %����faces
        mesh.faces = calculateFaces2D(mesh.points,cellDim);
        %����cells
        mesh.cells = calculateCells2D(cellDim,physDim);
    otherwise
        error('����ά�ȴ���/����δʵ�֣���ǰ��������ά�� = %d', dim);
    end
    mesh.type = 'construct';
end

function points = calculatePoints1D(cellDim,physDim)
%���������1D(points)�������
    points.coordinate = linspace(0, physDim(1), cellDim(1)+1)';
    points.number = size(points.coordinate,1);
end

function points = calculatePoints2D(cellDim,physDim)
%���������2D(points)�������
    px = linspace(0, physDim(1), cellDim(1)+1);
    py = linspace(0, physDim(2), cellDim(2)+1);
%��������x,y����
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
%����������1D(faces)�������
    faces.centroids = points.coordinate;
    faces.areas = ones(1,points.number);
    faces.index = linspace(1,points.number,points.number);
    faces.number = points.number;
end

function faces = calculateFaces2D(points,cellDim)
%����������2D(faces)�������
%�ȴ���x�����face
    faces.centroids = [];
    faces.areas = [];
    %���������
    px = linspace(0, physDim(1), cellDim(1)+1);
    py = linspace(0, physDim(2), cellDim(2)+1);
    %��������
    pdx = (px(2:1:end) - px(1:1:end-1));
    pdy = (py(2:1:end) - py(1:1:end-1));
    %������������
    cx = linspace(0,physDim(1),2*cellDim(1)+1);
    cx = cx(2:2:end);
    cy = linspace(0,physDim(2),2*cellDim(2)+1);
    cy = cy(2:2:end);
    %����ά��
    Nx = cellDim(1);
    Ny = cellDim(2);
    %��ʼ�����
    A.x = ones(Ny,Nx + 1);
    A.y = ones(Ny+1,Nx);
    %����face���
    %��.*A��֤ÿһ�ж�Ӧ���
    faces.areas.x = pdy' .* A.x;
    %��.*A��֤ÿһ�ж�Ӧ���
    faces.areas.y = pdx .* A.y;
    %����face��������
    [faces.centroids.X.x,faces.centroids.X.y] = meshgrid(px,cy);  
    [faces.centroids.Y.x,faces.centroids.Y.y] = meshgrid(cx,py);  
    %��ʼ����λ�淨����
    faces.nf.x = ones(Ny,Nx + 1);
    faces.nf.y = ones(Ny+1,Nx);
    %������λ�淨����
    faces.nf.x(:,1) = -1;
    faces.nf.y(1,:) = -1;
    %������λ�淨����
    faces.number = sum(numel(faces.nf.x) + numel(faces.nf.y));
    %����own��neigh
    CINDEX = zeros(Nx+2,Ny+2);
    CINDEX(2:Nx+1,2:Ny+1) = reshape(1:Ny*Nx,[Nx,Ny]);
    CINDEX = CINDEX';
    faces.owner.x = CINDEX(2:Ny+1,1:Nx+1);
    faces.neigh.x = CINDEX(2:Ny+1,2:Nx+2);
    faces.owner.y = CINDEX(1:Ny+1,2:Nx+1);
    faces.neigh.y = CINDEX(2:Ny+2,2:Nx+1);
end

function cells = calculateCells1D(cellDim,physDim)
%����������1D(cells)�������
    px = linspace(0, physDim(1), cellDim(1)+1);
    cx = linspace(0,physDim(1),2*cellDim(1)+1); 
    cells.centroids = cx(2:2:end);
    cells.number = cellDim;
    cells.v = px(2:end) - px(1:end-1);
end

function cells = calculateCells2D(cellDim,physDim)
%����������2D(cells)�������
    cx = linspace(0,physDim(1),2*cellDim(1)+1);
    cx = cx(2:2:end);
    cy = linspace(0,physDim(2),2*cellDim(2)+1);
    cy = cy(2:2:end);
%��������x,y����
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
    %�����������
    px = linspace(0, physDim(1), cellDim(1)+1);
    py = linspace(0, physDim(2), cellDim(2)+1);
    dx = px(2:end) - px(1:end-1);
    dy = py(2:end) - py(1:end-1);
    [Dx,Dy] = meshgrid(dx,dy);
    cells.v = reshape((Dx.*Dy)',[cellDim(1) * cellDim(2),1]);
end

end

