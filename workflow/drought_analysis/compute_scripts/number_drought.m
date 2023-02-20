function [numbered_var] = number_drought(drought_var, time_length) 

numbered_var = uint8(drought_var);
current_drought_num = uint8(ones(size(drought_var(:,:,1))));

for month=1:time_length
    if month>1
        % element-wise multiply the original array (1's and 0's) with the current_drought_num grid
        numbered_var(:,:,month) = numbered_var(:,:,month) .* current_drought_num;
        % grid with 1's in each grid cell experiencing a new drought event
        new_drought_event = uint8(drought_var(:,:,month) & ~drought_var(:,:,month-1));
        % use new_drought_event to interate current_drought_num
        current_drought_num = current_drought_num + new_drought_event;	
    end
end

end
