function [ind]=getPoints(start,delta,dist,track,orient,phO,phO_id)
    
    %vr1=find(track.lat <= 3 & track.lat >= 52);
    vr=find(dist>=start & dist<(start+delta));
    vvr=find(track.sig_conf(2,:)==4 | track.sig_conf(2,:)==3);
    %vvr=find(track.sig_conf(2,:)==4);
    %vvvr=find(track.q==0);
    j=ismember(vr,phO_id);
    jj=find(j ==1);
    in1=vr(jj);

   if length(vvr) > 0
       m=ismember(vvr,in1);
       ind=find(m ==1);
   else 
       ind=[];
   end 
    
%     if length(vvr) > 0 & length(in2) > 0 
%         idx=ismember(vvr,in2);
%         j=find(idx==1);
%         ind=vvr(j);
%     else
%         ind=[];
%     end

%     i_ph.spacing=1; %1 meter
%     i_dist=dist(ind(1)):i_ph.spacing:dist(ind(end));%interp distance
%     i_ph=interp1(dist(ind),track.ph(ind),i_dist);

 


end 