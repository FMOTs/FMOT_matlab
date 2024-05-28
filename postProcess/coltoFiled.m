function reField = coltoFiled(field)
    global Nx Ny;
    reField = reshape(field,[Nx,Ny]);
    reField  = reField';
end

