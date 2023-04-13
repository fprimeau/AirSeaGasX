function [mu,var,n,Q,dt,dn]=binMonthly(k,lat,lon,dt)

[y1,m1]=ymd(dt1); [y2,m2]=ymd(dt2); [y3,m3]=ymd(dt3); 

%Get the groups 
G=findgroups(y1,m1);


[X,Y]=cdtgrid(2); %create a 2x2 degree grid
mu=[]; var=[]; n=[]; Q=[]; dt=[]; dn=[];
for i=1:max(G)

   idx=find(G == i);

   s(:,1)=k1(idx); 
   lat=lat1(idx); lon=lon1(idx);
   

   %bin the data
   %[gd]=griddata(lon,lat,smean,X,Y);
   [m,va,n1,Q1] = bin2d(lon,lat,s,X,Y);

   %grid_data(:,:,i)=gd;
   mu(:,:,i)=m;
   var(:,:,i)=va;
   n=(:,:,i)=n1;
   Q(:,:,i)=Q;

   dt(i)=datetime(y(idx),m(idx),1,0,0,0);
   dn(i)=datenum(dt(i));

   clear s smean m va n1 Q1 gd

end 
