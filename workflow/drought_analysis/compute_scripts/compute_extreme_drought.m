%  extreme_drought = period of 5th percentile SDI with at least 1 in 2nd percentile
extreme_drought = sdi_5th_percentile;

for ii=1:length(time_vec)
    %%% check for sdi_2nd_percentile during the same drought event forwards in time
    drought_event_forward = 0.*sdi(:,:,1)+1;
    ff=1;
    
    if ii<length(time_vec)    
        while any(any(drought_event_forward))
            % all grid cells which have a sdi_5th_percentile at next time step
            drought_event_forward = all(sdi_5th_percentile(:,:,ii:(ii+ff)),3); 
            % add 1 to each grid cell if the drought event has at least 1 sdi_2nd_percentile
            extreme_drought(:,:,ii) = extreme_drought(:,:,ii)+all(cat(3,sdi_2nd_percentile(:,:,(ii+ff)),drought_event_forward),3);
            
            if (ii+ff)==length(time_vec)
                break;
            else
                ff = ff+1;
            end
        end
    end
    
    
    %%% check for sdi_2nd_percentile during the same drought event backwards in time
    drought_event_backward = 0.*sdi(:,:,1)+1;
    bb=1;
    
    if ii>1 
        while any(any(drought_event_backward))
            % all grid cells which have a sdi_5th_percentile at previous time step
            drought_event_backward = all(sdi_5th_percentile(:,:,(ii-bb):ii),3); 
            % add 1 to each grid cell if the drought event has at least 1 sdi_2nd_percentile
            extreme_drought(:,:,ii) = extreme_drought(:,:,ii)+all(cat(3,sdi_2nd_percentile(:,:,(ii-bb)),drought_event_backward),3);
            if (ii-bb)==1
                break;
            else
                bb = bb+1;
            end
        end
    end
end
