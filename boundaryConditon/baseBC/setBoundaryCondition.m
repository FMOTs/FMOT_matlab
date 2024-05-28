function field = setBoundaryCondition(field,value,bctype,bcSelect)
%�ṹ����(cavity)�������߽�������ʼ��
%   �˴���ʾ��ϸ˵��
    switch bctype
        case 1
            type = 'Dirichlet';
        case 2
            type = 'Neumann';
        otherwise
            error('�����߽�������ʼ��ʧ�ܣ�Ŀǰ����дDirichlet��Neumann');   
    end

    switch bcSelect
        case 1
            field.BC.W.type = type;
            field.BC.W.value = value;
        case 2
            field.BC.E.type = type;
            field.BC.E.value = value;
        case 3
            field.BC.S.type = type;  
            field.BC.S.value = value;
        case 4
            field.BC.N.type = type;     
            field.BC.N.value = value;
        otherwise
            error('�����߽�������ʼ��ʧ�ܣ�Ŀǰ����дDirichlet��Neumann');
    end
end

