function [d,ccmp]=CCMP_IceSat2(latmin,latmax,lonmin,lonmax)
d.lat=[]; d.lon=[]; d.wspd=[];d.time=[];d.dirname=[];d.fname=[]; d.uwind=[];
d.vwind=[]; ccmp.lon=[]; ccmp.lat=[]; ccmp.wind1=[]; ccmp.wind2=[]; ccmp.wind3=[]; 
ccmp.wind4=[]; ccmp.direc1=[]; ccmp.direc2=[]; ccmp.direc3=[]; ccmp.direc4=[];
ccmp.u1=[]; ccmp.u2=[]; ccmp.u3=[]; ccmp.u4=[]; ccmp.v1=[]; 
ccmp.v2=[]; ccmp.u3=[]; ccmp.u4=[];

cd('G:\Shared drives\CALIPSO data\Southern Ocean\CCMP')
direc=dir('*.nc');
 for j=1:length(direc) %get data from each file
     %disp(['working on...' scat_dir(j).name]);
     %fname={direc(j).name}; %file name as cell array
     ccmp_lon=ncread(direc(j).name,'longitude');
     ccmp_lat=ncread(direc(j).name,'latitude');
     ccmp_time=ncread(direc(j).name,'time');
     ccmp_uwind=ncread(direc(j).name,'uwnd');
     ccmp_vwind=ncread(direc(j).name,'vwnd');

     %convert the lonmin and lonmax
%      lonmin=lonmin+360; lonmax=lonmax+360;
     ccmp_lon=wrapTo180(ccmp_lon);
     %get datenum and datetime
     d.datenum=[];
     for i=1:length(ccmp_time)
         d.datenum(i,:)=addtodate(datenum(1987,1,1),fix(ccmp_time(i,:)),'hour');
     end
     d.datenum=d.datenum';
     dt=datetime(d.datenum,'ConvertFrom','datenum');
     
     %%get the data from two time dimensions and then average
     %average two vectors from uwind and vwnd
     uwnd1=squeeze(ccmp_uwind(:,:,1));
     uwnd2=squeeze(ccmp_uwind(:,:,2));
     uwnd3=squeeze(ccmp_uwind(:,:,3));
     uwnd4=squeeze(ccmp_uwind(:,:,4));
     
     vwnd1=squeeze(ccmp_vwind(:,:,1));
     vwnd2=squeeze(ccmp_vwind(:,:,2));
     vwnd3=squeeze(ccmp_vwind(:,:,3));
     vwnd4=squeeze(ccmp_vwind(:,:,4));
     
     
     wind1=sqrt(uwnd1.^2+vwnd1.^2); %calculate wind speed for first one
     wind2=sqrt(uwnd2.^2+vwnd2.^2);
     wind3=sqrt(uwnd3.^2+vwnd3.^2);
     wind4=sqrt((uwnd4.^2)+(vwnd4.^2));

     %% calculate the wind direction

     wind_direc1=(180/pi).*atan2((uwnd1./wind1),(vwnd1./wind1));
     wind_direc2=(180/pi).*atan2((uwnd2./wind2),(vwnd2./wind2));
     wind_direc3=(180/pi).*atan2((uwnd3./wind3),(vwnd3./wind3));
     wind_direc4=(180/pi).*atan2((uwnd4./wind4),(vwnd4./wind4)); 

     %calculate wind speedsfor every point
     %wspd=(wind1+wind2+wind3+wind4)/4;
     
     %find if scat lon and lat are valid and where
     v_lat=ccmp_lat<=latmax+1 & ccmp_lat >=latmin-1;
     v_lat=find(v_lat==1); ccmp.lat=ccmp_lat(v_lat);
     
     v_lon=ccmp_lon<=lonmax+1 & ccmp_lon >=lonmin-1;
     v_lon=find(v_lon==1);
     ccmp.lon=ccmp_lon(v_lon);
     
     %extract the wind speeds for specific region
     %wspd dimensions is lonxlat so flip
     wind1=wind1(v_lon,v_lat); wind_direc1=wind_direc1(v_lon,v_lat);
     wind2=wind2(v_lon,v_lat); wind_direc2=wind_direc2(v_lon,v_lat);
     wind3=wind3(v_lon,v_lat); wind_direc3=wind_direc3(v_lon,v_lat);
     wind4=wind4(v_lon,v_lat); wind_direc4=wind_direc4(v_lon,v_lat);

     uwnd1=uwnd1(v_lon,v_lat); vwnd1=vwnd1(v_lon,v_lat);
     uwnd2=uwnd2(v_lon,v_lat); vwnd2=vwnd2(v_lon,v_lat);
     uwnd3=uwnd3(v_lon,v_lat); vwnd3=vwnd3(v_lon,v_lat);
     uwnd4=uwnd4(v_lon,v_lat); vwnd4=vwnd4(v_lon,v_lat);
     %create 3 dimensional matrix of lat lon with time
     %so (lat x lon x time) dimensions
     ccmp.wind1(:,:,j)=wind1; ccmp.direc1(:,:,j)=wind_direc1;
     ccmp.wind2(:,:,j)=wind2; ccmp.direc2(:,:,j)=wind_direc2;
     ccmp.wind3(:,:,j)=wind3; ccmp.direc3(:,:,j)=wind_direc3;
     ccmp.wind4(:,:,j)=wind4; ccmp.direc4(:,:,j)=wind_direc4;

     % save the u and v components to plot wind direction 
     ccmp.u1(:,:,j)=uwnd1; ccmp.v1(:,:,j)=vwnd1;
     ccmp.u2(:,:,j)=uwnd2; ccmp.v2(:,:,j)=vwnd2;
     ccmp.u3(:,:,j)=uwnd3; ccmp.v3(:,:,j)=vwnd3;
     ccmp.u4(:,:,j)=uwnd4; ccmp.v4(:,:,j)=vwnd4;
     %transpose the winds
     %                 wind1=pagetranspose(wind1);
     %                 wind2=pagetranspose(wind2);
     %                 wind3=pagetranspose(wind3);
     %                 wind4=pagetranspose(wind4);
     %Get windspeeds for valid lat and lon
     d.lat=ccmp.lat;
     d.lon=ccmp.lon;
     d.time=[d.time;dt];
     

save('ccpwind_2018.mat','d')  
 end
end 