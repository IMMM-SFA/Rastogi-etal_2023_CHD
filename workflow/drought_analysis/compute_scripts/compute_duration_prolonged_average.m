drought_duration = sdi.*0;
drought_duration(isnan(drought_duration))=0;
prolonged_drought = logical(drought_duration.*0);

sum_drought_event = sdi;

% Create a spatial grid (drought_forward_count) which gives the number of 
% months into the future that the drought event persists.
for ii=1:length(time_vec) 
    drought_event_forward = 0.*sdi(:,:,1)+1;
    drought_forward_count = 0.*sdi(:,:,1);
    ff=1;

    if ii<length(time_vec) 
        while any(any(drought_event_forward))
            % find all grid cells which has a drought at the next time step
            drought_event_forward = all(current_drought_array(:,:,ii:(ii+ff)),3);
            drought_forward_count = drought_forward_count + ...
                        single(drought_event_forward);  
            % sums all grid cells in layer ii+ff which are a part of the
            % current drought event
            current_sdi_layer = sdi(:,:,ii+ff);        
            sum_drought_event(:,:,ii) = sum_drought_event(:,:,ii) + current_sdi_layer.*drought_event_forward;        
            if (ii+ff)==length(time_vec)
                break;
            else
                ff = ff+1;
            end
        end
    end
    
% Create a spatial grid (drought_backward_count) which gives the number of 
% months into the past that the drought event persists (using sdi<-1 to 
% characterize drought)    
    drought_event_backward = 0.*sdi(:,:,1)+1;
    drought_backward_count = 0.*sdi(:,:,1);
    bb=1;
    
    if ii>1 
        while any(any(drought_event_backward))
            % find all grid cells which have a "drought" (sdi<-1.5) at next time step
            drought_event_backward = all(current_drought_array(:,:,(ii-bb):ii),3);
            % find all grid cells which have a "drought" (sdi<-1) at next time step
            drought_backward_count = drought_backward_count + ...
                        single(drought_event_backward); 
            % sums all grid cells in layer ii-bb which are a part of the
            % current drought event
            current_sdi_layer = sdi(:,:,ii-bb);                 
            sum_drought_event(:,:,ii) = sum_drought_event(:,:,ii) + current_sdi_layer.*drought_event_backward;         
            if (ii-bb)==1
                break;
            else
                bb = bb+1;
            end
        end
    end
    
    % Sum drought_backward_count and drought_forward_count to get the length of 
    % the current drought event occuring at each grid cell at each time step. 
    % Call this variable drought_duration.

    drought_duration(:,:,ii) = single(current_drought_array(:,:,ii)) + drought_forward_count + drought_backward_count;

    % Then take (drought_duration >= 24) to get a logical array
    % (prolonged_drought_events) which contains a 1 if the grid cell is
    % currently involved in a 12+ month drought (0 otherwise).

    prolonged_drought(:,:,ii) = (drought_duration(:,:,ii)>=24);

end

% removes non-drought events from the average_intensity calculation
sum_drought_event = sum_drought_event.*current_drought_array; 
% prevent division by 0 when computing averages
drought_dur_no_zeros = drought_duration;
drought_dur_no_zeros(drought_dur_no_zeros==0) = 1;

average_intensity  =  sum_drought_event ./ drought_dur_no_zeros;

clearvars sum_drought_event...
         drought_dur_no_zeros...
         drought_forward_count...
         drought_backward_count...
         current_sdi_layer
     
