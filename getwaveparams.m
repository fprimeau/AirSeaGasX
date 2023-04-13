function [z0,ustar,cp]=getwaveparams(SWH,lambda)
%use function to calculate wave parameters using IceSat-2
%equations by Klotz et al (2020)

%% calculate wave paramters u*,z0,cp

%calculate sea surface roughness
%z0=Hs[1200X(Hs/Ls)^4.5
z0=SW1.*(1200*(SWH./lambda).^4.5);


%calculate cp= sqrt((g*L)/(2*pi))
g=9.81;
cp=sqrt((g.*L0_1)./(2*pi));


%calculate u*
%u*=cp*(z0/(3.35*Hs))^0.294

ustar=jj1.*((j1./(3.35.*SW1)).^(0.294));
