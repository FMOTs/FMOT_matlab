function isC = checkBC(field)
%���ṹ������(Cavity)�߽�������
%�����������
if ~strcmpi(field.type,'volScalarField') ...
   && ~strcmpi(field.type,'volVectorField')...
   && ~strcmpi(field.type,'volTensorField')
    error('CheckBC()����������������ʹ���');  
end
%���߽��ʼ��
if ~isfield(field.BC,'W')
    error('����ȱ��W�߽�');  
end
if ~isfield(field.BC,'E')
    error('����ȱ��E�߽�');  
end
if ~isfield(field.BC,'S')
    error('����ȱ��S�߽�');     
end
if ~isfield(field.BC,'N')
    error('����ȱ��N�߽�');  
end
isC = 1;
end

