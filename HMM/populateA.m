function [A] = populateA(theta,nb_prev,bin_acc)
N = 12;
A = zeros(N,N);
    for i=1:N
        if i>1
            A(i,i-1) = theta(1,(i-1)-nb_prev+12,bin_acc);%lower diagonal
        end
        A(i,i) = theta(2,i-nb_prev+12,bin_acc);
        if i<N
            A(i,i+1) = theta(3,(i+1)-nb_prev+12,bin_acc);%upper diagonal
        end
    end
    
    A_s = sum(A,2);
    for i=1:N
        if(all(A(i,:) == 0) == 1)
            continue;
        end
        A(i,:) = A(i,:)./A_s(i); %So that the rows sum up to 1
    end
end

