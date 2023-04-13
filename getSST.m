function [SST]=getSST(latmin,latmax,lonmin,lonmax,timemin,timemax,lat,lon,time,sst)
%use function to get monthly mean SST data from reanalysis file
SST.sst=[]; SST.lat=[]; SST.lon=[];

lons=lonmin:lonmax; lats=latmin:latmax;
%convert the lonmin and lonmax
lons=wrapTo360(lons);

%convert time to datenum

%get the valid sst points

vtime= sst.dn >= timemin-1 & sst.dn <= timemax +7;
vtime=find(vtime ==1);

%get valid lat & lon points
latss=[];
for i=1:length(lats)
    vlat=lat <= lats(i)+1 & lat >= lats(i)-1;
    vlat=find(vlat == 1);
    if length(vlat) > 1
        latss=[latss; vlat(1)];
    else
        latss=[latss; nan];
    end
end
lonss=[];
for i=1:length(lons)
    vlon=lon <= lons(i)+1 & lon >= lons(i)-1;
    vlon=find(vlon ==1);
    if length(vlon) >1
       
        lonss=[lonss; vlon(1)];
    else
        lonss=[lonss; nan];
    end
end

SST.sst=sst(lonss,latss,vtime(1));
SST.lat=lat(latss); SST.lon=lon(lonss);

%convert SSS.lon back to -180/180 
SST.lon=wrapTo180(SST.lon)
end 

