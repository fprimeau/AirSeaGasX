function [track1 track2 track3]=getTracks(fname)
%% use function to read in variables for all 3 tracks in IceSat2
% Input= filename
%
%output variables:
%Photon Heights, lat, lon, quality, signal confidence, time, seg length,ph
%count

%% Get data from the first track 

%right track: 
track1.ph_r=h5read(fname,'/gt1r/heights/h_ph');
track1.lat_r=h5read(fname,'/gt1r/heights/lat_ph');
track1.lon_r=h5read(fname,'/gt1r/heights/lon_ph');
track1.q_r=h5read(fname,'/gt1r/heights/quality_ph');
track1.sig_conf_r=h5read(fname,'/gt1r/heights/signal_conf_ph');
track1.time_r=h5read(fname,'/gt1r/heights/delta_time');
track1.seg_length_r=h5read(fname,'/gt1r/geolocation/segment_length');
track1.seg_ph_r=h5read(fname,'/gt1r/geolocation/segment_ph_cnt');

%left track: 
track1.ph_l=h5read(fname,'/gt1l/heights/h_ph');
track1.lat_l=h5read(fname,'/gt1l/heights/lat_ph');
track1.lon_l=h5read(fname,'/gt1l/heights/lon_ph');
track1.q_l=h5read(fname,'/gt1l/heights/quality_ph');
track1.sig_conf_l=h5read(fname,'/gt1l/heights/signal_conf_ph');
track1.time_l=h5read(fname,'/gt1l/heights/delta_time');
track1.seg_length_l=h5read(fname,'/gt1l/geolocation/segment_length');
track1.seg_ph_l=h5read(fname,'/gt1l/geolocation/segment_ph_cnt');

%% Get data from the second track

%right track:
track2.ph_r=h5read(fname,'/gt2r/heights/h_ph');
track2.lat_r=h5read(fname,'/gt2r/heights/lat_ph');
track2.lon_r=h5read(fname,'/gt2r/heights/lon_ph');
track2.q_r=h5read(fname,'/gt2r/heights/quality_ph');
track2.sig_conf_r=h5read(fname,'/gt2r/heights/signal_conf_ph');
track2.time_r=h5read(fname,'/gt2r/heights/delta_time');
track2.seg_length_r=h5read(fname,'/gt2r/geolocation/segment_length');
track2.seg_ph_r=h5read(fname,'/gt2r/geolocation/segment_ph_cnt');

%left track: 
track2.ph_l=h5read(fname,'/gt2l/heights/h_ph');
track2.lat_l=h5read(fname,'/gt2l/heights/lat_ph');
track2.lon_l=h5read(fname,'/gt2l/heights/lon_ph');
track2.q_l=h5read(fname,'/gt2l/heights/quality_ph');
track2.sig_conf_l=h5read(fname,'/gt2l/heights/signal_conf_ph');
track2.time_l=h5read(fname,'/gt2l/heights/delta_time');
track2.seg_length_l=h5read(fname,'/gt2l/geolocation/segment_length');
track2.seg_ph_l=h5read(fname,'/gt2l/geolocation/segment_ph_cnt');

%% Get data from the third track 
%right track: 
track3.ph_r=h5read(fname,'/gt3r/heights/h_ph');
track3.lat_r=h5read(fname,'/gt3r/heights/lat_ph');
track3.lon_r=h5read(fname,'/gt3r/heights/lon_ph');
track3.q_r=h5read(fname,'/gt3r/heights/quality_ph');
track3.sig_conf_r=h5read(fname,'/gt3r/heights/signal_conf_ph');
track3.time_r=h5read(fname,'/gt3r/heights/delta_time');
track3.seg_length_r=h5read(fname,'/gt3r/geolocation/segment_length');
track3.seg_ph_r=h5read(fname,'/gt3r/geolocation/segment_ph_cnt');

%left track: 
track3.ph_l=h5read(fname,'/gt3l/heights/h_ph');
track3.lat_l=h5read(fname,'/gt3l/heights/lat_ph');
track3.lon_l=h5read(fname,'/gt3l/heights/lon_ph');
track3.q_l=h5read(fname,'/gt3l/heights/quality_ph');
track3.sig_conf_l=h5read(fname,'/gt3l/heights/signal_conf_ph');
track3.time_l=h5read(fname,'/gt3l/heights/delta_time');
track3.seg_length_l=h5read(fname,'/gt3l/geolocation/segment_length');
track3.seg_ph_l=h5read(fname,'/gt3l/geolocation/segment_ph_cnt');