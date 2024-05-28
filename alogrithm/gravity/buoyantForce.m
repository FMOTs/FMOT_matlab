function rhokGrad_Su = buoyantForce(gh,rhokGrad_Su)
%计算gh与物理场grad(RhoK)的乘积
%简介：
%函数重载：
%   rhokGrad_Su = buoyantForce(gh,rhokGrad_Su)
%输入参数：
%   gh - 不同水深受到的重力
%   rhokGrad_Su - boussinesq假设浮力项
%返回参数：
%   rhokGrad_Su  - boussinesq假设浮力项
 
rhokGrad_Su.b.x = gh.fields.x .* rhokGrad_Su.b.x;
rhokGrad_Su.b.y = gh.fields.x .* rhokGrad_Su.b.y;

end

