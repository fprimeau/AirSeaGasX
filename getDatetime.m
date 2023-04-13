function [dt1,dt2,dt3]=getDatetime(track1,track2,track3,ind1,ind2,ind3)
d=[];
for i=1:length(track1.time(ind1))
    d.datenum(i,:)=addtodate(datenum(2018,1,1),fix(track1.time(i)),'second');
end
d.datenum=d.datenum';
dt1=datetime(d.datenum,'ConvertFrom','datenum');
dt1.Format='yyyy-MM-dd HH:mm:ss';
d=[];
for i=1:length(track2.time(ind2))
    d.datenum(i,:)=addtodate(datenum(2018,1,1),fix(track2.time(i)),'second');
end
d.datenum=d.datenum';
dt2=datetime(d.datenum,'ConvertFrom','datenum');
dt2.Format='yyyy-MM-dd HH:mm:ss';
d=[];
for i=1:length(track3.time(ind3))
    d.datenum(i,:)=addtodate(datenum(2018,1,1),fix(track3.time(i)),'second');
end
d.datenum=d.datenum';
dt3=datetime(d.datenum,'ConvertFrom','datenum');
dt3.Format='yyyy-MM-dd HH:mm:ss';
end 