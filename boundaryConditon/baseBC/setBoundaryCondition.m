function field = setBoundaryCondition(field,value,bctype,bcSelect)
%结构网格(cavity)的物理场边界条件初始化
%   此处显示详细说明
    switch bctype
        case 1
            type = 'Dirichlet';
        case 2
            type = 'Neumann';
        otherwise
            error('物理场边界条件初始化失败，目前仅编写Dirichlet和Neumann');   
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
            error('物理场边界条件初始化失败，目前仅编写Dirichlet和Neumann');
    end
end

