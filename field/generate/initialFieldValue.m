function field = initialFieldValue(field,varargin)
%��ʼ��������ֵ
%��飺
%��������:
%   field = initialFieldValue(field) 
%   field = initialFieldValue(field,field2) 
%   field = initialFieldValue(field,value) 
%�������
%   field - ����ʼ��������
%   field2 - �����Ƶ���������field��ֵ��Ϊfield2
%            field2��ά�ȱ�����field��ͬ
%   value - ��ʼ����ֵ���ֳ�scalar��vector�������
%         - scalar����valueΪ1��ֵʱ����field�����з���ĳ�ȫ����ʼ��Ϊvalue
%         - vector����value(x,y,z)Ϊ����ʱ����field��Ӧ����ĳ���ʼ��Ϊvalue
%         - default����value������ʱ��Ĭ��value = 0�����������е�ֵ���
if contains(field.type,'Scalar')
    field.fields.x(:) = 0;
end

if contains(field.type,'Vector')
    field.fields.x(:) = 0;
    field.fields.y(:) = 0;
    field.fields.z(:) = 0;
end

if nargin > 1 && ~isnumeric(varargin{1})
    if contains(field.type,'Scalar')
        dim1 = numerl(field.fields.x);
        dim2 = numerl(varargin{1}.fields.x);
        if dim1 ~= dim2
            error('initialFieldValue()����ĸ��������뱻��ʼ������ά�Ȳ�ͬ');
        end
        field.fields.x = varargin{1}.fields.x;
    end
    if contains(field.type,'Vector')
        dim1.x = numerl(field.fields.x);
        dim1.y = numerl(field.fields.x);
        dim1.z = numerl(field.fields.x);
        dim2.x = numerl(varargin{1}.fields.x);
        dim2.y = numerl(varargin{1}.fields.y);
        dim2.z = numerl(varargin{1}.fields.z);
        if dim1.x ~= dim2.x || dim1.y ~= dim2.y || dim1.z ~= dim2.z
            error('initialFieldValue()����ĸ��������뱻��ʼ������ά�Ȳ�ͬ');
        end
        field.fields.x = varargin{1}.fields.x;
        field.fields.y = varargin{1}.fields.y;
        field.fields.z = varargin{1}.fields.z;
    end
end

if nargin > 1 && isnumeric(varargin{1})
    if contains(field.type,'Scalar')
        field.fields.x(:) = varargin{1}(1);
    end
    if contains(field.type,'Vector')
        field.fields.x(:) = varargin{1}(1);
        field.fields.y(:) = varargin{1}(2);
        field.fields.z(:) = varargin{1}(3);
    end    
end

end

