function [SWHH,L,z0,cp,ustar,ll,ln,swell,wv,dt2]=getww3(SWH,lat,lon,dt,ww3_global)
%use function to get wavelength, significant wave height from WW3 
% also calculate roughness length and ustar using this function

%convert icesat2 lon by subtracting 360
lon2=lon; 
ww3_global.longitude=wrapTo180(ww3_global.longitude);
 %convert ww3 time
 ww3_global.dt=[];
 for i=1:length(ww3_global.time)
  g=datetime(1970,1,1)+seconds(ww3_global.time(i));
  ww3_global.dt=[ww3_global.dt; g];
 end 

ww3_t=squeeze(ww3_global.Tper);
ww3_swh=squeeze(ww3_global.Thgt);
ww3_swell=squeeze(ww3_global.shgt);
ww3_wind=squeeze(ww3_global.whgt);
%convert is2 and ww3 dt to datenum
if length(dt) > 0
dn_i=datenum(dt); 
dn_w=datenum(ww3_global.dt);
end 

%get the matching coordinates between the icesat2 and ww3 datasets
%Wind direction coordinates= Time X Lat X Lon
SWHH=[]; L=[]; z0=[]; cp=[]; ustar=[]; ll=[]; ln=[]; swell=[]; wv=[]; dt2=[];
if length(SWH) >0 & SWH ~= 0
for i=1:length(lat)
    v_lat=ww3_global.latitude<=lat(i)+0.5 & ww3_global.latitude>=lat(i)-0.5;
    v_lat=find(v_lat==1); 

    v_lon=ww3_global.longitude<=lon2(i)+0.5 & ww3_global.longitude>=lon2(i)-0.5;
    v_lon=find(v_lon==1);

    v_time=dn_w <= dn_i(i)+ 0.04 & dn_w >= dn_i(i)-0.04;
    v_time=find(v_time==1);
    
   
    if length(v_lat)>=1 &length(v_lon)>=1 & length(v_time)>=1
        b=v_lat(1); bb=v_lon(1); bt=v_time(1);
        if v_time(1) > 457
        bt1=[v_time(1):v_time(1)+3];
        else 
            bt1=v_time(1);
        end 
        T=ww3_t(bt,b,bb);
        pp=[];
        for i=1:length(bt1)
            a=ww3_swh(bt1(i),b,bb);

            pp=[pp;a];
        end 
        p=nanmean(pp);
        %p=ww3_swh(bt,b,bb);
        ps=ww3_swell(bt,b,bb);
        pss=ww3_wind(bt,b,bb);
        SWHH=[SWHH;p];
        swell=[swell;ps];
        wv=[wv; pss];
        dt2=[dt2; dn_w(bt)];
        %calculate wavelength, z0, cp, and ustar using the significant wave height
        %and period

        %calc peak wavelength
        %Lp=gT^2/2pi
        g=9.8;

        k=(g*T.^2)/(2*pi);
        L=[L;k];

        %calc roughness length
        kk=p.*(1200*(p./k).^4.5);
        z0=[z0;kk];

        %calc cp
        j=sqrt((g.*k)./(2*pi));
        cp=[cp;j];

        %calc ustar
        jj=j.*((kk./(3.35.*p)).^(0.294));
        ustar=[ustar;jj];


        %save the lat and lon
        ll=[ll;ww3_global.latitude(b)];
        ln=[ln;ww3_global.longitude(bb)];

    else 
        SWHH=[SWHH; NaN];
        swell=[swell;NaN];
        wv=[wv; NaN];
        L=[L;NaN];
        z0=[z0;NaN];
        cp=[cp;NaN];
        ustar=[ustar;NaN];
        ll=[ll;NaN];
        ln=[ln;NaN];
        dt2=[dt2; nan];
       
    end 
end 
else 
    SWHH=[SWHH; NaN];
    swell=[swell;ps];
    wv=[wv; pss];
    L=[L; NaN];
    z0=[z0;NaN];
    cp=[cp;NaN];
    ustar=[ustar;NaN];
    dt2=[dt2; nan];
    
end 
