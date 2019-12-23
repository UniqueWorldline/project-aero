function [value,isterminal,direction] = myEventsFcn(t,y)

value = y(1)-y(3);
isterminal = 1;
direction = 0;

end