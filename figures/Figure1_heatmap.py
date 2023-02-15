import numpy as np
import netCDF4 as nc
import seaborn as sns
import matplotlib.pyplot as plt
import scipy

#GCM names
gcm          = ('ACCESS-CM2','ACCESS-ESM1-5','BCC-CSM2-MR','CNRM-CM6-1-HR','CNRM-CM6-1','CNRM-ESM2-1',\
                'CanESM5','EC-Earth3-Veg','FGOALS-g3','HadGEM3-GC31-LL','HadGEM3-GC31-MM','INM-CM4-8',\
                'INM-CM5-0','IPSL-CM6A-LR','KACE-1-0-G','MIROC-ES2L','MIROC6','MPI-ESM1-2-HR','MPI-ESM1-2-LR',\
                'MRI-ESM2-0','NorESM2-LM','NorESM2-MM','UKESM1-0-LL')
#Metrics
metric       = ('No. of heatwave days','No. of drought days','No. of drought days SPEI', \
                'Average heatwave intensity','Average drought intensity','Average drought intensity SPEI',\
                '% HW days occuring as concurrent','% Drought days as occuring concurrent',\
                '% Drought days as occuring concurrent SPEI') 

#Create variables to store values
hm           = np.zeros(((np.shape(gcm)[0]),9),dtype="float")
hm           = np.ma.masked_values(hm, 0.)
hm_rel       = np.zeros(((np.shape(gcm)[0]),9),dtype="float")
hm_rel       = np.ma.masked_values(hm_rel, 0.)

hm_per       = np.zeros(((np.shape(gcm)[0]),9),dtype="float")
hm_per       = np.ma.masked_values(hm_per, 0.)
hm_per.set_fill_value(-999)

drght_indxc1 = "spi"
drght_indxc2 = "spei"
drght_intsc  = "extreme"
drght_durc   = "06"
hw_lengthc   = "3days"
hw_intsc     = "t95"
dir_PRISM    = './data/'
dir          = './data/'

# Read reference data 
fe           = nc.Dataset(f'{dir_PRISM}heatmap_stats_{hw_intsc}_{hw_lengthc}_{drght_indxc1}_{drght_intsc}_drought_{drght_durc}_PRISM.1deg.nc')
hw_daycount_OBS           = np.asarray(fe.variables['hw_daycount'])
drght_daycount_OBS        = np.asarray(fe.variables['drght_daycount'])
hw_ints_OBS               = np.asarray(fe.variables['hw_ints'])
drght_ints_OBS            = np.asarray(fe.variables['drght_ints'])
per_hwdays_concur_OBS     = np.asarray(fe.variables['per_hwdays_concur'])
per_drghtdays_concur_OBS  = np.asarray(fe.variables['per_drghtdays_concur'])

hw_count_OBS              = np.where(hw_count_OBS == -999.,np.nan,hw_count_OBS)
hw_length_OBS             = np.where(hw_length_OBS == -999.,np.nan,hw_length_OBS)
drght_count_OBS           = np.where(drght_count_OBS == -999.,np.nan,drght_count_OBS)
drght_length_OBS          = np.where(drght_length_OBS == -999.,np.nan,drght_length_OBS)
hw_daycount_OBS           = np.where(hw_daycount_OBS  == -999.,np.nan,hw_daycount_OBS )
drght_daycount_OBS        = np.where(drght_daycount_OBS  == -999.,np.nan,drght_daycount_OBS )
hw_ints_OBS               = np.where(hw_ints_OBS  == -999.,np.nan,hw_ints_OBS )
drght_ints_OBS            = np.where(drght_ints_OBS  == -999.,np.nan,drght_ints_OBS )
per_hwdays_concur_OBS     = np.where(per_hwdays_concur_OBS  == -999.,np.nan,per_hwdays_concur_OBS)
per_drghtdays_concur_OBS  = np.where(per_drghtdays_concur_OBS  == -999.,np.nan,per_drghtdays_concur_OBS)

fspei = nc.Dataset(f'{dir_PRISM}heatmap_stats_{hw_intsc}_{hw_lengthc}_{drght_indxc2}_{drght_intsc}_drought_{drght_durc}_PRISM.1deg.nc')
drght_count_OBS_SPEI           = np.asarray(fspei.variables['drght_count'])
drght_length_OBS_SPEI          = np.asarray(fspei.variables['drght_length'])
drght_daycount_OBS_SPEI        = np.asarray(fspei.variables['drght_daycount'])
drght_ints_OBS_SPEI            = np.asarray(fspei.variables['drght_ints'])
per_drghtdays_concur_OBS_SPEI  = np.asarray(fspei.variables['per_drghtdays_concur'])

drght_count_OBS_SPEI           = np.where(drght_count_OBS_SPEI == -999.,np.nan,drght_count_OBS_SPEI)
drght_length_OBS_SPEI          = np.where(drght_length_OBS_SPEI == -999.,np.nan,drght_length_OBS_SPEI)
drght_daycount_OBS_SPEI        = np.where(drght_daycount_OBS_SPEI  == -999.,np.nan,drght_daycount_OBS_SPEI )
drght_ints_OBS_SPEI            = np.where(drght_ints_OBS_SPEI  == -999.,np.nan,drght_ints_OBS_SPEI )
per_drghtdays_concur_OBS_SPEI  = np.where(per_drghtdays_concur_OBS_SPEI  == -999.,np.nan,per_drghtdays_concur_OBS_SPEI)

#Read GCM data and calculate bias
for gg in np.arange(np.shape(gcm)[0]):
    print(gg)
    print(gcm[gg])
    fe = nc.Dataset(f'{dir}heatmap_stats_{hw_intsc}_{hw_lengthc}_{drght_indxc1}_{drght_intsc}_drought_{drght_durc}_{gcm[gg]}.1deg.nc')
    hw_daycount           = np.asarray(fe.variables['hw_daycount'])
    drght_daycount        = np.asarray(fe.variables['drght_daycount'])
    hw_ints               = np.asarray(fe.variables['hw_ints'])
    drght_ints            = np.asarray(fe.variables['drght_ints'])
    per_hwdays_concur     = np.asarray(fe.variables['per_hwdays_concur'])
    per_drghtdays_concur  = np.asarray(fe.variables['per_drghtdays_concur'])
    
    hw_daycount           = np.where(hw_daycount  == -999.,np.nan,hw_daycount)
    drght_daycount        = np.where(drght_daycount  == -999.,np.nan,drght_daycount)
    hw_ints               = np.where(hw_ints  == -999.,np.nan,hw_ints )
    drght_ints            = np.where(drght_ints == -999.,np.nan,drght_ints )
    per_hwdays_concur     = np.where(per_hwdays_concur  == -999.,np.nan,per_hwdays_concur)
    per_drghtdays_concur  = np.where(per_drghtdays_concur  == -999.,np.nan,per_drghtdays_concur)

    fspei = nc.Dataset(f'{dir}heatmap_stats_{hw_intsc}_{hw_lengthc}_{drght_indxc2}_{drght_intsc}_drought_{drght_durc}_{gcm[gg]}.1deg.nc')
    drght_daycount_SPEI        = np.asarray(fspei.variables['drght_daycount'])
    drght_ints_SPEI            = np.asarray(fspei.variables['drght_ints'])
    per_drghtdays_concur_SPEI  = np.asarray(fspei.variables['per_drghtdays_concur'])
    
    drght_daycount_SPEI        = np.where(drght_daycount_SPEI  == -999.,np.nan,drght_daycount_SPEI)
    drght_ints_SPEI            = np.where(drght_ints_SPEI == -999.,np.nan,drght_ints_SPEI )
    per_drghtdays_concur_SPEI  = np.where(per_drghtdays_concur_SPEI  == -999.,np.nan,per_drghtdays_concur_SPEI)
    

    hm[gg,0] = np.nanmean(hw_daycount-hw_daycount_OBS)
    hm[gg,1] = np.nanmean(drght_daycount-drght_daycount_OBS)
    hm[gg,2] = np.nanmean(drght_daycount_SPEI-drght_daycount_OBS_SPEI)
    hm[gg,3] = np.nanmean(hw_ints-hw_ints_OBS)
    hm[gg,4] = np.nanmean(drght_ints-drght_ints_OBS)
    hm[gg,5] = np.nanmean(drght_ints_SPEI-drght_ints_OBS_SPEI )
    hm[gg,6] = np.nanmean(per_hwdays_concur-per_hwdays_concur_OBS)
    hm[gg,7] = np.nanmean(per_drghtdays_concur-per_drghtdays_concur_OBS)
    hm[gg,8] = np.nanmean(per_drghtdays_concur_SPEI-per_drghtdays_concur_OBS_SPEI)

#Calculate relative bias
for ii in np.arange(9):
    hm_rel[:,ii] = hm[:,ii]/np.abs(np.mean(hm[0:ngcm,ii]))

#Plotting
#Arrange by mean gcm bias, present absolute relative bias
val = np.mean(np.abs(hm_rel[:,:]),axis=1)
np.shape(val)
indx = np.argsort(val)
gcmnew = (gcm[indx[0]],gcm[indx[1]],gcm[indx[2]],gcm[indx[3]],gcm[indx[4]],gcm[indx[5]],gcm[indx[6]],\
          gcm[indx[7]],gcm[indx[8]],gcm[indx[9]],gcm[indx[10]],gcm[indx[11]],gcm[indx[12]],gcm[indx[13]],\
          gcm[indx[14]],gcm[indx[15]],gcm[indx[16]],gcm[indx[17]],gcm[indx[18]],gcm[indx[19]],gcm[indx[20]],\
              gcm[indx[21]],gcm[indx[22]])
fig, ax = plt.subplots(1, 2, figsize=(22,16))
sns.heatmap(np.transpose(hm_rel[indx,:]),vmin=-3,vmax=3,ax=ax[0],cmap='bwr',xticklabels=gcmnew,yticklabels=yticks)
sns.heatmap(np.transpose(hm_rel[indx,:]),vmin=-3,vmax=3,ax=ax[1],cmap='bwr_r',xticklabels=gcmnew,yticklabels=yticks)
ax[0].set_aspect("equal")
ax[1].set_aspect("equal")
plt.savefig('Figure1_heatmap.pdf')
