function [ pos2 ] = moveRec( direction, pos1)

switch direction
    case 1 %up
        if pos1~=5 && pos1~=10
            pos2=pos1+1;
        else
            pos2=pos1;
        end
    case 2 %right
    if pos1>5
            pos2=pos1-5;
        else
            pos2=pos1;
        end
    case 3 %down
        if pos1~=1 && pos1~=6
            pos2=pos1-1;
        else
            pos2=pos1;
        end 
    case 4 %left
        if pos1<6
            pos2=pos1+5;
        else
            pos2=pos1;
        end
        
    otherwise
        pos2=pos1;
end
end

