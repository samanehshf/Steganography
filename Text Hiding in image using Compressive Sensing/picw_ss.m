function [picw_s] = picw_ss(N,M)
p = randperm(N);
picw_s = p(1:M);
for ii = 1:M
    if picw_s(ii) == 1
        picw_s(ii) = p(M+1);
        break;
    end
end

end

