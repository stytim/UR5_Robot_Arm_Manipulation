function mu=manipulability(J,measure)
s=svd(J);
switch measure
    case 'sigmamin'
        mu=s(end);
    case 'detjac'
        mu=det(J);
    case 'invcond'
        mu=min(s)/max(s);
    otherwise
        disp('Wrong input, please choose from sigmamin, detjac and invcond.')
end

