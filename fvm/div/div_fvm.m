function Ab = div_fvm(mesh,phi,divScheme,field)
%根据离散格式生成对流项(div)的隐式线代系统
%简介：
%输入参数
%   mesh - 网格数据结构体
%   phi - 网格面通量场
%   divSchemee - 对流项离散格式
%   field - 离散物理场
%提取边界
    field.LBC = linearBC(mesh,field); 
%生成离散算子  
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
            error('div离散格式错误');
    end
end
