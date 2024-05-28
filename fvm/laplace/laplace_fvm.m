function Ab = laplace_fvm(mesh,k,laplaceScheme,field)
%������ɢ��ʽ����������˹��(laplacian)����ʽ�ߴ�ϵͳ
%��飺
%�������
%   mesh - �������ݽṹ��
%   k - ��ɢϵ��/�����ʵ�
%   laplaceScheme - ������˹����ɢ��ʽ
%   field - ��ɢ����

  global Nx Ny;
  if laplaceScheme ~= 1
      error('laplacian��ɢ��ʽ����Ŀǰ��֧��Gauss������ɢ');
  end
 %��ȡ�߽�
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
      error('�������ݽṹ���ʹ���Ŀǰ��֧�ֽṹ�ͷǽṹ����)')
    end

end

