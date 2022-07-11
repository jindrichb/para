function [userY1,userX1,userY2,userX2] = user_ts(app,typ,in,t,p,v,s,x,h,u)
%      vypocte body pro vymalovani pomocnich car
%
%                 disp('zatim umim jen nasledujici')
%                 disp('h - p = 1')
%                 disp('h - s = 2')
%                 disp('t - p = 3')
%                 disp('h - t = 4')
%                 disp('s - t = 5')
%                 disp('s - p = 6')
%                 disp('t - x = 7')
%                 disp('p - x = 8')
%                 disp('h - x = 9')
%                 disp('s - x = 10')
%                 disp('t - v = 11')
%                 disp('p - v = 12')
%                 disp('h - v = 13')
%                 disp('s - v = 14')
%                 disp('x - v = 15')

[userY1,userX1,userY2,userX2] = deal([],[],[],[]);
switch in
    case 1
        %h-p
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'isoh',h);
        %l1=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isobara',p);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 2
        %h-s
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'isoh',h);
        %l1=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        %l2=xlineCustom(s,barva,tloustka);
        [userY2,userX2] = xlineCustom(s,typ);
    case 3
        %t-p
        %l1=ylineCustom(app,t,barva,tloustka);
        [userY1,userX1] = ylineCustom(app,t);
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isobara',p);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 4
        %h-t
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'isoh',h);
        %l1=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        [userY2,userX2] = ylineCustom(app,t);
        %l2=ylineCustom(app,t,barva,tloustka);
    case 5
        %s-t
        %l1=xlineCustom(s,barva,tloustka);
        [userY1,userX1] = xlineCustom(s,typ);
        [userY2,userX2] = ylineCustom(app,t);
        %l2=ylineCustom(app,t,barva,tloustka);
    case 6
        %s-p
        %l1=xlineCustom(s,barva,tloustka);
        [userY1,userX1] = xlineCustom(s,typ);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isobara',p);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 7
        %t-x
        %l1=ylineCustom(app,t,barva,tloustka);
        [userY1,userX1] = ylineCustom(app,t);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'such',x);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 8
        %p-x
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'isobara',p);
        %l1=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'such',x);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 9
        %h-x
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'isoh',h);
        %l1=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'such',x);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 10
        %s-x
       %l1 =xlineCustom(s,barva,tloustka);
        [userY1,userX1] = xlineCustom(s,typ);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'such',x);
       %l2 =plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 11
        %t-v
       %l1 =ylineCustom(app,t,barva,tloustka);
        [userY1,userX1] = ylineCustom(app,t);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isochora',v);
       %l2 =plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 12
        %p-v
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'isobara',p);
       %l1 =plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isochora',v);
       %l2 =plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 13
        %h-v
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'isoh',h);
       %l1 =plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isochora',v);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 14
        %s-v
        %l1=xlineCustom(s,barva,tloustka);
        [userY1,userX1] = xlineCustom(s,typ);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isochora',v);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 15
        %x-v
        [userY1,userX1] = vypocetTS(app.konst.konstTS,'such',x);
        %l1=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
        
        [userY2,userX2] = vypocetTS(app.konst.konstTS,'isochora',v);
        %l2=plot(fig,userS,userT,'color',barva,'LineWidth',tloustka);
    case 16 % 16 t-u
        
    case 17 % 17 p-u
    case 18 % 18 h-u
    case 19 % 19 s-u
    case 20 % 20 v-u
    case 21 % 21 x-u
    otherwise
end


end

function [ret_y,ret_x] = xlineCustom(value,pripad)
%xlineCustom(s,barva,tloustka);
switch pripad
    case 'T-s'
        ret_y=[0,800];
    case 'h-s'
        ret_y=[0,4200];
    otherwise
        error('no pv just yet')
end
%y=[0,800];
ret_x=[value,value];
%ret = plot(fig,x,y,'color',barva,'LineWidth',tloustka);
%ret = plot(fig,0,0);
end

function [ret_y,ret_x] = ylineCustom(app,value)
%xlineCustom(s,barva,tloustka);
%             switch pripad
%                 case 1
%                     x=[0,9];
%                 case 2
%                     x=[0,10];
%                 otherwise
%                     x=[0,10];
%             end
ret_x=[0,10];
ret_y=[value,value];
%ret = plot(fig,x,y,'color',barva,'LineWidth',tloustka);
%ret = plot(fig,0,0);
end