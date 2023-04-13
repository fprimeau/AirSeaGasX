function [kw,Sc]=calcTransferVelocity(ustar,Beam,SST,K0)
%Use function to calculate the gas transfer velocity 
%Calculation is based on Reichl and Deike (2020)

%Kw is the sum of non-bubble (Kwnb) and bubble (Kwb) components:

%Kwnb=Anb*ustar*(Sc/660)^-(1/2)
%where Anb=1.55x10^-4 (Fairral et all (2011))
%      Sc=Schmidts number 

%and Kwb=(Ab/K0*R*T0)*ustar^(5/3)*(gHs)^(2/3)*(Sc/660)^(-1/2)
%where Ab=1 +/- 2 x10^-5 
%      R=ideal gas constant
%      T0=SST
%      g=gravity
Anb=1.55e-04; Ab= 1.02e-05; g=9.8;
R=0.08206; %units=L.atm/K.mol


%find the valid SST and SSS for each SWH point
swh=Beam(:,3); lat=Beam(:,1); lon=Beam(:,2);
Sc=[]; T0=[]; kw.nb=[];  kw.B=[]; kw.lat=[]; kw.lon=[]; kw.dt=[];
for i=1:length(swh)
    
   
    vlat= SST.lat <= lat(i)+0.7 & SST.lat >= lat(i)-0.7;
    vlat=find(vlat==1);

    vlon= SST.lon <= lon(i)+0.7 & SST.lon >= lon(i)-0.7;
    vlon=find(vlon==1);
    
    vlat2= K0.lat <= lat(i)+0.7 & K0.lat >= lat(i)-0.7;
    vlat2=find(vlat2==1);

    vlon2= K0.lon <= lon(i)+0.7 & K0.lon >= lon(i)-0.7;
    vlon2=find(vlon2==1);

    if length(vlat)>0 & length(vlon)>0 & length(vlat2)>0 &length(vlon2)>0

        k=SST.sst(vlon(1),vlat(1));
        T0=[T0; k];
        

        %calculate the schmidt number using Wanninkhof's 2014 Sc equation
        %Sc=A+Bt+Ct^2+Dt^3+Et^4 where t is SST in C

        A= 2116.8; 
        B=(-136.25).*(k); 
        C=4.7353*((k).^2); 
        D=(-0.092307)*((k).^3);
        E=0.0007555*((k).^4);

        kk=A+B+C+D+E;
        Sc=[Sc; kk];
       
        %Convert T0 from Celcius to Kelvin
        t0k=k + 273;
        %calculate kwnb

        l=Anb.*ustar(i).*((kk./660).^(-1/2)); 
        l=l*86400; %convert m/s to m/day
        l=l*0.775;
        kw.nb=[kw.nb;l]; 
       
        %calculate kwb
       
        l=(Ab./(K0.k0(i).*R.*t0k));
        ll=(ustar(i)).^(5/3);
        l2=(g.*swh(i)).^(2/3);
        ll2=(kk./660).^(-1/2);

        j=l.*ll.*l2.*ll2; 
        j=j*86400; %convert m/s tO m/day
        j=j*0.775; %calibrate k660
        kw.B=[kw.B;j];
        kw.lat=[kw.lat; lat(i)];
        kw.lon=[kw.lon; lon(i)];
        kw.dt=[kw.dt; dt(i)];

    else
        kw.B=[kw.B;NaN];
        kw.lat=[kw.lat; lat(i)];
        kw.lon=[kw.lon; lon(i)];
        kw.nb=[kw.nb;NaN];
        Sc=[Sc; nan];
        kw.dt=[kw.dt; dt(i)];

    end 

end 

kw.kw=kw.B+kw.nb;


