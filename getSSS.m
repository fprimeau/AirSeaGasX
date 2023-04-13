function [SSS]=getSSS(latmin,latmax,lonmin,lonmax,timemin,timemax,lat,lon,sss)
%use function to get sea surface salinity 
SSS.sss=[]; SSS.lat=[]; SSS.lon=[];
%find the valid lats and lons 



%get the lats
% vlat1=find(lat >= latmin-1);
% vlat2=find(lat <= latmax+1);
% 
% vlat=intersect(vlat1,vlat2);
% 
% %get the lons
% vlon1=find(lon >= lonmin-1);
% vlon2=find(lon <= lonmin+1);
% 
% vlon=intersect(vlon1,vlon2);

% vlat=lat >= latmin+0.1 & lat <= latmax-0.1; 
% vlat=find(vlat == 1);
% 
% vlon=lon <= lonmin+1 & lon >= lonmax-1;
% vlon=find(vlon ==1);

% vlat=[176:353]; %IS2 lims
% vlon=[488:608];

vlat=[152:365]; % WW3 lims
vlon=[492:621];

SSS.sss=sss(1,vlon,vlat);
SSS.lat=lat(vlat); SSS.lon=lon(vlon);
end 