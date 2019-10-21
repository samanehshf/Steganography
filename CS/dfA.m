 function y = dfA(x,picw_s,perm,mode)
 switch mode
    case 1
        y = A_fWH(x,picw_s,perm);    %function for compressive sensing
    case 2
        y = At_fWH(x,picw_s,perm);   %function for recounstruct and create original signal
    otherwise
        error('Unknown mode passed to f_handleA!');
 end
