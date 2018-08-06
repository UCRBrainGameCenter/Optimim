function [res] = control_fn(r,m,a,n)

 alpha1= n*a;

 alpha2 = (1-a)*n;



 part1 = gamma(r+alpha1)*gamma(m-r +alpha2)/gamma(m+n);

 part2 = gamma(n)/(gamma(alpha1)*gamma(alpha2));

 part3 = gamma(m+1)/(gamma(r+1)*gamma(m-r+1));



 res = part1*part2*part3;



end


