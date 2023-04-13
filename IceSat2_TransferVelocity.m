%Run IceSat-2 to calculate transfer velocity 

SWH1=[]; SWH2=[]; SWH3=[];
lat1_SWH=[]; lat2_SWH=[]; lat3_SWH=[];
lon1_SWH=[]; lon2_SWH=[]; lon3_SWH=[];
H_SWH1=[]; H_SWH2=[]; H_SWH3=[];
lat1_HSWH=[]; lat2_HSWH=[]; lat3_HSWH=[];
lon1_HSWH=[]; lon2_HSWH=[]; lon3_HSWH=[];
Ls_1=[]; Ls_2=[]; Ls_3=[];
L01=[]; L02=[]; L03=[];
z01=[]; z02=[]; z03=[]; cp1=[]; cp2=[]; cp3=[];
time1=[]; time2=[]; time3=[]; 
SWH1_swells=[]; SWH2_swells=[]; SWH3_swells=[];
SWH1_windwaves=[]; SWH2_windwaves=[]; SWH3_windwaves=[];
dt1_SWH=[]; dt2_SWH=[]; dt3_SWH=[];
wind=[];
lambda1_swh=[]; lambda2_swh=[]; lambda3_swh=[];

urltxt=importdata("urls.txt");

for r=1:length(urltxt)


URL=convertCharsToStrings(urltxt{r});
%urlname=cell2mat(urlname);

!echo 'machine urs.earthdata.nasa.gov login <uid> password <pswd>' >> ~/.netrc
!chmod 0600 ~/.netrc
%!wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --keep-session-cookies urlname
setenv('URL',URL);
!PATH=/usr/local/bin:$PATH wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --keep-session-cookies "$URL"

direc=dir('*h5');
fname=direc(1).name;
orient=h5read(fname,'/orbit_info/sc_orient'); %1==R is strong ; 0==L is strong
test=h5info(fname);
testgroups=test.Groups(:);
k=struct2cell(testgroups)';
k=k(:,1);



[track1 track2 track3]=getTracks(fname,k,orient);

%     rand1=rand(length(track1.ph),1);
%     rand2=rand(length(track2.ph),1);
%     rand3=rand(length(track3.ph),1);
%     figure(111)
%     geoscatter(track1.lat,track1.lon,rand1,'*g'); hold on
%     geoscatter(track2.lat,track2.lon,rand2,'*b'); hold on
%     geoscatter(track3.lat,track3.lon,rand3,'*r'); hold off
%     legend('Track 1','Track 2','Track 3')
%     title('Icesat 2 Tracks')

%get the distances for each track

[l_dist1, l_dist2 l_dist3]=getDist(track1,track2,track3,orient);

% get indices for ocean data
[ph1O,ph1O_id]=getOceanData(track1);
[ph2O,ph2O_id]=getOceanData(track2);
[ph3O,ph3O_id]=getOceanData(track3);

%get indices for ATL12 tracks
%%
for i=501:1e5:length(l_dist1)

    start=i-500;
    delta=1e5;

    %get indices for points for each track
    [ind1]=getPoints(start,delta,l_dist1,track1,orient,ph1O,ph1O_id);
    [ind2]=getPoints(start,delta,l_dist2,track2,orient,ph2O,ph2O_id);
    [ind3]=getPoints(start,delta,l_dist3,track3,orient,ph3O,ph3O_id);


    if length(ind1) >0 & length(ind2) >0 & length(ind3) >0


        [dt1,dt2,dt3]=getDatetime(track1,track2,track3,ind1,ind2,ind3);

        ph1=track1.ph(ind1); dist1t=l_dist1(ind1);
        ph2=track2.ph(ind2); dist2t=l_dist2(ind2);
        ph3=track3.ph(ind3); dist3t=l_dist3(ind3);


        %get coordinates for each tracks
        lat1=track1.lat(ind1); lon1=track1.lon(ind1);
        lat2=track2.lat(ind2); lon2=track2.lon(ind2);
        lat3=track3.lat(ind3); lon3=track3.lon(ind3);

%         %get Open Ocean data
%         [ph1,lat1,lon1,dist1t]=getOpenOcean(lat1,lat1_12,lon1,lon1_12,ph1,dist1t,depth_ocn1,track1_12.depth_shore,dt1);
%         [ph2,lat2,lon2,dist2t]=getOpenOcean(lat2,lat2_12,lon2,lon2_12,ph2,dist2t,depth_ocn2,track2_12.depth_shore,dt2);
%         [ph3,lat3,lon3,dist3t]=getOpenOcean(lat3,lat3_12,lon3,lon3_12,ph3,dist3t,depth_ocn3,track3_12.depth_shore,dt3);
        %
        if length(ph1) > 0 & length(ph2) > 0 & length(ph3) > 0

            dist1t=dist1t-dist1t(1);
            dist2t=dist2t-dist2t(1);
            dist3t=dist3t-dist3t(1);

            %filter the data points
            [phf1,distf1,latf1,lonf1,dt1]=filterPoints(ph1,dist1t,lat1,lon1,dt1);
            [phf2,distf2,latf2,lonf2,dt2]=filterPoints(ph2,dist2t,lat2,lon2,dt2);
            [phf3,distf3,latf3,lonf3,dt3]=filterPoints(ph3,dist3t,lat3,lon3,dt3);

            if length(phf1) > 0 & length(phf2) > 0 & length(phf3) > 0
                %correct the photon data around the mean
                [ph1c,dist1,lat1,lon1,dt1]=correctPH(phf1,distf1,latf1,lonf1,dt1);
                [ph2c,dist2,lat2,lon2,dt2]=correctPH(phf2,distf2,latf2,lonf2,dt2);
                [ph3c,dist3,lat3,lon3,dt3]=correctPH(phf3,distf3,latf3,lonf3,dt3);

                %smooth points
                span=10;
                deg=2;
                [ph1s,ph2s,ph3s]=smoothdata(ph1c,ph2c,ph3c,span,deg);


                %calculate the SWH using the peaks and mins in 7km segments
                %Method: Histogram Model

                th=[0.001:0.001:0.3];
                lats1=[]; lats2=[]; lats3=[]; Ls1=[]; Ls2=[]; Ls3=[]; SW1=[]; SW2=[]; SW3=[];
                [SW1,dists1,lats1,lons1,Ls1,dts1,wavez1,wavelengths1,lambda1]=getSWH(ph1s,dist1,lat1,lon1,dt1);
                [SW2,dists2,lats2,lons2,Ls2,dts2,wavez2,wavelengths2,lambda2]=getSWH(ph2s,dist2,lat2,lon2,dt2);
                [SW3,dists3,lats3,lons3,Ls3,dts3,wavez3,wavelengths3,lambda3]=getSWH(ph3s,dist3,lat3,lon3,dt3);

                SWH1=[SWH1; SW1]; SWH2=[SWH2; SW2]; SWH3=[SWH3; SW3];
                lat1_SWH=[lat1_SWH; lats1]; lat2_SWH=[lat2_SWH; lats2]; lat3_SWH=[lat3_SWH; lats3];
                lon1_SWH=[lon1_SWH; lons1]; lon2_SWH=[lon2_SWH; lons2]; lon3_SWH=[lon3_SWH; lons3];
                Ls_1=[Ls_1;Ls1]; Ls_2=[Ls_2;Ls2]; Ls_3=[Ls_3;Ls3];
                dt1_SWH=[dt1_SWH; dts1]; dt2_SWH=[dt2_SWH;dts2]; dt3_SWH=[dt3_SWH;dts3];

                SWH1_swells=[SWH1_swells;wavelengths1]; SWH1_windwaves=[SWH1_windwaves; wavez1];
                SWH2_swells=[SWH2_swells;wavelengths2]; SWH2_windwaves=[SWH2_windwaves; wavez2];
                SWH3_swells=[SWH3_swells;wavelengths3]; SWH3_windwaves=[SWH3_windwaves; wavez3];

                lambda1_swh=[lambda1_swh; lambda1];
                lambda2_swh=[lambda2_swh; lambda2];
                lambda3_swh=[lambda3_swh; lambda3];

                %correct wavelengths
                [L01]=correctWavelength(lambda1,lats1,lons1,dts1,ww3_global);
                [L02]=correctWavelength(Lambda2,lats2,lons2,dts2,ww3_global);
                [L03]=correctWavelength(lambda3,lats3,lons3,dts3,ww3_global);
                
                %get the wave parameters

                [z0,ustar,cp]=getwaveparams(SW1,lambda1)
                [z0,ustar,cp]=getwaveparams(SW2,lambda2)
                [z0,ustar,cp]=getwaveparams(SW3,lambda3)
                % calculate the transfer velocity using wavewatch3
                [ww3_waves1.swh,ww3_waves1.L,ww3_waves1.z0,ww3_waves1.cp,ww3_waves1.ustar,ww3_waves1.lat,ww3_waves1.lon,ww3_waves1.swell,ww3_waves1.windwaves]=getww3(SWH1,lat1_SWH,lon1_SWH,dt1_SWH,ww3_global);
                [ww3_waves2.swh,ww3_waves2.L,ww3_waves2.z0,ww3_waves2.cp,ww3_waves2.ustar,ww3_waves2.lat,ww3_waves2.lon,ww3_waves2.swell,ww3_waves2.windwaves]=getww3(SWH2,lat2_SWH,lon2_SWH,dt2_SWH,ww3_global);
                [ww3_waves3.swh,ww3_waves3.L,ww3_waves3.z0,ww3_waves3.cp,ww3_waves3.ustar,ww3_waves3.lat,ww3_waves3.lon,ww3_waves3.swell,ww3_waves3.windwaves]=getww3(SWH3,lat3_SWH,lon3_SWH,dt3_SWH,ww3_global);


                %read in variables from file
                load('SST_DATA.mat');
                dn1_SWH=datenum(dt1_SWH);
                [SST_i]=getSST(min(lat1_SWH),max(lat1_SWH),min(lon1_SWH),max(lon1_SWH),min(dn1_SWH),max(dn1_SWH),sst.lat,SS);

                % get the SSS data
                load('SSS_DATA.mat');
                [SSS_i]=getSSS2(min(lat1_SWH),max(lat1_SWH),min(lon1_SWH),max(lon1_SWH),month_swh,SSS);

                % get the wind speeds
                if ~isempty(SW1)
                    [d1,ccmp1]=CCMP_IceSat2_Mac(min(lats1),max(lats1),min(lons1),max(lons1));
                end
            
                wind=[wind; ccmp1;]
              
                %% calc the transfer velocity for IceSat-2 and WW3

                Beam1(:,1)=lat1_SWH; Beam1(:,2)=SWH1_std; Beam1(:,3)=lon1_SWH;
                Beam2(:,1)=lat2_SWH; Beam2(:,2)=SWH2_std; Beam2(:,3)=lon2_SWH;
                Beam3(:,1)=lat3_SWH; Beam3(:,2)=SWH3_std; Beam3(:,3)=lon3_SWH;
                [K01]=calcSolubility(Beam1,SST,SSS_i);
                [kw1]=calcTransferVelocity(ustar1,Beam1,SST,K01);
                [kw2]=calcTransferVelocity(ustar2,Beam2,SST,K01);
                [kw3]=calcTransferVelocity(ustar3,Beam3,SST,K01);

                Beam1_ww3(:,1)=ww3_waves1.lat; Beam1_ww3(:,2)=ww3_waves1.swh; Beam1_ww3(:,3)=ww3_waves1.lon;
                Beam2_ww3(:,1)=ww3_waves2.lat; Beam2_ww3(:,2)=ww3_waves2.swh; Beam2_ww3(:,3)=ww3_waves2.lon;
                Beam3_ww3(:,1)=ww3_waves3.lat; Beam3_ww3(:,2)=ww3_waves3.swh; Beam3_ww3(:,3)=ww3_waves3.lon;
                [SST_w]=getSST(min(ww3_waves1.lat),max(ww3_waves1.lat),min(ww3_waves1.lon),max(ww3_waves1.lon),timemin,timemax,sst_lat,sst_lon,sst_time,sst);
                [SSS_w]=getSSS(min(ww3_waves1.lat),max(ww3_waves1.lat),min(ww3_waves1.lon),max(ww3_waves1.lon),timemin,timemax,sss_lat,sss_lon,sss);

                [K01_w]=calcSolubility(Beam1_ww3,SST_w,SSS_w);
                [kw1_w]=calcTransferVelocity(ww3_waves1.ustar,Beam1_ww3,SST_w,K01_w);
                [kw2_w]=calcTransferVelocity(ww3_waves2.ustar,Beam2_ww3,SST_w,K01_w);
                [kw3_w]=calcTransferVelocity(ww3_waves3.ustar,Beam3_ww3,SST_w,K01_w);
                %calc transfer velocity using Wanninkohf 2014

                kw1_c=0.251.*(ccmp1)^2.*(Sc/660)*(-1/2);
  
                %save the outputs into an appended variable
                kw_wan=[kw_wan; kw1_c];
                kw1_i=[kw1_i;kw1]; kw2_i=[kw2_i;kw2]; kw3_i=[kw3_i;kw3];
                kw1_ww3=[kw1_ww3;kw1_w]; kw2_ww3=[kw2_ww3;kw2_w]; kw3_ww3=[kw3_ww3;kw3_w];


            end
        end
    end
end
setenv('fname',fname);
!rm "$fname"
end

%% bin the data by month


[X,Y]=cdtgrid(2); %create a 2x2 degree grid

[IceSat.mu, IceSat.var,Icesat.n,IceSat.Q,IceSat.dt,IceSat.dn]=binIceSat(kw1_i.kw,kw2_i.kw,kw3_i.kw,kw1_i.lat,kw2_i.lat,kw3_i.lat,kw1_i.lon,kw2_i.lon,kw3_i.lon,kw1_i.dt,kw2_i.dt,kw3_i.dt); %bin IceSat2 data
[WW3.mu,WW3.var,WW3.n,WW3.Q,WW3.dt,WW3.dn]=binIceSat(kw1_ww3.kw,kw2_ww3.kw,kw3_ww3.kw,kw1_ww3.lat,kw2_ww3.lat,kw3_ww3.lat,kw1_ww3.lon,kw2_ww3.lon,kw3_ww3.lon,kw1_ww3.dt,kw2_ww3.dt,kw3_ww3.dt); %bin WW3 data

[Wan.mu,Wan.var,Wan.n,Wan.Q,Wan.dt,Wan.dn]=binMonthly(kw1_wan,kw1_i.lat,kw1_i.lon,kw1_i.dt); %bin Wanninkhof data

save('ICESAT2_OUTPUT.mat','kw1_w','kw1_c','wind','kw1_wan','IceSat','WW3','Wan','X','Y');



