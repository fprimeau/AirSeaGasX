function [ph, ph_id]=getOceanData(track)
%use code to identify ocean data 
%variable track1.surf_type to find ocean data (2nd row is ocean, segement==1 
%track1.seg_ph to know the photon count of each segement 
%use photon count as an index to see which segment each photon belongs to 

ph=[]; ph_id=[]; 
for i=1:length(track.seg_ph)
    if i==1
        l= 1:track.seg_ph(i); %get segment photon count for first segment
        if l ~= 0
            k=track.ph(1:track.seg_ph(i)); %get the photons assosciated with first segment
            if track.surf_type(2,i) == 1 %see if segment is ocean data
                ph=[ph; k];
                ph_id=[ph_id; l'];
                ffl=ph_id(end);
            else
                ffl=track.seg_ph(i);
            end
        else
            ffl=0;
        end
    else
        if track.seg_ph(i) ~= 0 %if statement to make sure segment isn't empty
            f=ffl; %find the index for the last photon of the last segment
            ffl=f+track.seg_ph(i); %add the next segment photon count to this segment to get index
            l=f:ffl; %index of photons for this segment
            if track.surf_type(2,i) == 1 %see if segment is ocean data
                ph_id=[ph_id; l']; %save index of photons
                ph_id=unique(ph_id);
                %ph=[ph; track.ph(l)]; %save photons that contain ocean data
            end

        end
    end
end
%ph=[ph; track.ph(ph_id)];