import numpy as np
import netCDF4 as nc
import seaborn as sns
import matplotlib.pyplot as plt
import scipy
#This script creates stacked plots for Figure2

#Read GCM name
gcm        = ('ACCESS-CM2','ACCESS-ESM1-5','BCC-CSM2-MR','CMCC-ESM2','CNRM-CM6-1-HR','CNRM-CM6-1','CNRM-ESM2-1',\
              'CanESM5','EC-Earth3-Veg','FGOALS-g3','HadGEM3-GC31-LL','HadGEM3-GC31-MM','INM-CM4-8','INM-CM5-0',\
              'IPSL-CM6A-LR','KACE-1-0-G','MIROC-ES2L','MIROC6','MPI-ESM1-2-HR','MPI-ESM1-2-LR','NorESM2-LM',\
              'NorESM2-MM','UKESM1-0-LL')

drght_ints = "extreme"
drght_dur  = "06"

#Run for SPI and SPEI
drght_indx = "spei"

dir        = './data/'
year       = np.arange(1981,2101,1)

#Create new variables to store data

hw         = np.zeros([np.shape(gcm)[0],np.shape(year)[0]], dtype=np.float)
hw         = np.ma.masked_values(hw, 0.)
hw.set_fill_value(-999)

hd         = np.zeros([np.shape(gcm)[0],np.shape(year)[0]], dtype=np.float)
hd         = np.ma.masked_values(hd, 0.)
hd.set_fill_value(-999)

dr         = np.zeros([np.shape(gcm)[0],np.shape(year)[0]], dtype=np.float)
dr         = np.ma.masked_values(dr, 0.)
dr.set_fill_value(-999)

#Read GCM data
for gg in np.arange(np.shape(gcm)[0]):
    print(gcm[gg])
    count = np.zeros([np.shape(year)[0],92,7], dtype=np.float)
    count = np.ma.masked_values(count, 0.)
    count.set_fill_value(-999)
    fhis  = nc.Dataset(f'{dir}count_HW_t95_3days_{drght_indx}_{drght_ints}_drought_{drght_dur}_{gcm[gg]}_historical.nc')
    fssp  = nc.Dataset(f'{dir}count_HW_t95_3days_{drght_indx}_{drght_ints}_drought_{drght_dur}_{gcm[gg]}_ssp585.nc')
    count[0:34,:,:] = fhis['count'][:,:,:]
    count[34:,:,:]  = fssp['count'][:,:,:]
    hw1      = 100*(np.asarray(count[:,:,5])/np.asarray(count[:,:,0]))
    dr1      = 100*(np.asarray(count[:,:,6])/np.asarray(count[:,:,0]))
    hd1      = 100*(np.asarray(count[:,:,4])/np.asarray(count[:,:,0]))
    hw[gg,:] = np.mean(hw1,axis=1)
    dr[gg,:] = np.mean(dr1,axis=1)
    hd[gg,:] = np.mean(hd1,axis=1)

#Plotting
fig, ax      = plt.subplots(1, 1, figsize=(12,4))
year         = np.arange(1981,2101)
plt.stackplot(year,np.mean(hw,axis=0),np.mean(hd,axis=0),np.mean(dr,axis=0), labels=['Heat wave','Concur','Drght'],colors=["red","purple","orange"])
plt.legend(loc='upper left')
plt.ylim(0,80)
plt.xlim(1981,2100)
plt.ylabel('% CONUS Area')
plt.savefig('Figure2_{drght_indx}.pdf')
