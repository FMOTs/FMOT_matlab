function Ab = upwind_vector(phi,field,mesh)
%��������һ��ӭ����ɢ������y
    global Nx Ny;
    %��ȡ��ͨ��phi
    phiSf.x = phi.fields.x;
    phiSf.y = phi.fields.y;
    %����field�ı߽���Ծ����Ӱ��
    %��ȡ�߽�
    field.LBC = linearBC(mesh,field);  
    %�߽����Ӧ����
    indexBW = mesh.faces.neigh.x(:,1);
    indexBE = mesh.faces.owner.x(:,end);
    indexBS = mesh.faces.neigh.y(1,:)';
    indexBN = mesh.faces.owner.y(end,:)';
    ALLINDEX_B = [indexBW;indexBE;indexBS;indexBN];
    %����field�߽��Դ��b��Ӱ��
    %ע�⣡div�е�field�ı߽�(1,2��)ֻ��b��Ӱ��
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
    
    % phi��own��neighת�����С�own+1��Ȼ���ٿ۵�
    phiSf.x = reshape(phiSf.x,[numel(phiSf.x),1]);
    phiSf.y = reshape(phiSf.y,[numel(phiSf.y),1]);
    %��ȡ����������������ӹ�ϵ
    [own,neigh] = getON(mesh);
    %����������Aex
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
    
    %�ظ�����Ҫ�Ż�һ��
    ALL_Y = [own.x;neigh.x;own.x;neigh.x;...
            own.y';neigh.y';own.y';neigh.y'];
    ALL_X = [own.x;neigh.x;neigh.x;own.x;...
            own.y';neigh.y';neigh.y';own.y'];
    ALLA = [fluxEp;fluxWp;fluxEe;fluxWw;...
            fluxNp;fluxSp;fluxNn;fluxSs];
    Aex = accumarray([ALL_Y,ALL_X],ALLA,[],[],[],true);
    %����A��b
    Ab.A.x = sparse(Nx*Ny,Nx*Ny);
    Ab.A.y = sparse(Nx*Ny,Nx*Ny);
    Ab.A.z = [];
    Ab.A.x = Aex(2:end,2:end);
    Ab.A.y = Aex(2:end,2:end);
    Ab.b.x = sparse(ALLINDEX_B,1,ALLS_x,Nx*Ny,1);    
    Ab.b.y = sparse(ALLINDEX_B,1,ALLS_y,Nx*Ny,1); 
    Ab.type = 'fvm::div::upwind';  
end