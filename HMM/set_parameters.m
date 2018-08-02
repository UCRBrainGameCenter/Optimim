function [A1,Pi1,A2,Pi2,A3,Pi3,A4,Pi4] = set_parameters()
    N=12;
    A1 = zeros(N,N);
    A2 = zeros(N,N);
    A3 = zeros(N,N);
    A4 = zeros(N,N);
    
    Pi1 = rand(N,1); % Pi ~ 1/N
    Pi1= Pi1./sum(Pi1);
     for i=1:N
        if i>1
            A1(i,i-1) = 1/3;%lower diagonal
        end
        A1(i,i) = 1/3;
        if i<N
            A1(i,i+1) = 1/3;%upper diagonal
        end
     end
    
    Pi2 = rand(N,1); % Pi ~ 1/N
    Pi2= Pi2./sum(Pi2);
     for i=1:N
        if i>1
            A2(i,i-1) = 0.2;%lower diagonal
        end
        A2(i,i) = 0.6;
        if i<N
            A2(i,i+1) = 0.2;%upper diagonal
        end
     end
    
     Pi3 = rand(N,1); % Pi ~ 1/N
    Pi3= Pi3./sum(Pi3);
     for i=1:N
        if i>1
            A3(i,i-1) = 0.6;%lower diagonal
        end
        A3(i,i) = 0.2;
        if i<N
            A3(i,i+1) = 0.2;%upper diagonal
        end
    end
    
      Pi4 = rand(N,1); % Pi ~ 1/N
    Pi4= Pi4./sum(Pi4);
     for i=1:N
        if i>1
            A4(i,i-1) = 0.2;%lower diagonal
        end
        A4(i,i) = 0.2;
        if i<N
            A4(i,i+1) = 0.6;%upper diagonal
        end
    end
end

