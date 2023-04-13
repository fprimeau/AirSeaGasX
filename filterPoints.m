function [phf,distf,latf,lonf,dtf]=filterPoints(ph,dist,lat,lon,dt)
%use function to filter points so that its +/- 3 sigma from mean for every
%10 m 

k=1;
bin=10e3:10e3:1e5;
phf=[]; distf=[]; latf=[]; lonf=[]; dtf=[];
for i=1:length(bin)
     x=[]; y=[]; z=[]; zz=[]; tt=[];
    while dist(k) < bin(i) & k<length(dist)
        y=[y; ph(k)];
        x=[x; dist(k)];
        z=[z; lat(k)];
        zz=[zz; lon(k)];
        tt=[tt; dt(k)];
        k=k+1;
    end

    meany=mean(y);
    sig3=3*std(y);
    upperbound=meany+sig3;
    lowerbound=meany-sig3;
%     figure(888)
%     plot(x,y,'.k')
% 

for i=1:length(y)
    if y(i) <= upperbound & y(i) >= lowerbound
        phf=[phf; y(i)];
        distf=[distf; x(i)];
        latf=[latf; z(i)];
        lonf=[lonf; zz(i)];
        dtf=[dtf; tt(i)];
    end
end


end 