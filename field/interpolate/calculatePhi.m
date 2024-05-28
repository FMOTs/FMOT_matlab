function phi = calculatePhi(mesh,phi,U,rho)
%������ͨ��
%��飺
%��������:
%   phi = calculatePhi(phi,U)
%   phi = calculatePhi(phi,U,rho)
%�������
%   mesh - ����ṹ������
%   phi - ��ͨ��������ΪfaceScalarField
%   U - �ٶȳ���������faceScalarField��volVectorField
%   rho - �����ܶȣ�Ĭ��ֵΪ1
global Nx Ny;
%�������ͼ��
if ~contains(phi.type,'faceScalarField')
    error('phi�������ʹ��󣬱���Ϊ(u)confaceScalarField');
end

if ~contains(U.type,'faceScalarField') ...
    &&~ contains(U.type,'volVectorField')
    error('U�������ʹ��󣬱���Ϊ(u)confaceScalarField��volVectorField');
end

%����Ĭ�ϲ���
if nargin == 3
    rho = 1;
end

%��ʼ��
phix = zeros(Ny,Nx+2);
phiy = zeros(Ny+2,Nx);
phix(:,2:end-1) = reshape(U.fields.x,[Nx,Ny])';
phiy(2:end-1,:) = reshape(U.fields.y,[Nx,Ny])';
%�������ٶȳ�
phi.fields.x = (phix(:,1:end-1) + phix(:,2:end))/2;
phi.fields.y = (phiy(1:end-1,:) + phiy(2:end,:))/2;
%����U.*nf
phi.fields.x = phi.fields.x .* mesh.faces.nf.x;
phi.fields.y = phi.fields.y .* mesh.faces.nf.y;
%�����߽�(�������м���б߽�����)
phi = conCorrcetBC_Sf(mesh,phi,U);
%����rho*U.*Sf(nf*|S|)
phi.fields.x = rho * phi.fields.x .* mesh.faces.areas.x;
phi.fields.y = rho * phi.fields.y .* mesh.faces.areas.y;
end

