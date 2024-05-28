function Ab = laplace_fvm(mesh,k,laplaceScheme,field)
%根据离散格式生成拉普拉斯项(laplacian)的隐式线代系统
%简介：
%输入参数
%   mesh - 网格数据结构体
%   k - 扩散系数/导热率等
%   laplaceScheme - 拉普拉斯项离散格式
%   field - 离散物理场

  global Nx Ny;
  if laplaceScheme ~= 1
      error('laplacian离散格式错误，目前仅支持Gauss线性离散');
  end
 %提取边界
    field.LBC = linearBC(mesh,field);  
    if strcmpi(mesh.type,'construct')
        if contains(field.type,'Scalar')
            Ab = lap_center_scalar(k,field,mesh);
        elseif contains(field.type,'Vector')
            Ab = lap_center_vector(k,field,mesh);
        end
    elseif strcmpi(mesh.type,'unconstruct')
        field.LS = generateLapAb_uc(k,field,mesh);
    else
      error('网格数据结构类型错误，目前仅支持结构和非结构网格)')
    end

end

