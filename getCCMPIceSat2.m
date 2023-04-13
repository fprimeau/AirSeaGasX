function [j]=getCCMPIceSat2(lat,lon,Icelat,Icelon,wind)
%Get the collocated and simultaenous wind speeds for CCMP and IceSat2
%Step 1:Extract the data based on location 
j.lat=[]; j.lon=[]; j.wspd=[]; j.dt=[];
Icelon=wrapTo360(Icelon); 
l=find(Icelon < 360);
Icelon=Icelon(l);
Icelat=Icelat(l);

for i=1:length(Icelat)
    jlat=Icelat(i);
    jlon=Icelon(i); 
     %get the CCMP lats
     n= lat<=jlat+0.25 & lat >=jlat-0.25;
     nn=find(n==1); 
     
     m= lon<=jlon+0.25 & lon >=jlon-0.25;
     mm=find(m==1); 
    
     if length(mm) > 0 && length(nn) > 0
         nnn=lat(nn(1)); j.lat=[j.lat;nnn];
         mmm=lon(mm(1));
         j.lon=[j.lon;mmm];

         hhh=wind(mm(1),nn(1));
         j.wspd=[j.wspd;hhh];
     end 
  
end 