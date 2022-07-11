t = timer('TimerFcn',@(x,y)my_timer_callback,'StartDelay',1);

start(t)

delay(5)


function delay(seconds)
% function pause the program
% seconds = delay time in seconds
tic;
while toc < seconds
end
end

function my_timer_callback(obj,event)
disp('timer!')
error('timeout')
end