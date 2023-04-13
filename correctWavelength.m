function [L0]=correctWavelength(L,lat,lon,dt,ww3_global)
 %use function to calculate the true wave length using the peak wavelength
 %and the wave direction 
 
 %L0=L'*|cos a|
 %L0=True Wavelength 
 %L'=Observed Wavelength

 %% find the lat, lon, dt of each wavelength 
 ww3_global.dt=[]; a=[]; L0=[]; Thgt=[];

 %convert ww3 time
 ww3_global.dt=[];
 for i=1:length(ww3_global.time)
  g=datetime(1970,1,1)+seconds(ww3_global.time(i));
  ww3_global.dt=[ww3_global.dt; g];
 end 

 %convert icesat2 lon by adding 360
lon2=wrapTo360(lon);

wdirec=squeeze(ww3_global.Tdir);
ww3_swh=squeeze(ww3_global.Thgt);
is_theta=92; % degrees

%get the hours from both ww3 and icesat2 
if length(dt) >0
    hour_i=hour(dt);
    hour_w=hour(ww3_global.dt);
end
%get the matching coordinates between the icesat2 and ww3 datasets
%Wind direction coordinates= Time X Lat X Lon
if length(L) > 0 
    for i=1:length(L)
        v_lat=ww3_global.latitude<=lat(i)+0.5 & ww3_global.latitude>=lat(i)-0.5;
        v_lat=find(v_lat==1);

        v_lon=ww3_global.longitude<=lon2(i)+0.5 & ww3_global.longitude>=lon2(i)-0.5;
        v_lon=find(v_lon==1);

        v_time=hour_w <= hour_i(i)+ 0.5 & hour_w >= hour_i(i)-0.5;
        v_time=find(v_time==1);

        if length(v_lat) >0 & length(v_lon)>0 & length(v_time)>0

            b=v_lat(1); bb=v_lon(1); bt=v_time(1);
            theta=wdirec(bt,b,bb);

            %calculate L0 using the trig relationship
            %calculate a by subtracting Icesat2 orbit inclination from wave
            %direction
            %a=abs(theta-is_theta);


            a=2-theta;

            n=L(i)*abs(cos(a));

            j=squeeze(ww3_global.Tper);
            jj=j(bt,b,bb);
            jjj=(9.8*(jj).^2)/(2*pi);

            if length(n) > 0
                L0=[L0; n(1)];
            end

            %get the SWH to compare
            bbb=ww3_swh(bt,b,bb);

            if length(b) > 0
                Thgt=[Thgt; b(1)];
            end
        end
    end
else 
    L0=[L0; NaN];
    Thgt=[Thgt; NaN]; 

end

end 


