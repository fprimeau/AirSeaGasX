function [mu,var,n,Q] = bin2d(x,y,d,X,Y)
% [mu,var] = bin2d(x,y,z,d,derr,X,Y)
% bins data on a 2-d grid with [X,Y] coordinates
% returns mu, the mean of observations at each grid point and var, the
% variance of observations at each grid point
% X, and Y are 2-d matrices produced by meshgrid
% x and y are 1-d objects with the x, y  coordinates of the
% original data, d (also a 1-d object) 
% Missing values are assigned -9.999
% FWP: Modified from bin3d.m to bin2d.m Oct 22, 2020     
% total number of observations
    nobs = length(d);
    
    % grid size
    [ny,nx] = size(X);
    m = prod(size(X));
    
    % bin indices in the horizontal
    indx = zeros(ny,nx);
    indx(:) = 1:m;
    Q.indx = zeros(nobs,1)+NaN;
    % bin data onto grid
    ix = indx(:,:);
    Q.indx = interp2(X,Y,ix,x,y,'nearest');
    
    
    % make binning operator
    ikeep = find(~isnan(Q.indx));
    BIN = sparse(Q.indx(ikeep),ikeep,ones(length(ikeep),1),m,length(Q.indx));
    Q.BIN = BIN;
    
    % set up variables to receive binned data
    mu = zeros(ny,nx);
    n = zeros(ny,nx);
    var = zeros(ny,nx);
    % bin the data
    n(:) = Q.BIN*ones(nobs,1);
    mu(:) = Q.BIN*d./n(:);
    var(:) = (Q.BIN*(d.^2)./n(:) - mu(:).^2);
    
    % flag grid boxes without data
    mu(n==0) = -9.999;
    var(n==0) = -9.999;
    
end

