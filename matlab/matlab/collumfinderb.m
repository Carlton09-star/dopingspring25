function [cols]=collumfinderb(sourcet,source,temp,time,s) %This needs to be fixed it is presently offset by 1 set aka sets the entry at the end of it instead of the beggining
m=0;        %Might be fixed but we'll see
cols=[];
if sourcet==1
    for j=1:2
        for k=900:25:1175
            for n=30:30:120
                m=m+1;
                    if j==source
                        if k==temp
                            if n==time
                                cols=s*m-s+1;
                                break
                            end
                        end
                    end
            end
        end
    end
elseif sourcet==2
    for k=900:25:1125
            for n=30:30:120
                m=m+1;
                        if k==temp
                            if n==time
                                cols=s*m-s+1;
                                break
                            end
                        end
            end
    end
elseif sourcet==3
    for k=750:25:1000
        for n=30:30:120
            m=m+1;
            if k==temp
                if n==time 
                    cols=s*m-s+1;
                end
            end
        end
    end
elseif sourcet==4
    for k=900:25:1200
        for n=30:30:120
            m=m+1;
            if k==temp
                if n==time
                    cols=s*m-s+1;
                end
            end
        end
    end
end
if isempty(cols) ==0
    
elseif isempty(cols)==1
    cols=-1;
end

end
