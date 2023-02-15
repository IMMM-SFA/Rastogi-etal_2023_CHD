import numpy as np
import netCDF4 as nc
import seaborn as sns
import matplotlib.pyplot as plt
import scipy
from scipy.stats import pearsonr

#This script creates scatter plots for Figure 6
gcm =('ACCESS-CM2','ACCESS-ESM1-5','BCC-CSM2-MR','CNRM-CM6-1-HR','CNRM-CM6-1','CNRM-ESM2-1',\
'CanESM5','EC-Earth3-Veg','FGOALS-g3','HadGEM3-GC31-LL','HadGEM3-GC31-MM','INM-CM4-8','INM-CM5-0',\
'IPSL-CM6A-LR','KACE-1-0-G','MIROC-ES2L','MIROC6','MPI-ESM1-2-HR','MPI-ESM1-2-LR','MRI-ESM2-0','NorESM2-LM',\
'NorESM2-MM','UKESM1-0-LL')
drght_indx = 'spei'
dir        = './data/'
year       = np.arange(1981,2101,1)
nyear      = np.shape(year)[0]

concur_all_his_ssp_tmax = np.zeros([np.shape(gcm)[0],nyear,92,29,61], dtype=np.float64)
concur_all_his_ssp_tmax  = np.ma.masked_values(concur_all_his_ssp_tmax, 0.)
concur_all_his_ssp_tmax.set_fill_value(9.969209968386869e+36)

concur_all_his_ssp_slhf = np.zeros([np.shape(gcm)[0],nyear,92,29,61], dtype=np.float64)
concur_all_his_ssp_slhf  = np.ma.masked_values(concur_all_his_ssp_slhf, 0.)
concur_all_his_ssp_slhf.set_fill_value(9.969209968386869e+36)

concur_all_his_ssp_sshf = np.zeros([np.shape(gcm)[0],nyear,92,29,61], dtype=np.float64)
concur_all_his_ssp_sshf  = np.ma.masked_values(concur_all_his_ssp_sshf, 0.)
concur_all_his_ssp_sshf.set_fill_value(9.969209968386869e+36)

for gg in np.arange(np.shape(gcm)[0]):
    print(gcm[gg])
    f1h = nc.Dataset(f'{dir}hw_intensities_t95_3days_{drght_indx}_extreme_drought_06_{gcm[gg]}.1deg.nc')
    f1s = nc.Dataset(f'{dir}hw_intensities_t95_3days_{drght_indx}_extreme_drought_06_{gcm[gg]}_ssp585.1deg.nc')
    f1h_slhf = nc.Dataset(f'{dir}slhf_intensities_t95_3days_{drght_indx}_extreme_drought_06_{gcm[gg]}.1deg.nc')
    f1s_slhf = nc.Dataset(f'{dir}slhf_intensities_t95_3days_{drght_indx}_extreme_drought_06_{gcm[gg]}_ssp585.1deg.nc')
    f1h_sshf = nc.Dataset(f'{dir}sshf_intensities_t95_3days_{drght_indx}_extreme_drought_06_{gcm[gg]}.1deg.nc')
    f1s_sshf = nc.Dataset(f'{dir}sshf_intensities_t95_3days_{drght_indx}_extreme_drought_06_{gcm[gg]}_ssp585.1deg.nc')

    concur_all_his_ssp_tmax[gg,0:34,:,:,:] = np.asarray(f1h['concur'])
    concur_all_his_ssp_slhf[gg,0:34,:,:,:] = np.asarray(f1h_slhf['concur'])
    concur_all_his_ssp_sshf[gg,0:34,:,:,:] = np.asarray(f1h_sshf['concur'])

    concur_all_his_ssp_tmax[gg,34:,:,:,:] = np.asarray(f1s['concur'])
    concur_all_his_ssp_slhf[gg,34:,:,:,:] = np.asarray(f1s_slhf['concur'])
    concur_all_his_ssp_sshf[gg,34:,:,:,:] = np.asarray(f1s_sshf['concur'])

concur_all_his_ssp_tmax = np.where(concur_all_his_ssp_tmax == 9.969209968386869e+36,np.nan,concur_all_his_ssp_tmax)
concur_all_his_ssp_tmax = np.where(concur_all_his_ssp_tmax == 0,np.nan,concur_all_his_ssp_tmax)

concur_all_his_ssp_slhf = np.where(concur_all_his_ssp_slhf == 9.969209968386869e+36,np.nan,concur_all_his_ssp_slhf)
concur_all_his_ssp_slhf = np.where(concur_all_his_ssp_slhf == 0,np.nan,concur_all_his_ssp_slhf)

concur_all_his_ssp_sshf = np.where(concur_all_his_ssp_sshf == 9.969209968386869e+36,np.nan,concur_all_his_ssp_sshf)
concur_all_his_ssp_sshf = np.where(concur_all_his_ssp_sshf == 0,np.nan,concur_all_his_ssp_sshf)

ef = concur_all_his_ssp_slhf/(concur_all_his_ssp_slhf+concur_all_his_ssp_sshf )

dir     = '/global/cfs/cdirs/m2702/im3-climtask/compound_extremes/CMIP6/'
f1state = nc.Dataset(f'{dir}state_USextent.nc')
state1  = np.asarray(f1state['state1deg'])[:,:]
state   = np.broadcast_to(state1, (np.shape(gcm)[0],nyear,92,29,61))
sw  = np.where(((state == 21) | (state == 22) | (state == 23) | (state == 35)),state,np.nan)
sc  = np.where(((state == 39) | (state == 40) | (state == 36) | (state == 46)),state,np.nan)
se  = np.where(((state == 37) | (state == 38) | (state == 41) | (state == 42) \
             | (state == 43)  | (state == 44) | (state == 45) | (state == 47)),state,np.nan)
nw  = np.where(((state == 0) | (state == 7) | (state == 10)),state,np.nan)
mw  = np.where(((state == 6) | (state == 9) | (state == 12) | (state == 20) \
             | (state == 24)  | (state == 25) | (state == 34) | (state == 48)),state,np.nan)
nc  = np.where(((state == 1) | (state == 3) | (state == 4) | (state == 5) \
             | (state == 14)  | (state == 30) | (state == 32) ),state,np.nan)
ne  = np.where(((state == 2) | (state == 8) | (state == 11) | (state == 13) \
            | (state == 15)  | (state == 16) | (state == 17) | (state == 18) \
            | (state == 19)  | (state == 27) | (state == 28) | (state == 29)\
            | (state == 31)  | (state == 33) | (state == 26) ),state,np.nan)

regions = ("CONUS","southwest","southcentral","southeast","northwest","midwest","northcentral","northeast")
fig, ax = plt.subplots(2,np.shape(regions)[0],  figsize=(32,8))
for rr in np.arange(np.shape(regions)[0]):
    if(regions[rr] == "CONUS"):
        concur_all_his_ssp_tmax_rr = concur_all_his_ssp_tmax
        ef_rr = ef
    if(regions[rr] == "southwest"):
        concur_all_his_ssp_tmax_rr = np.where(np.isnan(sw),np.nan,concur_all_his_ssp_tmax)
        ef_rr = np.where(np.isnan(sw),np.nan,ef)
    if(regions[rr] == "southcentral"):
        concur_all_his_ssp_tmax_rr = np.where(np.isnan(sc),np.nan,concur_all_his_ssp_tmax)
        ef_rr = np.where(np.isnan(sc),np.nan,ef)
    if(regions[rr] == "southeast"):
        concur_all_his_ssp_tmax_rr = np.where(np.isnan(se),np.nan,concur_all_his_ssp_tmax)
        ef_rr = np.where(np.isnan(se),np.nan,ef)
    if(regions[rr] == "northwest"):
        concur_all_his_ssp_tmax_rr= np.where(np.isnan(nw),np.nan,concur_all_his_ssp_tmax)
        ef_rr = np.where(np.isnan(nw),np.nan,ef)
    if(regions[rr] == "midwest"):
        concur_all_his_ssp_tmax_rr = np.where(np.isnan(mw),np.nan,concur_all_his_ssp_tmax)
        ef_rr = np.where(np.isnan(mw),np.nan,ef)
    if(regions[rr] == "northcentral"):
        concur_all_his_ssp_tmax_rr = np.where(np.isnan(nc),np.nan,concur_all_his_ssp_tmax)
        ef_rr = np.where(np.isnan(nc),np.nan,ef)
    if(regions[rr] == "northeast"):
        concur_all_his_ssp_tmax_rr = np.where(np.isnan(ne),np.nan,concur_all_his_ssp_tmax)
        ef_rr = np.where(np.isnan(ne),np.nan,ef)
    ef_h    = np.nanmean(ef_rr[:,0:40,:,:,:],axis=(1,2,3,4))
    ef_s1   = np.nanmean(ef_rr[:,40:80,:,:,:],axis=(1,2,3,4))
    ef_s2   = np.nanmean(ef_rr[:,80:,:,:,:],axis=(1,2,3,4))
    ef_s    = np.nanmean(ef_rr[:,40:,:,:,:],axis=(1,2,3,4))
    tmax_h  = np.nanmean(concur_all_his_ssp_tmax_rr[:,0:40,:,:,:],axis=(1,2,3,4))
    tmax_s1 = np.nanmean(concur_all_his_ssp_tmax_rr[:,40:80,:,:,:],axis=(1,2,3,4))
    tmax_s2 = np.nanmean(concur_all_his_ssp_tmax_rr[:,80:,:,:,:],axis=(1,2,3,4))   
    tmax_s  = np.nanmean(concur_all_his_ssp_tmax_rr[:,40:,:,:,:],axis=(1,2,3,4))
    color   = ["#6B53A3","#7D4C9E","#723B7A","#3A00B0","#0000FF","#31449A","#033CAF","#A4DAD3",\
               "#005C50","#116B37","#08B30F","#24B24B","#FFDB58","#FFBF00","#FF8000","#FF7F24",\
               "#CD661D","#FF4000","#FF0000","#FA1B50","#F535A0","#99226D","#570024"]
    ax[0,rr].scatter(ef_s1-ef_h,tmax_s1-tmax_h,color=color,s=50)
    ax[1,rr].scatter(ef_s2-ef_h,tmax_s2-tmax_h,color=color,s=50)
    corr1 = pearsonr(ef_s1-ef_h,tmax_s1-tmax_h)
    corr2 = pearsonr(ef_s2-ef_h,tmax_s2-tmax_h)
    corr3 = pearsonr(ef_s-ef_h,tmax_s-tmax_h)
    ax[0,rr].set_title('{}_{}'.format(regions[rr],corr1))
    ax[1,rr].set_title('{}_{}'.format(regions[rr],corr2))
    ax[0,rr].set_title('{}_{}'.format(regions[rr],round(corr1[0],2)))
    ax[1,rr].set_title('{}_{}'.format(regions[rr],round(corr2[0],2)))
    ax[0,rr].set_title('{}_{}'.format(regions[rr],corr1[0]))
    ax[1,rr].set_title('{}_{}'.format(regions[rr],corr2[0]))
    ax[0,rr].set_ylim(-3,5)
    ax[1,rr].set_ylim(-3,7)
plt.savefig(f'Figure6_{drght_indx}.pdf')
