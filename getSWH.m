function [SWHH,dist_SWH,lat_SWH,lon_SWH,Ls,dt_SWH,SWH_windwaves,SWH_swells,lambda_SWH]=getSWH(ph,dist,lat,lon,dt)
%calculate the signifcant wave height for 5km segments within the 82km
%segment
%first identify the crests and the troughs
%the wave height is the distance between the crests and the troughs
%then sort the wave heights in descending order
%then the SWH is the mean of the top 1/3 of the wave heights

m=1;
bin=10e3:10e3:1e5;
SWH=[]; SWHH=[]; dist_SWH=[]; lat_SWH=[]; lon_SWH=[]; crests=[]; troughs=[];
SWH_windwaves=[]; SWH_swells=[]; Lambda_SWH=[];
crests_x=[]; troughs_x=[]; dt_SWH=[]; Lss=[]; Ls=[];
for i=1:length(bin)
    x=[]; y=[]; z=[]; zz=[]; tt=[]; %SWHH=[]; 
    yr=[]; yc=[];
    % SWH=[]; SWH_std=[];
    while dist(m) <= bin(i) && m < length(dist)
        y=[y; ph(m)];
        x=[x; dist(m)];
        z=[z;lat(m)];
        zz=[zz;lon(m)];
        tt=[tt; dt(m)];
%         yr=[yr; phr(m)];
%         yc=[yc; phc(m)];
        m=m+1;
    end
    if length(y) >2000
        %% Set up the threshold
        %     th=[0.004:0.001:0.06];
        %pw=[11];
        pw=[12];

        th=0.2;

        %calculate the peaks using each threshold for each pw
        num_pks=zeros((length(th)),length(pw))';
        %SWH=zeros((length(th)),length(pw));
        num_pk_neg=zeros((length(th)),length(pw));
        %     l=[]; l_a=[]; L=[]; lw=[]; Ls=[];
        [pk_x, pk_y]=findPks_20220323_mac(x,y,pw,th);
        [pk_x_neg, pk_y_neg]=findPks_20220323_mac(x,-y,pw,th);

        p=[]; pj=[]; px=[]; pjx=[]; l=[]; l_a=[]; L=[]; lw=[];
        for j=1:length(pk_x)-1
            if pk_x(1) > pk_x_neg(1) & j<length(pk_x_neg) & j<length(pk_x)
                if pk_x(j) <= pk_x_neg(j+1)+50 && pk_x_neg(j+1) >= pk_x(j)
                    p=[p;pk_y(j)]; px=[px;pk_x(j)];
                    pj=[pj;pk_y_neg(j+1)]; pjx=[pjx; pk_x_neg(j+1)];

                    w=abs((pk_y(j)-(-pk_y_neg(j+1))));
                    l=[l; w];
                    ww=pk_x(j)-pk_x(j+1);
                    lw=[lw;ww];

                end
            else pk_x(1) < pk_x_neg(1) & j<=length(pk_x_neg) & j<=length(pk_x)
                if pk_x(j) <= pk_x_neg(j)+50 && pk_x_neg(j)>= pk_x(j)
                    p=[p;pk_y(j)]; px=[px;pk_x(j)];
                    pj=[pj;pk_y_neg(j)]; pjx=[pjx; pk_x_neg(j)];

                    w=abs((pk_y(j)-(-pk_y_neg(j))));
                    l=[l; w];
                    ww=pk_x(j+1)-pk_x(j);
                    lw=[lw;ww];


                end
            end

        end

        %calculate the significant wave height and the peak wavelength
        %SWH= the mean of the top 30% of waves
        %Peak Wavelength= wavelength of the peak wave height
        %get peak wavelength by taking the max wave height
        wavez=[];
        if length(l) >= 5
            wavez(:,1)=l; wavez(:,2)=lw;
            wavez=sortrows(wavez,'descend');
            %l=wavez(:,1);
            lengthl=floor((0.3)*length(l));
            ll=l(1:lengthl);
            SWHH=[SWHH; mean(ll)];
            %Lss=[Lss; bb];
            %             wavez{i}=waves(:,1);
            %             wavelengths{i}=waves(:,2);
            %             SWHHs{i}=mean(ll);
            %calculate the standard deviation SWH
            m0=var(y);
            Q=4*sqrt(m0);
            SWH_std=Q;



            if length(y) > 0
                m0=var(y);
                Q=4*sqrt(m0);
                SWH_std=Q;
            else
                SWH_std=0;
            end

            %Plot the timeseries with the peaks and troughs

            figure(9)
            plot(x,y,'.'); hold on
            plot(pk_x,pk_y,'o','MarkerSize',12); hold on
            plot(pk_x_neg,-pk_y_neg,'.','MarkerSize',12)
            title('Timeseries of Photon Heights with Peaks')
            hold off

            waves=wavez(:,1); %lambda=abs(wavez(:,2));

            
            dist_SWH=[dist_SWH; x(end)];
            lat_SWH=[lat_SWH; z(end)];
            lon_SWH=[lon_SWH; zz(end)];
            dt_SWH=[dt_SWH; tt(1)];

            %calculate the power Spec
            dx=20;
            [k,dk,Spec,F,specs,y_gridded,x_model,Lambda]=CalcPowerSpec2(y,x,dx)

            lambda_SWH=[Lambda_SWH; Lambda];
        else
            SWHH=[SWHH; NaN];
            SWH_windwaves=[SWH_windwaves; NaN];
            SWH_swells=[SWH_swells; NaN];
            lambda_SWH=[Lambda_SWH; NaN];

        end

    else
        SWHH=[SWHH; NaN];
        SWH_windwaves=[SWH_windwaves; NaN];
        SWH_swells=[SWH_swells; NaN];
        lambda_SWH=[Lambda_SWH; NaN];

        dist_SWH=[dist_SWH; NaN];
        lat_SWH=[lat_SWH; NaN];
        lon_SWH=[lon_SWH; NaN];
        dt_SWH=[dt_SWH; dt(1)];

    end



    close all
end