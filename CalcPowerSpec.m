function[H,PM,PowerSpec]=CalcPowerSpec(hc,dist,std_h,wind)
%% Calculate the wave spectrum using a General Fourier Transform 
%% use methods by Hell and Horvat (2022) and Kachelein (2022)

%% Wave Spectrum can be modeled using equation
% b = Hp + r

%% Zeroeth Step: Get Variables for equations below
dx=round(median(diff(dist)));
T=[6:40]; %seconds
T_max       = 40 %seconds
k_0         = (2 * pi/ T_max).^2 / 9.81;
min_datapoint =  2*pi/k_0/dx;

Lpoint=round(min_datapoint)*10;
Lmeters=Lpoint/dx;

%get F
N=length(hc);
df=1./((N-1)*dx);

s=(-1)^N;

if s== -1
   F= df*(((N-1)/2)+ 1 );
else
   F = df*(N/2+1);
end 

F=1./T;

%% First Step : Build H matrix (regressor matrix)

% H = [sin(2*pi*F(1)*T) cos(2*pi*F(1)*T) ... ]

H = zeros(length(T),2*length(F));

for i = 1:length(F)
    H(:,2*i - 1) = sin(2*pi*F(i)*T);
    H(:,2*i    ) = cos(2*pi*F(i)*T);
end


%% Second Step: Build R matrix (data prior)
% R=Br*std(b)^2*(std(h)/dx)
%where std(h) = standard deviation of each stencil 
%      std(b)= standard deviation of the data 
%      dx= length of each stencil

%set up variables
Br=10^2; %based on Hell & Horvat (2022) value

std_b=std(hc); 

R=Br*(std_b).^2*(std_h/20);


%% Third Step: Build P matrix (data prior)
%P matrix based on PM Spectrum (Hell & Horvat 2022)

%Calc U19.5
%U19=U10*1.026
wind=mean(wind.wind1(:));
u19=wind.*1.026;
% for i =1:length(wind)
%     u19(i)=wind(i)*1.026;
% end

%add the constants
g=9.8;
w0=g/u19; w=2*pi*F;
alpha=8.1E-3*g; beta=0.74*(g/u19)^2; 

%calculate the PM Spectrum 
PM=[];
for k=1:1:length(F)
    Sa=alpha*F(k)^(-5)*exp(-beta/(F(k)^4));
    PM=[PM;Sa];
end


%% Third Step: Calc b_hat 
%b_hat=((H^T*R*H + (1/P))H^T*(1/R)*b

HRH=(H.^T).*R.*H; HRb=(H.^T).*(1/R).*hc;

b_hat=(HRH+(1/P)).*HRb;

%% 4th Step: Calc Z 

M=length(PM);
%matrix of wavenumbers
Nc=Lmeters/dx; %length of data if there were no gaps 
Z=(b_hat(1:M)-b_hat(M))*1j; 

Zc=conj(Z); Zc=real(Zc); %calc complex conjugate of Z
PowerSpec=(Z*Zc)*(Nc/(2*length(hc)));
