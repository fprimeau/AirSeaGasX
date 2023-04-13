function [K0]=calcSolubility(Beam,SST,SSS)
%use function to calculate the solubilty at every significant wave height 

%Solubility Equation is derived from Reichle and Deike (2020)

%ln(K0)=a1+a2(100/T0)+a3*ln(T0/100)+S0(b1+b2(T0/100)+b3(t0/100)^2)
%a1 a2 a3 b1 b2 b2 are coefficients
%T0 is the sea surface salinity in Kelvin 
%S0 is the surface salinity in g/kg

% convert SST from celcius to Kelvin 

sst_k=SST.sst +273;


%write out coefficients
a1=-58.0931; a2=90.5069; a3=22.2940;
b1=0.027766; b2=-0.025888; b3=0.0050578; 

K0.k0=[]; K0.lat=[]; K0.lon=[];  K0.SST=[]; K0.sss=[];
%find the valid SST and SSS for each SWH point
swh=Beam(:,3); lat=Beam(:,1); lon=Beam(:,2);
for i=1:length(swh)
    
    %get valid SST points
    vlat= SST.lat <= lat(i)+0.5 & SST.lat >= lat(i)-0.5;
    vlat=find(vlat==1);

    vlon= SST.lon <= lon(i)+1 & SST.lon >= lon(i)-1;
    vlon=find(vlon==1);

    if length(vlat) > 0 & length(vlon) > 0
     
        T0=sst_k(vlon(1),vlat(1));
        %T0=mean(sst_k,'all');
        K0.SST=[K0.SST; T0];
    else
        T0=[];
        K0.SST=[K0.SST; nan];
    end 

    %get valid SSS points

    vlat= SSS.lat <= lat(i)+0.5 & SSS.lat >= lat(i)-0.5;
    vlat=find(vlat==1);

    vlon= SSS.lon <= lon(i)+1 & SSS.lon >= lon(i)-1;
    vlon=find(vlon==1);
    
    if length(vlat) > 0 & length(vlon) > 0
        S0=SSS.sss(vlat(1),vlon(1));
    end
    

    if length(vlat) > 0 & length(vlon) > 0

        if length(T0) >0 & length(S0) >0
            %calc K0 using equation above
            j1=a1;
            j2=(a2.*(100./T0));
            j3=(a3.*log(T0./100));
            j4=(b1+(b2.*(T0./100)))+(b3.*((T0./100).^2));
            j5=S0*j4;
            %jj=a1+(a2.*(100./T0))+(a3.*log(T0./100))+(S0.*(b1+b2.*(T0./100))+(b3.*((T0./100).^2)));
            jj=j1+j2+j3+j5;
            jj=exp(jj);
            K0.k0=[K0.k0;jj];
            K0.lat=[K0.lat; SSS.lat(vlat(1))];
            K0.lon=[K0.lon; SSS.lon(vlon(1))];
            K0.sss=[K0.sss; S0];
        else
            K0.k0=[K0.k0;NaN];
            K0.lat=[K0.lat; NaN];
            K0.lon=[K0.lon; NaN];
            K0.sss=[K0.sss; NaN];
            
        end
    else 
        K0.k0=[K0.k0;NaN];
        K0.lat=[K0.lat; NaN];
        K0.lon=[K0.lon; NaN];
        K0.sss=[K0.sss; NaN];
    end 
    T0=[]; S0=[];
end 




