function mass = calMass(mesh,U)
%根据速度场计算质量源项

global Nx Ny;
%计算Uf(faceVectorField)
    Uf = cellToface_vf(mesh,U);
%计算质量源项
    mass = div_fvc(mesh, Uf);
    mass.type = 'fvc::div::gauss';
end

