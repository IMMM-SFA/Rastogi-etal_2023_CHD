load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
drght_ints        = "extreme_drought"
drght_indx        = "spi"
drght_dur         = "06"
hw_thresh         = "t95"
hw_length         = "3days"
fmask             = addfile("fmask.nc","r")
mask1             = fmask->tmax(0,:,:)
year              = ispan(1981,2100,1)
nyr               = dimsizes(year)
gcm               = asciiread("gcm.txt",-1,"string")
perhw_concur_gg   = new((/dimsizes(gcm),180,360/),"float")
perdr_concur_gg   = new((/dimsizes(gcm),180,360/),"float")
hw_ggyy           = new((/dimsizes(gcm),nyr,180,360/),"float")
dr_ggyy           = new((/dimsizes(gcm),nyr,180,360/),"float")
hd_ggyy           = new((/dimsizes(gcm),nyr,180,360/),"float")
hw_tmax_ggyy      = new((/dimsizes(gcm),nyr,180,360/),"float")
hd_tmax_ggyy      = new((/dimsizes(gcm),nyr,180,360/),"float")
hwonly_tmax_ggyy  = new((/dimsizes(gcm),nyr,180,360/),"float")
dr_drght_ggyy     = new((/dimsizes(gcm),nyr,180,360/),"float")
hd_drght_ggyy     = new((/dimsizes(gcm),nyr,180,360/),"float")
dronly_drght_ggyy = new((/dimsizes(gcm),nyr,180,360/),"float")


do gg = 0,dimsizes(gcm)-1
print(gcm(gg))
dataname          = gcm(gg)
dirt              = "./data/"
;Read lat lon
fll               = addfile("latlon.nc","r")

lat               = fll->lat
lon               = fll->lon
nlat              = dimsizes(lat)
nlon              = dimsizes(lon)
f1                = addfile("ext_days_tmax_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname+".1deg.nc","r")
f2                = addfile("ext_days_tmax_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname+"_ssp585.1deg.nc","r")
ext_days          = f1->ext_days
ext_daysf         = f2->ext_days

tmax_ext_days     = f1->tmax_ext_days
tmax_ext_daysf    = f2->tmax_ext_days

drght_ext_days    = f1->drght_ext_days
drght_ext_daysf   = f2->drght_ext_days

hd_tmax_ggyy(gg,0:33,:,:)  = tmax_ext_days(:,3,:,:)
hd_tmax_ggyy(gg,34:,:,:)   = tmax_ext_daysf(:,3,:,:)

hd_drght_ggyy(gg,0:33,:,:)  = drght_ext_days(:,3,:,:)
hd_drght_ggyy(gg,34:,:,:)   = drght_ext_daysf(:,3,:,:)


hw_ggyy(gg,0:33,:,:)  = ext_days(:,1,:,:)
dr_ggyy(gg,0:33,:,:)  = ext_days(:,2,:,:)
hd_ggyy(gg,0:33,:,:)  = ext_days(:,3,:,:)

hw_ggyy(gg,34:,:,:)  = ext_daysf(:,1,:,:)
dr_ggyy(gg,34:,:,:)  = ext_daysf(:,2,:,:)
hd_ggyy(gg,34:,:,:)  = ext_daysf(:,3,:,:)

end do
hw_hisgg  = dim_avg_n_Wrap(hw_ggyy(:,0:39,:,:),1)
hw_ssp1gg = dim_avg_n_Wrap(hw_ggyy(:,40:79,:,:),1)
hw_ssp2gg = dim_avg_n_Wrap(hw_ggyy(:,80:119,:,:),1)
 
dr_hisgg  = dim_avg_n_Wrap(dr_ggyy(:,0:39,:,:),1)
dr_ssp1gg = dim_avg_n_Wrap(dr_ggyy(:,40:79,:,:),1)
dr_ssp2gg = dim_avg_n_Wrap(dr_ggyy(:,80:119,:,:),1)

hd_hisgg  = dim_avg_n_Wrap(hd_ggyy(:,0:39,:,:),1)
hd_ssp1gg = dim_avg_n_Wrap(hd_ggyy(:,40:79,:,:),1)
hd_ssp2gg = dim_avg_n_Wrap(hd_ggyy(:,80:119,:,:),1)

hd_tmax_hisgg  = dim_avg_n_Wrap(hd_tmax_ggyy(:,0:39,:,:),1)
hd_tmax_ssp1gg = dim_avg_n_Wrap(hd_tmax_ggyy(:,40:79,:,:),1)
hd_tmax_ssp2gg = dim_avg_n_Wrap(hd_tmax_ggyy(:,80:119,:,:),1)

hd_drght_hisgg  = dim_avg_n_Wrap(hd_drght_ggyy(:,0:39,:,:),1)
hd_drght_ssp1gg = dim_avg_n_Wrap(hd_drght_ggyy(:,40:79,:,:),1)
hd_drght_ssp2gg = dim_avg_n_Wrap(hd_drght_ggyy(:,80:119,:,:),1)

mask1C = conform(hw_hisgg,mask1,(/1,2/))
hw_hisgg = where(ismissing(mask1C),hw_hisgg@_FillValue,hw_hisgg)
hw_ssp1gg = where(ismissing(mask1C),hw_ssp1gg@_FillValue,hw_ssp1gg)
hw_ssp2gg = where(ismissing(mask1C),hw_ssp2gg@_FillValue,hw_ssp2gg)

hd_tmax_hisgg = where(ismissing(mask1C),hd_tmax_hisgg@_FillValue,hd_tmax_hisgg)
hd_tmax_ssp1gg = where(ismissing(mask1C),hd_tmax_ssp1gg@_FillValue,hd_tmax_ssp1gg)
hd_tmax_ssp2gg = where(ismissing(mask1C),hd_tmax_ssp2gg@_FillValue,hd_tmax_ssp2gg)

dr_hisgg = where(ismissing(mask1C),dr_hisgg@_FillValue,dr_hisgg)
dr_ssp1gg = where(ismissing(mask1C),dr_ssp1gg@_FillValue,dr_ssp1gg)
dr_ssp2gg = where(ismissing(mask1C),dr_ssp2gg@_FillValue,dr_ssp2gg)

hd_drght_hisgg = where(ismissing(mask1C),hd_drght_hisgg@_FillValue,hd_drght_hisgg)
hd_drght_ssp1gg = where(ismissing(mask1C),hd_drght_ssp1gg@_FillValue,hd_drght_ssp1gg)
hd_drght_ssp2gg = where(ismissing(mask1C),hd_drght_ssp2gg@_FillValue,hd_drght_ssp2gg)

hw_hisgg = where(hw_hisgg.eq.0,hw_hisgg@_FillValue,hw_hisgg)
hw_ssp1gg = where(hw_ssp1gg.eq.0,hw_ssp1gg@_FillValue,hw_ssp1gg)
hw_ssp2gg = where(hw_ssp2gg.eq.0,hw_ssp2gg@_FillValue,hw_ssp2gg)

dr_hisgg = where(dr_hisgg.eq.0,dr_hisgg@_FillValue,dr_hisgg)
dr_ssp1gg = where(dr_ssp1gg.eq.0,dr_ssp1gg@_FillValue,dr_ssp1gg)
dr_ssp2gg = where(dr_ssp2gg.eq.0,dr_ssp2gg@_FillValue,dr_ssp2gg)

hd_hisgg = where(ismissing(mask1C),hd_hisgg@_FillValue,hd_hisgg)
hd_ssp1gg = where(ismissing(mask1C),hd_ssp1gg@_FillValue,hd_ssp1gg)
hd_ssp2gg = where(ismissing(mask1C),hd_ssp2gg@_FillValue,hd_ssp2gg)

hw_diff1gg = hw_ssp1gg - hw_hisgg
hw_diff2gg = hw_ssp2gg - hw_hisgg

hd_tmax_diff1gg = hd_tmax_ssp1gg - hd_tmax_hisgg
hd_tmax_diff2gg = hd_tmax_ssp2gg - hd_tmax_hisgg

dr_diff1gg = dr_ssp1gg - dr_hisgg
dr_diff2gg = dr_ssp2gg - dr_hisgg

hd_drght_diff1gg = hd_drght_ssp1gg - hd_drght_hisgg
hd_drght_diff2gg = hd_drght_ssp2gg - hd_drght_hisgg

hw_diff1gg = hw_ssp1gg - hw_hisgg
hw_diff2gg = hw_ssp2gg - hw_hisgg

hd_diff1gg = hd_ssp1gg - hd_hisgg
hd_diff2gg = hd_ssp2gg - hd_hisgg


hw_diff1 = dim_avg_n_Wrap(hw_diff1gg,0)
hw_diff2 = dim_avg_n_Wrap(hw_diff2gg,0)

dr_diff1 = dim_avg_n_Wrap(dr_diff1gg,0)
dr_diff2 = dim_avg_n_Wrap(dr_diff2gg,0)

hd_diff1 = dim_avg_n_Wrap(hd_diff1gg,0)
hd_diff2 = dim_avg_n_Wrap(hd_diff2gg,0)


hw_his = dim_avg_n_Wrap(hw_hisgg,0)
dr_his = dim_avg_n_Wrap(dr_hisgg,0)
hd_his = dim_avg_n_Wrap(hd_hisgg,0)

hw_ssp1 = dim_avg_n_Wrap(hw_ssp1gg,0)
dr_ssp1 = dim_avg_n_Wrap(dr_ssp1gg,0)
hd_ssp1 = dim_avg_n_Wrap(hd_ssp1gg,0)

hw_ssp2 = dim_avg_n_Wrap(hw_ssp2gg,0)
dr_ssp2 = dim_avg_n_Wrap(dr_ssp2gg,0)
hd_ssp2 = dim_avg_n_Wrap(hd_ssp2gg,0)
hw_hisgg!1= "lat"
hw_hisgg!2="lon"
hw_hisgg&lat = lat
hw_hisgg&lon = lon
copy_VarCoords(hw_hisgg,dr_hisgg)
copy_VarCoords(hw_hisgg,hd_hisgg)
copy_VarCoords(hw_hisgg,dr_ssp1gg)
copy_VarCoords(hw_hisgg,hd_ssp1gg)
copy_VarCoords(hw_hisgg,hw_ssp1gg)
copy_VarCoords(hw_hisgg,dr_ssp2gg)
copy_VarCoords(hw_hisgg,hd_ssp2gg)
copy_VarCoords(hw_hisgg,hw_ssp2gg)
do gg = 0,dimsizes(gcm)-1
print(gcm(gg))
dataname   = gcm(gg)
lat1 = 24
lat2 = 53

lon1 = 235
lon2 = 295
fileout   = "ext_days_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname+"_his_ssp.1deg.nc"
system("rm "+fileout)
f1        = addfile(fileout,"c")
f1->hw_his        = hw_hisgg(gg,{lat1:lat2},{lon1:lon2})
f1->hw_ssp1       = hw_ssp1gg(gg,{lat1:lat2},{lon1:lon2})
f1->hw_ssp2       = hw_ssp2gg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_his        = hd_hisgg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_ssp1       = hd_ssp1gg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_ssp2       = hd_ssp2gg(gg,{lat1:lat2},{lon1:lon2})
f1->dr_his        = dr_hisgg(gg,{lat1:lat2},{lon1:lon2})
f1->dr_ssp1       = dr_ssp1gg(gg,{lat1:lat2},{lon1:lon2})
f1->dr_ssp2       = dr_ssp2gg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_tmax_his   = hd_tmax_hisgg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_tmax_ssp1  = hd_tmax_ssp1gg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_tmax_ssp2  = hd_tmax_ssp2gg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_drght_his  = hd_drght_hisgg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_drght_ssp1 = hd_drght_ssp1gg(gg,{lat1:lat2},{lon1:lon2})
f1->hd_drght_ssp2 = hd_drght_ssp2gg(gg,{lat1:lat2},{lon1:lon2})

end do

end
