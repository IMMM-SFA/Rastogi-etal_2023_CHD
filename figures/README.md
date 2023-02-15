## This file describes the workflow for creation of figures in Rastogi et al., 2023. The file paths and names need to be changed in the scripts.
1. Run process_extreme_data.ncl, count_extreme_grids.ncl, process_data_for_barplot.ncl and process_data_for_scatter.ncl for each of the drought indices and historical/future periods to process extremes data and generate files with heatwave, drought and concurrent heatwave-drought characteristics for plotting.
2. Run create_netcdf_for_plotting_fig1.ncl to read in the output from 1) and generate netcdf files for plotting Figure 1.
3. Run Figure1_spatial_maps.ncl and Figure1_heatmap.py for each of the drought indices to generate the spatial maps and heat maps for Figure 1.
4. Run Figure2.py to plot Figure 2.
5. Run Figure3.ncl for each of the drought indices to create Figure 3.
6. Run Figure4.py, Figure5.py and Figure6.py to generate Figures 4, 5 and 6 respectively.
7. Run FigureS1_spatial_maps.ncl and FigureS1_heatmap.py for each of the drought indices to generate the spatial maps and heat maps for Figure S1.
8. Run FigureS2.ncl for each of the drought indices to create Figure S2.
9.  FigureS3.py, FigureS4.py and FigureS5.py to plot Figures S3, S4 and S5.

