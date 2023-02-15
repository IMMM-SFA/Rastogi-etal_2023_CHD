import numpy as np
import netCDF4 as nc
import seaborn as sns
import matplotlib.pyplot as plt
import scipy
import pandas as pd
from scipy.stats import pearsonr

gcm =('ACCESS-CM2','ACCESS-ESM1-5','BCC-CSM2-MR','CNRM-CM6-1-HR','CNRM-CM6-1','CNRM-ESM2-1',\
'CanESM5','EC-Earth3-Veg','FGOALS-g3','HadGEM3-GC31-LL','HadGEM3-GC31-MM','INM-CM4-8','INM-CM5-0',\
'IPSL-CM6A-LR','KACE-1-0-G','MIROC-ES2L','MIROC6','MPI-ESM1-2-HR','MPI-ESM1-2-LR','MRI-ESM2-0','NorESM2-LM',\
'NorESM2-MM','UKESM1-0-LL')
drght_indx = 'spei'
dir = './data/'
year = np.arange(1981,2101,1)
nyear = np.shape(year)[0]

hw_his = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hw_his  = np.ma.masked_values(hw_his , 0.)
hw_his.set_fill_value(9.969209968386869e+36)

hw_ssp1 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hw_ssp1  = np.ma.masked_values(hw_ssp1 , 0.)
hw_ssp1.set_fill_value(9.969209968386869e+36)

hw_ssp2 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hw_ssp2  = np.ma.masked_values(hw_ssp2 , 0.)
hw_ssp2.set_fill_value(9.969209968386869e+36)

hd_tmax_his = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_tmax_his  = np.ma.masked_values(hd_tmax_his , 0.)
hd_tmax_his.set_fill_value(-999.)

hd_tmax_ssp1 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_tmax_ssp1  = np.ma.masked_values(hd_tmax_ssp1 , 0.)
hd_tmax_ssp1.set_fill_value(-999.)

hd_tmax_ssp2 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_tmax_ssp2  = np.ma.masked_values(hd_tmax_ssp2 , 0.)
hd_tmax_ssp2.set_fill_value(-999.)

hd_his = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_his  = np.ma.masked_values(hd_his , 0.)
hd_his.set_fill_value(9.969209968386869e+36)

hd_ssp1 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_ssp1  = np.ma.masked_values(hd_ssp1 , 0.)
hd_ssp1.set_fill_value(9.969209968386869e+36)

hd_ssp2 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_ssp2  = np.ma.masked_values(hd_ssp2 , 0.)
hd_ssp2.set_fill_value(9.969209968386869e+36)

dr_his = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
dr_his  = np.ma.masked_values(dr_his , 0.)
dr_his.set_fill_value(9.969209968386869e+36)

dr_ssp1 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
dr_ssp1  = np.ma.masked_values(dr_ssp1 , 0.)
dr_ssp1.set_fill_value(9.969209968386869e+36)

dr_ssp2 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
dr_ssp2  = np.ma.masked_values(dr_ssp2 , 0.)
dr_ssp2.set_fill_value(9.969209968386869e+36)

hd_drght_his = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_drght_his  = np.ma.masked_values(hd_drght_his , 0.)
hd_drght_his.set_fill_value(9.969209968386869e+36)

hd_drght_ssp1 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_drght_ssp1  = np.ma.masked_values(hd_drght_ssp1 , 0.)
hd_drght_ssp1.set_fill_value(9.969209968386869e+36)

hd_drght_ssp2 = np.zeros([np.shape(gcm)[0],29,61], dtype=np.float64)
hd_drght_ssp2  = np.ma.masked_values(hd_drght_ssp2 , 0.)
hd_drght_ssp2.set_fill_value(9.969209968386869e+36)

for gg in np.arange(np.shape(gcm)[0]):
    print(gcm[gg])
    f1h = nc.Dataset(f'{dir}ext_days_t95_3days_{drght_indx}_extreme_drought_06_{gcm[gg]}_his_ssp.1deg.nc')
    hw_his[gg,:,:] = np.asarray(f1h['hw_his'])
    hw_ssp1[gg,:,:] = np.asarray(f1h['hw_ssp1'])
    hw_ssp2[gg,:,:] = np.asarray(f1h['hw_ssp2'])
    hd_tmax_his[gg,:,:] = np.asarray(f1h['hd_tmax_his'])
    hd_tmax_ssp1[gg,:,:] = np.asarray(f1h['hd_tmax_ssp1'])
    hd_tmax_ssp2[gg,:,:] = np.asarray(f1h['hd_tmax_ssp2'])
    hd_his[gg,:,:] = np.asarray(f1h['hd_his'])
    hd_ssp1[gg,:,:] = np.asarray(f1h['hd_ssp1'])
    hd_ssp2[gg,:,:] = np.asarray(f1h['hd_ssp2'])
    dr_his[gg,:,:] = np.asarray(f1h['dr_his'])
    dr_ssp1[gg,:,:] = np.asarray(f1h['dr_ssp1'])
    dr_ssp2[gg,:,:] = np.asarray(f1h['dr_ssp2'])
    hd_drght_his[gg,:,:] = np.asarray(f1h['hd_drght_his'])
    hd_drght_ssp1[gg,:,:] = np.asarray(f1h['hd_drght_ssp1'])
    hd_drght_ssp2[gg,:,:] = np.asarray(f1h['hd_drght_ssp2'])

hd_tmax_his = np.where(hd_tmax_his == -999.,np.nan,hd_tmax_his)
hd_tmax_ssp1 = np.where(hd_tmax_ssp1 == -999.,np.nan,hd_tmax_ssp1)
hd_tmax_ssp2 = np.where(hd_tmax_ssp2 == -999.,np.nan,hd_tmax_ssp2)
dr_his = np.where(dr_his == 9.969209968386869e+36,np.nan,dr_his)
dr_ssp1 = np.where(dr_ssp1 == 9.969209968386869e+36,np.nan,dr_ssp1)
dr_ssp2 = np.where(dr_ssp2 == 9.969209968386869e+36,np.nan,dr_ssp2)
hd_drght_his = np.where(hd_drght_his == 9.969209968386869e+36,np.nan,hd_drght_his)
hd_drght_ssp1 = np.where(hd_drght_ssp1 == 9.969209968386869e+36,np.nan,hd_drght_ssp1)
hd_drght_ssp2 = np.where(hd_drght_ssp2 == 9.969209968386869e+36,np.nan,hd_drght_ssp2)
hd_his = np.where(hd_his == 9.969209968386869e+36,np.nan,hd_his)
hd_ssp1 = np.where(hd_ssp1 == 9.969209968386869e+36,np.nan,hd_ssp1)
hd_ssp2 = np.where(hd_ssp2 == 9.969209968386869e+36,np.nan,hd_ssp2)
hw_his = np.where(hw_his == 9.969209968386869e+36,np.nan,hw_his)
hw_ssp1 = np.where(hw_ssp1 == 9.969209968386869e+36,np.nan,hw_ssp1)
hw_ssp2 = np.where(hw_ssp2 == 9.969209968386869e+36,np.nan,hw_ssp2)

hw_diff1 = hw_ssp1-hw_his
hw_diff2 = hw_ssp2-hw_his
hd_tmax_diff1 = hd_tmax_ssp1-hd_tmax_his
hd_tmax_diff2 = hd_tmax_ssp2-hd_tmax_his
dr_diff1 = dr_ssp1-dr_his
dr_diff2 = dr_ssp2-dr_his
hd_drght_diff1 = hd_drght_ssp1-hd_drght_his
hd_drght_diff2 = hd_drght_ssp2-hd_drght_his
hd_diff1 = hd_ssp1-hd_his
hd_diff2 = hd_ssp2-hd_his

dir = '/global/cfs/cdirs/m2702/im3-climtask/compound_extremes/CMIP6/'
f1state = nc.Dataset(f'{dir}state_USextent.nc')
state1 = np.asarray(f1state['state1deg'])[:,:]
state = np.broadcast_to(state1, (np.shape(gcm)[0],29,61))
sw  = np.where(((state == 21) | (state == 22) | (state == 23) | (state == 35)),state,np.nan)
sc  = np.where(((state == 39) | (state == 40) | (state == 36) | (state == 46)),state,np.nan)
se  = np.where(((state == 37) | (state == 38) | (state == 41) | (state == 42) \
             | (state == 43)  | (state == 44) | (state == 45) | (state == 47)),state,np.nan)
nw  = np.where(((state == 0) | (state == 7) | (state == 10)),state,np.nan)
mw  = np.where(((state == 6) | (state == 9) | (state == 12) | (state == 20) \
             | (state == 24)  | (state == 25) | (state == 34) | (state == 48)),state,np.nan)
nc1  = np.where(((state == 1) | (state == 3) | (state == 4) | (state == 5) \
             | (state == 14)  | (state == 30) | (state == 32) ),state,np.nan)
ne  = np.where(((state == 2) | (state == 8) | (state == 11) | (state == 13) \
            | (state == 15)  | (state == 16) | (state == 17) | (state == 18) \
            | (state == 19)  | (state == 27) | (state == 28) | (state == 29)\
            | (state == 31)  | (state == 33) | (state == 26) ),state,np.nan)

hm1 = np.zeros((8,(np.shape(gcm)[0]),7),dtype="float")
hm2 = np.zeros((8,(np.shape(gcm)[0]),7),dtype="float")
regions = ("CONUS","southwest","southcentral","southeast","northwest","midwest","northcentral","northeast")
for rr in np.arange(np.shape(regions)[0]):
    if(regions[rr] == "CONUS"):
        hw_diff1_reg = hw_diff1
        hd_tmax_diff1_reg = hd_tmax_diff1
        dr_diff1_reg = dr_diff1
        hd_drght_diff1_reg = hd_drght_diff1
        hd_diff1_reg = hd_diff1


        hw_diff2_reg = hw_diff2
        hd_tmax_diff2_reg = hd_tmax_diff2
        dr_diff2_reg = dr_diff2
        hd_drght_diff2_reg = hd_drght_diff2
        hd_diff2_reg = hd_diff2

    if(regions[rr] == "southwest"):
        hw_diff1_reg = np.where(np.isnan(sw),np.nan,hw_diff1)
        hd_tmax_diff1_reg = np.where(np.isnan(sw),np.nan,hd_tmax_diff1)
        dr_diff1_reg = np.where(np.isnan(sw),np.nan,dr_diff1)
        hd_drght_diff1_reg = np.where(np.isnan(sw),np.nan,hd_drght_diff1)
        hd_diff1_reg = np.where(np.isnan(sw),np.nan,hd_diff1)

        hw_diff2_reg = np.where(np.isnan(sw),np.nan,hw_diff2)
        hd_tmax_diff2_reg = np.where(np.isnan(sw),np.nan,hd_tmax_diff2)
        dr_diff2_reg = np.where(np.isnan(sw),np.nan,dr_diff2)
        hd_drght_diff2_reg = np.where(np.isnan(sw),np.nan,hd_drght_diff2)
        hd_diff2_reg = np.where(np.isnan(sw),np.nan,hd_diff2)

    if(regions[rr] == "southcentral"):
        hw_diff1_reg = np.where(np.isnan(sc),np.nan,hw_diff1)
        hd_tmax_diff1_reg = np.where(np.isnan(sc),np.nan,hd_tmax_diff1)
        dr_diff1_reg = np.where(np.isnan(sc),np.nan,dr_diff1)
        hd_drght_diff1_reg = np.where(np.isnan(sc),np.nan,hd_drght_diff1)
        hd_diff1_reg = np.where(np.isnan(sc),np.nan,hd_diff1)

        hw_diff2_reg = np.where(np.isnan(sc),np.nan,hw_diff2)
        hd_tmax_diff2_reg = np.where(np.isnan(sc),np.nan,hd_tmax_diff2)
        dr_diff2_reg = np.where(np.isnan(sc),np.nan,dr_diff2)
        hd_drght_diff2_reg = np.where(np.isnan(sc),np.nan,hd_drght_diff2)
        hd_diff2_reg = np.where(np.isnan(sc),np.nan,hd_diff2)

    if(regions[rr] == "southeast"):
        hw_diff1_reg = np.where(np.isnan(se),np.nan,hw_diff1)
        hd_tmax_diff1_reg = np.where(np.isnan(se),np.nan,hd_tmax_diff1)
        dr_diff1_reg = np.where(np.isnan(se),np.nan,dr_diff1)
        hd_drght_diff1_reg = np.where(np.isnan(se),np.nan,hd_drght_diff1)
        hd_diff1_reg = np.where(np.isnan(se),np.nan,hd_diff1)

        hw_diff2_reg = np.where(np.isnan(se),np.nan,hw_diff2)
        hd_tmax_diff2_reg = np.where(np.isnan(se),np.nan,hd_tmax_diff2)
        dr_diff2_reg = np.where(np.isnan(se),np.nan,dr_diff2)
        hd_drght_diff2_reg = np.where(np.isnan(se),np.nan,hd_drght_diff2)
        hd_diff2_reg = np.where(np.isnan(se),np.nan,hd_diff2)

    if(regions[rr] == "northwest"):
        hw_diff1_reg = np.where(np.isnan(nw),np.nan,hw_diff1)
        hd_tmax_diff1_reg = np.where(np.isnan(nw),np.nan,hd_tmax_diff1)
        dr_diff1_reg = np.where(np.isnan(nw),np.nan,dr_diff1)
        hd_drght_diff1_reg = np.where(np.isnan(nw),np.nan,hd_drght_diff1)
        hd_diff1_reg = np.where(np.isnan(nw),np.nan,hd_diff1)


        hw_diff2_reg = np.where(np.isnan(nw),np.nan,hw_diff2)
        hd_tmax_diff2_reg = np.where(np.isnan(nw),np.nan,hd_tmax_diff2)
        dr_diff2_reg = np.where(np.isnan(nw),np.nan,dr_diff2)
        hd_drght_diff2_reg = np.where(np.isnan(nw),np.nan,hd_drght_diff2)
        hd_diff2_reg = np.where(np.isnan(nw),np.nan,hd_diff2)

    if(regions[rr] == "midwest"):
        hw_diff1_reg = np.where(np.isnan(mw),np.nan,hw_diff1)
        hd_tmax_diff1_reg = np.where(np.isnan(mw),np.nan,hd_tmax_diff1)
        dr_diff1_reg = np.where(np.isnan(mw),np.nan,dr_diff1)
        hd_drght_diff1_reg = np.where(np.isnan(mw),np.nan,hd_drght_diff1)
        hd_diff1_reg = np.where(np.isnan(mw),np.nan,hd_diff1)

        hw_diff2_reg = np.where(np.isnan(mw),np.nan,hw_diff2)
        hd_tmax_diff2_reg = np.where(np.isnan(mw),np.nan,hd_tmax_diff2)
        dr_diff2_reg = np.where(np.isnan(mw),np.nan,dr_diff2)
        hd_drght_diff2_reg = np.where(np.isnan(mw),np.nan,hd_drght_diff2)
        hd_diff2_reg = np.where(np.isnan(mw),np.nan,hd_diff2)

    if(regions[rr] == "northcentral"):
        hw_diff1_reg = np.where(np.isnan(nc1),np.nan,hw_diff1)
        hd_tmax_diff1_reg = np.where(np.isnan(nc1),np.nan,hd_tmax_diff1)
        dr_diff1_reg = np.where(np.isnan(nc1),np.nan,dr_diff1)
        hd_drght_diff1_reg = np.where(np.isnan(nc1),np.nan,hd_drght_diff1)
        hd_diff1_reg = np.where(np.isnan(nc1),np.nan,hd_diff1)


        hw_diff2_reg = np.where(np.isnan(nc1),np.nan,hw_diff2)
        hd_tmax_diff2_reg = np.where(np.isnan(nc1),np.nan,hd_tmax_diff2)
        dr_diff2_reg = np.where(np.isnan(nc1),np.nan,dr_diff2)
        hd_drght_diff2_reg = np.where(np.isnan(nc1),np.nan,hd_drght_diff2)
        hd_diff2_reg = np.where(np.isnan(nc1),np.nan,hd_diff2)

    if(regions[rr] == "northeast"):
        hw_diff1_reg = np.where(np.isnan(ne),np.nan,hw_diff1)
        hd_tmax_diff1_reg = np.where(np.isnan(ne),np.nan,hd_tmax_diff1)
        dr_diff1_reg = np.where(np.isnan(ne),np.nan,dr_diff1)
        hd_drght_diff1_reg = np.where(np.isnan(ne),np.nan,hd_drght_diff1)
        hd_diff1_reg = np.where(np.isnan(ne),np.nan,hd_diff1)


        hw_diff2_reg = np.where(np.isnan(ne),np.nan,hw_diff2)
        hd_tmax_diff2_reg = np.where(np.isnan(ne),np.nan,hd_tmax_diff2)
        dr_diff2_reg = np.where(np.isnan(ne),np.nan,dr_diff2)
        hd_drght_diff2_reg = np.where(np.isnan(ne),np.nan,hd_drght_diff2)
        hd_diff2_reg = np.where(np.isnan(ne),np.nan,hd_diff2)

    hw_diff1m =np.asarray(np.nanmean(hw_diff1_reg,axis=(1,2)))
    hw_diff2m =np.asarray(np.nanmean(hw_diff2_reg,axis=(1,2)))
    hd_tmax_diff1m = np.asarray(np.nanmean(hd_tmax_diff1_reg,axis=(1,2)))
    hd_tmax_diff2m = np.asarray(np.nanmean(hd_tmax_diff2_reg,axis=(1,2)))
    dr_diff1m = np.asarray(np.nanmean(dr_diff1_reg,axis=(1,2)))
    dr_diff2m = np.asarray(np.nanmean(dr_diff2_reg,axis=(1,2)))
    hd_drght_diff1m = np.asarray(np.nanmean(hd_drght_diff1_reg,axis=(1,2)))
    hd_drght_diff2m = np.asarray(np.nanmean(hd_drght_diff2_reg,axis=(1,2)))
    hd_diff1m = np.asarray(np.nanmean(hd_diff1_reg,axis=(1,2)))
    hd_diff2m = np.asarray(np.nanmean(hd_diff2_reg,axis=(1,2)))

    hm1[rr,:,0] = hd_diff1m
    hm1[rr,:,1] = dr_diff1m
    hm1[rr,:,2] = hw_diff1m
    hm1[rr,:,3] = hd_drght_diff1m
    hm1[rr,:,4] = hd_tmax_diff1m


    hm2[rr,:,0] = hd_diff2m
    hm2[rr,:,1] = dr_diff2m
    hm2[rr,:,2] = hw_diff2m
    hm2[rr,:,3] = hd_drght_diff2m
    hm2[rr,:,4] = hd_tmax_diff2m


titles = ('no of hw+drought','no of drought days','no of hw days','drght intensity (hd)','tmax during hd')
gcms =('ACCESS-CM2','ACCESS-ESM1-5','BCC-CSM2-MR','CNRM-CM6-1-HR','CNRM-CM6-1','CNRM-ESM2-1',\
'CanESM5','EC-Earth3-Veg','FGOALS-g3','HadGEM3-GC31-LL','HadGEM3-GC31-MM','INM-CM4-8','INM-CM5-0',\
'IPSL-CM6A-LR','KACE-1-0-G','MIROC-ES2L','MIROC6','MPI-ESM1-2-HR','MPI-ESM1-2-LR','MRI-ESM2-0','NorESM2-LM',\
'NorESM2-MM','UKESM1-0-LL','modelmean')

hmnew = np.zeros(((np.shape(gcm)[0]+1),5),dtype="float")
fig, ax = plt.subplots(5,8,figsize=(32,20))
indxrr = np.zeros((8,np.shape(gcm)[0]),dtype="int")
for rr in np.arange(np.shape(regions)[0]):

    indxrr[rr,:] = np.argsort(hm2[0,:,0])
    indx = indxrr[rr,:]

    hmnew[0:np.shape(gcm)[0],:] = hm2[rr,indx,0:5]
    hmnew[np.shape(gcm)[0],:] = np.mean(hmnew[0:np.shape(gcm)[0],:],axis=0)
    ax[0,rr].bar(gcms,hmnew[:,0],color  = ["#6B53A3","#7D4C9E","#723B7A","#3A00B0","#0000FF","#31449A","#033CAF","#A4DAD3",\
               "#005C50","#116B37","#08B30F","#24B24B","#FFDB58","#FFBF00","#FF8000","#FF7F24", "#CD661D","#FF4000","#FF0000",\
               "#FA1B50","#F535A0","#99226D","#570024","#000000"])
    ax[0,rr].set_ylim(0,50)

    ax[1,rr].bar(gcms,hmnew[:,1],color  = ["#6B53A3","#7D4C9E","#723B7A","#3A00B0","#0000FF","#31449A","#033CAF","#A4DAD3",\
               "#005C50","#116B37","#08B30F","#24B24B","#FFDB58","#FFBF00","#FF8000","#FF7F24", "#CD661D","#FF4000","#FF0000",\
               "#FA1B50","#F535A0","#99226D","#570024","#000000"])
    ax[1,rr].set_ylim(0,80)
    ax[2,rr].bar(gcms,hmnew[:,2],color  = ["#6B53A3","#7D4C9E","#723B7A","#3A00B0","#0000FF","#31449A","#033CAF","#A4DAD3",\
               "#005C50","#116B37","#08B30F","#24B24B","#FFDB58","#FFBF00","#FF8000","#FF7F24", "#CD661D","#FF4000","#FF0000",\
               "#FA1B50","#F535A0","#99226D","#570024","#000000"])
    ax[2,rr].set_ylim(0,60)
    ax[3,rr].bar(gcms,hmnew[:,3],color  = ["#6B53A3","#7D4C9E","#723B7A","#3A00B0","#0000FF","#31449A","#033CAF","#A4DAD3",\
               "#005C50","#116B37","#08B30F","#24B24B","#FFDB58","#FFBF00","#FF8000","#FF7F24", "#CD661D","#FF4000","#FF0000",\
               "#FA1B50","#F535A0","#99226D","#570024","#000000"])

    ax[3,rr].set_ylim(-0.8,0.1)
    ax[4,rr].bar(gcms,hmnew[:,4],color  = ["#6B53A3","#7D4C9E","#723B7A","#3A00B0","#0000FF","#31449A","#033CAF","#A4DAD3",\
               "#005C50","#116B37","#08B30F","#24B24B","#FFDB58","#FFBF00","#FF8000","#FF7F24", "#CD661D","#FF4000","#FF0000",\
               "#FA1B50","#F535A0","#99226D","#570024","#000000"])
    ax[4,rr].set_ylim(0,5)
    gcmnew = (gcm[indxrr[rr,0]],gcm[indxrr[rr,1]],gcm[indxrr[rr,2]],gcm[indxrr[rr,3]],gcm[indxrr[rr,4]],gcm[indxrr[rr,5]],gcm[indxrr[rr,6]],\
          gcm[indxrr[rr,7]],gcm[indxrr[rr,8]],gcm[indxrr[rr,9]],gcm[indxrr[rr,10]],gcm[indxrr[rr,11]],gcm[indxrr[rr,12]],gcm[indxrr[rr,13]],\
          gcm[indxrr[rr,14]],gcm[indxrr[rr,15]],gcm[indxrr[rr,16]],gcm[indxrr[rr,17]],gcm[indxrr[rr,18]],gcm[indxrr[rr,19]],gcm[indxrr[rr,20]],\
              gcm[indxrr[rr,21]],gcm[indxrr[rr,22]], "Modelmean")
    hmnewr = np.round(hmnew,3)

    ax[0,rr].set_xticklabels([])
    ax[1,rr].set_xticklabels([])
    ax[2,rr].set_xticklabels([])
    ax[3,rr].set_xticklabels([])
    ax[4,rr].set_xticklabels(gcmnew,fontsize=7,rotation=90)
    ax[0,rr].set_title(regions[rr])
    ax[1,0].set_title(titles[1])
    ax[2,0].set_title(titles[2])

ax[3,0].set_title(titles[3])
ax[4,0].set_title(titles[4])
plt.savefig(f'Figure5_{drght_indx}.pdf')
