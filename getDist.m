function [dist1 dist2 dist3]=getDist(track1,track2,track3,orient)

%use function to calculate the distances in each right track



%calculate for first track
[arclen,az]=distance([track1.lat track1.lon],ones(size(track1.lat,1),2).*[track1.lat(1) track1.lon(1)]);
dist1=1000*deg2km(arclen);

%calculate for 2nd track
[arclen,az]=distance([track2.lat track2.lon],ones(size(track2.lat,1),2).*[track2.lat(1) track2.lon(1)]);
dist2=1000*deg2km(arclen);

%calculate for 3rd track
[arclen,az]=distance([track3.lat track3.lon],ones(size(track3.lat,1),2).*[track3.lat(1) track3.lon(1)]);
dist3=1000*deg2km(arclen);


