function faceField = cellToface_vf(mesh,field)
%�����峡�����泡,ֻ�ǵ����Ĳ�ֵ
%��Ҫ����������Ĭ��meshΪ�ṹ�����������ˣ�������
% ��飺
%��������:
%   faceField = cellToface_vf(mesh,field)
%�������
%   mesh - �������ݽṹ��
%   field - ����
%���ز���
%   faceField(faceScalarField) - ����volField��linear interpolation


global Nx Ny;
if contains(field.type,'Scalar')
%��ʼ���ڴ�
    faceField = generatefield(mesh,fieldDimension.face,fieldType.scalar);
    field_x = zeros(Ny,Nx+2);
    field_y  = zeros(Ny+2,Nx);
    field_x (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_y (2:end-1,:) = reshape(field.fields.x,[Nx,Ny])';
%����������
    faceField.fields.x = (field_x(:,1:end-1) + field_x(:,2:end))/2;
    faceField.fields.y = (field_y(1:end-1,:) + field_y(2:end,:))/2;
%�����߽�(�������м���б߽�����)
    faceField = conCorrcetBC_vf(mesh,faceField,field);

elseif contains(field.type,'Vector')
%��ʼ���ڴ�
    faceField = generatefield(mesh,fieldDimension.face,fieldType.vector);
    %xx�����ٶ�U��X������,xy�����ٶ�U��Y������
    field_xx = zeros(Ny,Nx+2);
    field_xy = zeros(Ny+2,Nx);
    %yx�����ٶ�V��X������,yy�����ٶ�V��Y������
    field_yx  = zeros(Ny,Nx+2);
    field_yy  = zeros(Ny+2,Nx);

    field_xx (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    field_xy (2:end-1,:) = reshape(field.fields.x,[Nx,Ny])';
    field_yx (:,2:end-1) = reshape(field.fields.y,[Nx,Ny])';
    field_yy (2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
    % field_xx (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    % field_xy (:,2:end-1) = reshape(field.fields.x,[Nx,Ny])';
    % field_yx (2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
    % field_yy (2:end-1,:) = reshape(field.fields.y,[Nx,Ny])';
%�������ٶȳ�
    %xx-xyά��Ҫһ�£�yx-yyά��Ҫһ��
    faceField.fields.xx = (field_xx(:,1:end-1) + field_xx(:,2:end))/2;
    faceField.fields.xy = (field_xy(1:end-1,:) + field_xy(2:end,:))/2;
    faceField.fields.yx = (field_yx(:,1:end-1) + field_yx(:,2:end))/2;
    faceField.fields.yy = (field_yy(1:end-1,:) + field_yy(2:end,:))/2;
%�����߽�(�������м���б߽�����)   
    faceField = conCorrcetBC_vf(mesh,faceField,field);
else
    error('cellToface():field.type��������');
end

end

