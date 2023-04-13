function [ph1s,ph2s,ph3s]=smoothdata(ph1c,ph2c,ph3c,span,deg)
ph1s=smooth(ph1c,span,'sgolay',deg);
ph2s=smooth(ph2c,span,'sgolay',deg);
ph3s=smooth(ph3c,span,'sgolay',deg);

for i=1:3
    if i< max(i)+1
        ph1s=smooth(ph1s,span,'sgolay',deg);
        ph2s=smooth(ph2s,span,'sgolay',deg);
        ph3s=smooth(ph3s,span,'sgolay',deg);
    end 
end 
