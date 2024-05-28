function [own,neigh] = getON(mesh)
%��ȡ�����owner��neigh
%   �˴���ʾ��ϸ˵��
    own.x = reshape(mesh.faces.owner.x,[numel(mesh.faces.owner.x),1]);
    own.y = reshape(mesh.faces.owner.y,[numel(mesh.faces.owner.y),1]);
    neigh.x = reshape(mesh.faces.neigh.x,[numel(mesh.faces.neigh.x),1]);
    neigh.y = reshape(mesh.faces.neigh.y,[numel(mesh.faces.neigh.y),1]); 
    %ȫ��+1������������
    own.x = own.x + 1;
    own.y = own.y' + 1;
    neigh.x = neigh.x + 1;
    neigh.y = neigh.y' + 1;
end