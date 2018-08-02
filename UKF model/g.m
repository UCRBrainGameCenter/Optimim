function [y] = g(x,u,m,r,a)
 %IRT model:
    %c = 0.2105;
    d=1;
    c=0;
    %a=1.6;
    q_plug = a*(x-u);
    q= c + (d - c)./ ( 1.0 + exp(-q_plug)); 
     pos_q = q.^r; 
    neg_q =(1-q).^(m-r);
    y=q
    %y =nchoosek(m,r).*pos_q .*neg_q;
end

