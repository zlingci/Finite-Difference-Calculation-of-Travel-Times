function lineout = zlc_fd_lineout(h,lineout_s,r,line)
% derive the outer line from the inner line 
% h is grid interval, lineout_s is slowness of the outer line
% r is radius from source to the outer layer (num of grids)
% line is the traveltime for innerlayer
%
flag_min_at_1 = 0;
flag_min_at_end = 0;
lineout = zeros(length(line),1);
% find min
[mins,loc_mins] = findpeaks(-line);
if line(1)< line(2)
    mins = reshape(mins,[1,length(mins)]);
    mins = [-line(1) mins];
    loc_mins = reshape(loc_mins,[1,length(loc_mins)]);
    loc_mins = [1 loc_mins];
    flag_min_at_1 = 1;
end
if line(end)< line(end-1)
    mins = reshape(mins,[1,length(mins)]);
    mins = [mins -line(end)];
    loc_mins = reshape(loc_mins,[1,length(loc_mins)]);
    loc_mins = [loc_mins length(line)];
    flag_min_at_end = 1;
end
mins = -1 .* mins;
%find max
[maxs,loc_maxs] = findpeaks(line);
if line(1)> line(2)
    maxs = reshape(maxs,[1,length(maxs)]);
    maxs = [line(1) maxs];
    loc_maxs = reshape(loc_maxs,[1,length(loc_maxs)]);
    loc_maxs = [1 loc_maxs];
end
if line(end)> line(end-1)
    maxs = reshape(maxs,[1,length(maxs)]);
    maxs = [maxs line(end)];
    loc_maxs = reshape(loc_maxs,[1,length(loc_maxs)]);
    loc_maxs = [loc_maxs length(line)];
end
% derive the first values
L = length(mins);
for i = 2: 1: L-1
    lineout(loc_mins(i)) = line(loc_mins(i)) + sqrt( (h * lineout_s(loc_mins(i)) )^2 - 0.25 * (line(loc_mins(i)-1) - line(loc_mins(i)+1))^2);
end
if flag_min_at_1==0
    lineout(loc_mins(1)) = line(loc_mins(1)) + sqrt( (h * lineout_s(loc_mins(1)) )^2 - 0.25 * (line(loc_mins(1)-1) - line(loc_mins(1)+1))^2);  
else
    lineout(loc_mins(1)) = line(loc_mins(1)) + sqrt( (h * lineout_s(loc_mins(1)) )^2 -(line(loc_mins(1)) - line(loc_mins(1)+1))^2);
end
if flag_min_at_end==0
    lineout(loc_mins(L)) = line(loc_mins(L)) + sqrt( (h * lineout_s(loc_mins(L)) )^2 - 0.25 * (line(loc_mins(L)-1) - line(loc_mins(L)+1))^2);  
else
    lineout(loc_mins(L)) = line(loc_mins(L)) + sqrt( (h * lineout_s(loc_mins(L)) )^2 -(line(loc_mins(L)-1) - line(loc_mins(L)))^2);
end

if loc_mins(1) < loc_maxs(1)
    for i = 1: 1: L-1
        leftW(i,:) = [loc_mins(i) loc_maxs(i)];    %calculate from left to right
        rightW(i,:) = [loc_maxs(i) loc_mins(i+1)];
    end
    if length(maxs)==L
        leftW(L,:) = [loc_mins(L) loc_maxs(L)];
    end
end
if loc_mins(1) > loc_maxs(1)
    for i = 1: 1: L-1
        leftW(i,:) = [loc_mins(i) loc_maxs(i+1)];
        rightW(i,:) = [loc_maxs(i) loc_mins(i)];
    end
    rightW(L,:) = [loc_maxs(L) loc_mins(L)];
    if length(maxs)==L+1
        leftW(L,:) = [loc_mins(L) loc_maxs(L+1)];
    end
end

for i = 1: 1: size(leftW,1)
    for j = leftW(i,1)+1:1:leftW(i,2)
        lineout(j) = line(j-1) + sqrt( 2* (h * lineout_s(j) )^2 -(lineout(j-1) - line(j) )^2);
    end
end
for i = 1: 1: size(rightW,1)
    for j = rightW(i,2)-1: -1: rightW(i,1)+1
        lineout(j) = line(j+1) + sqrt( 2* (h * lineout_s(j) )^2 -(lineout(j+1) - line(j) )^2);
    end
    j = rightW(i,1);
    if lineout(j)~=0
        lineout(j) = min(lineout(j), line(j+1) + sqrt( 2* (h * lineout_s(j) )^2 -(lineout(j+1) - line(j) )^2)); 
    else
        lineout(j) = line(j+1) + sqrt( 2* (h * lineout_s(j) )^2 -(lineout(j+1) - line(j) )^2); 
    end
end

end