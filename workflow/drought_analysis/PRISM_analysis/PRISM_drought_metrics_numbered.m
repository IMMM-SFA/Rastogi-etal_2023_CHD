%% Add paths and set path variables
addpath('...'); %% add path to PRISM_set_paths.m
PRISM_set_paths;

%% Filename for time, lat, lon
time_lat_lon_file = strcat(to_tp,'PRISM_tp_CONUS_monthly_198101_202012_1deg.nc');

%% Input Filenames
input_filename=cell(1,2);
input_filename{1} = strcat(to_spi,'PRISM_CONUS_1deg_monthly_198101_202012_spi_gamma_06.nc');
input_filename{2} = strcat(to_spei,'PRISM_CONUS_1deg_monthly_198101_202012_spei_gamma_06.nc');

%% Input file variable names
sdi_varname=cell(1,2);
sdi_varname{1} = 'spi_gamma_06';
sdi_varname{2} = 'spei_gamma_06';

%% Output filenames
output_filename=cell(1,2);
output_filename{1} = strcat(to_spi,'PRISM_CONUS_monthly_198101_202012_spi_06_drought_metrics_numbered.nc');
output_filename{2} = strcat(to_spei,'PRISM_CONUS_monthly_198101_202012_spei_06_drought_metrics_numbered.nc');

%% Output file variable names

output_vars = { 'extreme_drought',...
                'drought_5th_percentile',...
                'drought_2nd_percentile',...
                'drought_duration_extreme',...
                'prolonged_drought_extreme',...
                'average_intensity_extreme'...
                };

%% Read time_vec
time_vec = ncread(time_lat_lon_file,'time'); % units: hours since 1900-01-01 00:00:00.0
lat = ncread(time_lat_lon_file,'lat');
lon = ncread(time_lat_lon_file,'lon');

time_length = length(time_vec);

%% Start loop to calculate different drought metrics for SPI and SPEI 

for idx=1:length(input_filename)
	%%% create output netcdf file    
	out_file = output_filename{idx};

	nccreate(out_file, 'longitude', 'Dimensions', {'longitude',length(lon)});
	nccreate(out_file, 'latitude', 'Dimensions', {'latitude',length(lat)});
	nccreate(out_file, 'time', 'Dimensions', {'time',Inf});

	ncwrite(out_file, 'longitude', lon);
	ncwrite(out_file, 'latitude', lat);
	ncwrite(out_file, 'time', time_vec);

	ncwriteatt(out_file,'longitude','units','degrees_east');
	ncwriteatt(out_file,'latitude','units','degrees_north');
	ncwriteatt(out_file,'time','units','hours_since_1900_01_01_00:00:00');
   
	for kk=1:length(output_vars)
	    nccreate(out_file, output_vars{kk}, ...
	                        'Dimensions', {'longitude',length(lon),'latitude',length(lat),'time',Inf});
	end

	%%% read input netcdf file
	sdi = ncread(input_filename{idx},sdi_varname{idx}); % missing value fill value -32767
	sdi((sdi == -32767)) = 100; % replace missing value fill value with +100
	sdi((sdi == 9.96920996838687e+36)) = 100;

	sz_sdi = size(sdi);
	if sz_sdi(1)==480
	    sdi = permute(sdi,[2,3,1]);
	    disp('size sdi = ')
	    disp(size(sdi))
	else 
	    disp('size sdi = ')
	    disp(size(sdi))    
	end

	%% Define drought percentile arrays (threshold values obtained from normal distribution)
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

	%% Create 'drought_duration', 'prolonged_drought', and 'average_intensity'
	
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


