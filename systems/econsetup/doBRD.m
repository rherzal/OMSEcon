function ai = doBRD(rho, xi, ao, Amax, lambdai)
    wl = 0;
    N = length(rho);
    alpharoot = 0.00001 + (rho .* (1 - xi + ao)).^(1/2);
    for n = 1:N
        ai(n,1)=max([0,alpharoot(n)/sqrt(lambdai) - 1 - ao(n) ]); % fix division by 0, not use AI
    end
    if sum(ai) > Amax  % make lambda be epsilon   
        sortkeywf=(1+ao)./alpharoot;
        [~, idx] = sort(sortkeywf);
        indics = (1:N)';
        rho = rho(idx);
        xi = xi(idx);
        ao = ao(idx);
        alpharoot = (rho .* (1 - xi + ao)).^(1/2);
        for n = N:-1:1
            ai = zeros(N,1); 
            sel = 1:n;
            mu0 = (sum(alpharoot(sel)) / (Amax + n + sum(ao(sel)))).^2 - lambdai ;
            ai(sel) = alpharoot(sel) / sqrt(mu0 + lambdai) - ao(sel) - 1;
            if sum(ai<0)>0
                succ=0;
            else
                succ=1;
                break;
            end
        end
        if sum(ai < 0) > 0
            ai=zeros(N,1);
            ai(1)=Amax;
        end 
        aiS=ai;
        for i = 1:N
            ai(i) = aiS(idx == i);
        end %resort
    else
        suc = 2;
    end
end
