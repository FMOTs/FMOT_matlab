function field = setNonBC(field)
%为非真实世界物理场建立边界,比如rhok
%   将物理场的边界全设置为zeroGradient

field = setBoundaryCondition(field,0,BCType.Neumann,BCSelect.w);
field = setBoundaryCondition(field,0,BCType.Neumann,BCSelect.e);
field = setBoundaryCondition(field,0,BCType.Neumann,BCSelect.s);
field = setBoundaryCondition(field,0,BCType.Neumann,BCSelect.n);

end

