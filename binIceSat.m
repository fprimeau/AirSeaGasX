function [mu,var,n,Q,dt,dn]=binIceSat(k1,k2,k3,lat1,lat2,lat3,lon1,lon2,lon3,dt1,dt2,dt3)
%Use function to bin monthly averages for ICESat-2 data

%categorize the data based on datetime
[y1,m1]=ymd(dt1); [y2,m2]=ymd(dt2); [y3,m3]=ymd(dt3); 

%Get the groups 
G=findgroups(y1,m1);

%get the averages of all beams and then bin the data

[X,Y]=cdtgrid(2); %create a 2x2 degree grid
mu=[]; var=[]; n=[]; Q=[]; dt=[]; dn=[];
for i=1:max(G)

   idx=find(G == i);

   s(:,1)=k1(idx); s(:,2)=k2(idx); s(:,3)=k3idx);
   lat=lat1(idx); lon=lon1(idx);
   smean=mean(s,2);

   %bin the data
   %[gd]=griddata(lon,lat,smean,X,Y);
   [m,va,n1,Q1] = bin2d(lon,lat,smean,X,Y);

   %grid_data(:,:,i)=gd;
   mu(:,:,i)=m;
   var(:,:,i)=va;
   n=(:,:,i)=n1;
   Q(:,:,i)=Q;

   dt(i)=datetime(y(idx),m(idx),1,0,0,0);
   dn(i)=datenum(dt(i));

   clear s smean m va n1 Q1 gd

end 


   

