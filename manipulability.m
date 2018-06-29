
function m = manipulability( J, measure )
    [ U, S, ~ ] = svd( J );
    N = size( U, 1 );
    sigma = diag( S );
    switch measure
        case 'sigmamin'
            m = sigma( N );
        case 'invcond'
            m = sigma( N ) / sigma( 1 );
        case 'detjac'
            m = det( J );
         
        otherwise
            error( 'Wrong measure: %s', measure );
    end
end