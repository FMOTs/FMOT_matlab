function Ab = div_fvm(mesh,phi,divScheme,field)
%������ɢ��ʽ���ɶ�����(div)����ʽ�ߴ�ϵͳ
%��飺
%�������
%   mesh - �������ݽṹ��
%   phi - ������ͨ����
%   divSchemee - ��������ɢ��ʽ
%   field - ��ɢ����
%��ȡ�߽�
    field.LBC = linearBC(mesh,field); 
%������ɢ����  
    switch divScheme
        case 1 
           if contains(field.type,'Scalar')
                Ab = center_scalar(phi,field,mesh);
           elseif contains(field.type,'Vector')
                Ab = center_vector(phi,field,mesh);
           end
        case 2
            if contains(field.type,'Scalar')
                Ab = upwind_scalar(phi,field,mesh);
            elseif contains(field.type,'Vector')
                Ab = upwind_vector(phi,field,mesh);
            end
        case 3 
           if contains(field.type,'Scalar')
                Ab = upwind2_scalar(phi,field,mesh);
           elseif contains(field.type,'Vector')
                Ab = upwind2_vector(phi,field,mesh);
           end
        otherwise
            error('div��ɢ��ʽ����');
    end
end
