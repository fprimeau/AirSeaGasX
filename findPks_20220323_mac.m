function [pk_x,pk_y]=findPks_20220323_mac(x, y, pw, th)

rr=rem(pw,2); %deal with even and odd peak widths
if rr==0
    lb=(pw/2)-1; ub=(pw/2);
else
    lb=floor(pw/2); ub=floor(pw/2);
end
flg_pkstart=false;
pk_x=[]; pk_y=[];
for i=lb+1:length(x)-ub
    pp=polyfit(x(i-lb:i+ub),y(i-lb:i+ub),1);
    %disp(pp(1));
    switch flg_pkstart
        case false
            if pp(1)>=th
                flg_pkstart=true;
                idx_pkstart=i;
            end
        case true
            if pp(1)<-th
                idx_pkend=i;
                xtmp=x(idx_pkstart:idx_pkend);
                ytmp=y(idx_pkstart:idx_pkend);
                ymax=max(ytmp);%grab the peak x and y
                vr=find(ytmp==max(ytmp),1,'first');
                xmax=xtmp(vr);
                pk_x=[pk_x; xmax];
                pk_y=[pk_y; ymax];
                flg_pkstart=false;%reset
                if ~isequal(length(pk_x), length(pk_y))
                    disp([num2str(length(pk_x)) ' ' num2str(length(pk_y))])
                end
            end
    end
end
end
