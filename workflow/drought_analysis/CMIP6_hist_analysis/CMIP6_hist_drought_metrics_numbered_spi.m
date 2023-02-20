%% Add paths and set path variables
addpath('...'); %% add path to CMIP6_hist_set_paths.m
CMIP6_hist_set_paths;

%% Loop through files in Directory
pr_files = dir(fullfile(to_pr, 'pr_Amon*'));

for ii = 1:length(pr_files)
	curr_file_base = pr_files(ii).name;
	curr_file_base = strrep(curr_file_base, '.nc', '');
	disp(curr_file_base);
	
	%% Obtain pr file path
	f_pr = strcat(to_pr, curr_file_base, '.nc');
	disp(f_pr);

	%% Obtain SPI file variable names
	sdi_varname=cell(1,1);
	sdi_varname{1} = 'spi_gamma_06';

	%% Obtain SPI file paths
	f_spi = cell(1,1);
	f_spi{1} = strcat(to_spi, curr_file_base, '_', sdi_varname{1}, '.nc');
	
	%% Obtain output filenames
	f_spi_met=cell(1,1);
	f_spi_met{1} = strcat(to_spi_met, curr_file_base, '_', sdi_varname{1}, '_drought_metrics_numbered', '.nc');
	
	%% Output file variable names
	output_vars = { 'extreme_drought',...
	                'drought_5th_percentile',...
        	        'drought_2nd_percentile',...
                	'drought_duration_extreme',...
                	'prolonged_drought_extreme',...
	                'average_intensity_extreme'...
        	        };

	%% Read time_vec
	time_vec = ncread(f_pr,'time'); % units: hours since 1900-01-01 00:00:00.0
	lat = ncread(f_pr,'lat');
	lon = ncread(f_pr,'lon');

	time_length = length(time_vec);

	%% Start loop to run the SPI files through the scripts

	idx=1;
    %%% create output netcdf file    
    out_file = f_spi_met{idx};

    nccreate(out_file, 'longitude', 'Dimensions', {'longitude',length(lon)});
    nccreate(out_file, 'latitude', 'Dimensions', {'latitude',length(lat)});
    nccreate(out_file, 'time', 'Dimensions', {'time',Inf});

    for kk=1:length(output_vars)
        nccreate(out_file, output_vars{kk}, ...
                        'Dimensions', {'longitude',length(lon),'latitude',length(lat),'time',Inf});
    end

    ncwrite(out_file, 'longitude', lon);
    ncwrite(out_file, 'latitude', lat);
    ncwrite(out_file, 'time', time_vec);

    ncwriteatt(out_file,'longitude','units','degrees_east');
    ncwriteatt(out_file,'latitude','units','degrees_north');
    ncwriteatt(out_file,'time','units','hours_since_1900_01_01_00:00:00');


    %%% read input netcdf file
    sdi = ncread(f_spi{idx},sdi_varname{idx}); % missing value fill value -32767
    sdi((sdi == -32767)) = 100; % replace missing value fill value with +100
    sdi((sdi == 9.96920996838687e+36)) = 100;

    sz_sdi = size(sdi);
    if (sz_sdi(1) ~= 360) && (sz_sdi(1) ~= 180) % then time is first dimension
        sdi = permute(sdi,[2,3,1]);
    end

    %% Define drought percentile arrays (thresholds values from normal distribution)
    sdi_5th_percentile = (sdi < -1.645);
    sdi_2nd_percentile = (sdi < -2.054);

    %% Create 'extreme_drought' Variable
    compute_extreme_drought; 
    extreme_drought = number_drought(uint8(extreme_drought), time_length);
    ncwrite(out_file,'extreme_drought', extreme_drought);

    %% Create 'drought_<%>_percentile' variables
    sdi_5th_percentile = number_drought(uint8(sdi_5th_percentile), time_length);
    ncwrite(out_file,'drought_5th_percentile', sdi_5th_percentile);

    sdi_2nd_percentile = number_drought(uint8(sdi_2nd_percentile), time_length);
    ncwrite(out_file,'drought_2nd_percentile', sdi_2nd_percentile);

    %% Create drought duration, prolonged drought, and avg drought variables
    intensity = 'extreme';

    current_drought_array = extreme_drought;
    drought_duration_varname = 'drought_duration_extreme';
    prolonged_drought_varname = 'prolonged_drought_extreme';
    average_intensity_varname = 'average_intensity_extreme';

    clearvars extreme_drought
    compute_duration_prolonged_average;

    ncwrite(out_file,drought_duration_varname,uint8(drought_duration));
    clearvars drought_duration
    ncwrite(out_file,prolonged_drought_varname,uint8(prolonged_drought));
    clearvars prolonged_drought
    ncwrite(out_file,average_intensity_varname,average_intensity);
    clearvars average_intensity

end
