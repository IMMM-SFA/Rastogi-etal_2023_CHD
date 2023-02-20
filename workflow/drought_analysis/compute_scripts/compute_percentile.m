function [P_thresh] = compute_percentile(x, percent, dim)
% compute percentile threshold given a 2D array of data (x) and a percent 
% (ex percent 0.10 computes 10th percentile threshold value)
% 
% Returns a 2-D array the size of x(:,:,1)
%
x(x > 99) = NaN;

x_is_nan = single( isnan(x) );
num_nan_by_grid = sum(x_is_nan,dim);

x_inc = sort(x, dim); % all nan values are sorted as highest values

length_by_grid_ignore_nan = size(x,dim).*ones( size( x(:,:,1))); % 2D array containing length of time dimension
length_by_grid_ignore_nan = length_by_grid_ignore_nan - num_nan_by_grid; % subtract number of nan per grid

P_idx = percent*length_by_grid_ignore_nan;
P_idx = floor(P_idx);

nrows = size(x,1);
ncols = size(x,2);

rows = (1:nrows)';
rows = repmat(rows,1,ncols);

cols = 1:ncols;
cols = repmat(cols,nrows,1);

all_nans = (P_idx == 0);
P_idx(all_nans) = size(x,dim) - 1; % sets P_idx to length time vec - 1 if all nans

lin_idx_1 = sub2ind(size(x),rows,cols,P_idx);
lin_idx_2 = sub2ind(size(x),rows,cols,P_idx+1);

layer_1 = x_inc(lin_idx_1); % all grids full of NaNs will be set to NaN in layer_1 and 2
layer_2 = x_inc(lin_idx_2);

P_thresh = mean( cat(3,layer_1, layer_2) , 3, 'omitnan');


end
