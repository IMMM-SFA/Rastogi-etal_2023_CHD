if strcmpi(scenario,'historical')
	year = 1980;
	leap = 1; % 1980 is a leap year
elseif strcmpi(scenario,'ssp585')
	year = 2015;
	leap = 0; % 2015 is not a leap year 
end

%%% iterate through directories
for f_path = {to_pr} % add to_pr_spei if necessary
	var = 'pr';
    disp(var);

    f_path = f_path{1};
    f_list = dir(f_path);    

    %%% iterate through files in directory
    for kk = 1:length(f_list)
        f_name = f_list(kk).name;
        f_full = fullfile(f_path, f_name);

	curr_units = ncreadatt(f_full, var, 'units');

	if strcmpi(curr_units,'mm')
		disp('units are already ')
		disp(curr_units)
		disp('not performing any conversion')
	else
		disp('previous unit was ');
		disp(cur_units)
		disp('converting to mm')

		if any(strfind(f_name,var))
			var_array = ncread(f_full, var);
	
			%%% iterate through all months in input files
			%%% and convert units from kg m-2 s-1 to mm month-1
			month = 1;
	
			for ll = 1:length(var_array(1,1,:))
	
				if any(month == [1,3,5,7,8,10,12]) %31 day months
					
					num_days = 31;
					var_array(:,:,ll) = var_array(:,:,ll).*86400.*num_days;

				elseif month == 2 %28 or 29 day month
					
					if leap
						num_days = 29;
						var_array(:,:,ll) = var_array(:,:,ll).*86400.*num_days;
					else
						num_days = 28;
						var_array(:,:,ll) = var_array(:,:,ll).*86400.*num_days;
					end

				else % 30 day months

					num_days = 30;
					var_array(:,:,ll) = var_array(:,:,ll).*86400.*num_days;
			
				end


				%%% reset one_twelve counter
				if mod(ll,12)==0
					year = year+1;
					month = 1;
				else
					month = month + 1;
				end

				%%% leap year after iterating year variable
				if mod(ll,12)==0
					if any(year == [1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008,...
					       		2012, 2016, 2020, 2024, 2028, 2032, 2036, 2040,...
						       	2044, 2048, 2052, 2056, 2060, 2064, 2068, 2072,...
						       	2076, 2080, 2084, 2088, 2092, 2096, 2104, 2108])
						leap = 1;
					else 
						leap = 0;
					end
				end
	
			end
 		%%% rename unit attribute
 		ncwrite(f_name, var, var_array);
		ncwriteatt(f_name, var, 'units', 'mm');
		end
	end

    end
end
