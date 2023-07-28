load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
 dir             = "./data/"
 drght_ints      = "extreme_drought"
;Run for spi and spei
 drght_indx      = "spei"
 drght_dur       = "06"
 hw_thresh       = "t95"
 hw_length       = "3days"
 dataname        = "ERA5"
 dataname1       = "ERA5"
 fmask           = addfile("fmask.nc","r")
 mask1           = fmask->tmax(0,:,:)
 year            = ispan(1981,2100,1)
 nyr             = dimsizes(year)
 gcm             = asciiread(dir+"gcm.txt",-1,"string")
 perhw_concur_gg = new((/dimsizes(gcm),180,360/),"float")
 perdr_concur_gg = new((/dimsizes(gcm),180,360/),"float")
 hw_ggyy         = new((/dimsizes(gcm),nyr,180,360/),"float")
 dr_ggyy         = new((/dimsizes(gcm),nyr,180,360/),"float")
 hd_ggyy         = new((/dimsizes(gcm),nyr,180,360/),"float")
 hd_tmax_ggyy    = new((/dimsizes(gcm),nyr,180,360/),"float")
 hd_drght_ggyy   = new((/dimsizes(gcm),nyr,180,360/),"float")


 do gg           = 0,dimsizes(gcm)-1
 print(gcm(gg))
 dataname        = gcm(gg)
 dataname1       = gcm(gg)
 dataname2       = gcm(gg)
 dirt            = "./data/"
;Read lat lon
 fll             = addfile("latlon.nc","r")

 lat             = fll->lat
 lon             = fll->lon
 nlat            = dimsizes(lat)
 nlon            = dimsizes(lon)
 f1              = addfile(dir+"ext_days_tmax_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname1+".1deg.nc","r")
 f2              = addfile(dir+"ext_days_tmax_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname1+"_ssp585.1deg.nc","r")
 ext_days        = f1->ext_days(:,0:5,:,:)
 ext_daysf       = f2->ext_days(:,0:5,:,:)
 printVarSummary(ext_days)
 tmax_ext_days   = f1->tmax_ext_days(:,0:5,:,:)
 tmax_ext_daysf  = f2->tmax_ext_days(:,0:5,:,:)
 
 drght_ext_days  = f1->drght_ext_days(:,0:5,:,:)
 drght_ext_daysf = f2->drght_ext_days(:,0:5,:,:)

 hd_tmax_ggyy(gg,0:33,:,:)   = tmax_ext_days(:,3,:,:)
 hd_tmax_ggyy(gg,34:,:,:)    = tmax_ext_daysf(:,3,:,:)

 hd_drght_ggyy(gg,0:33,:,:)  = drght_ext_days(:,3,:,:)
 hd_drght_ggyy(gg,34:,:,:)   = drght_ext_daysf(:,3,:,:)

 hw_ggyy(gg,0:33,:,:)        = ext_days(:,1,:,:)
 dr_ggyy(gg,0:33,:,:)        = ext_days(:,2,:,:)
 hd_ggyy(gg,0:33,:,:)        = ext_days(:,3,:,:)
 
 hw_ggyy(gg,34:,:,:)         = ext_daysf(:,1,:,:)
 dr_ggyy(gg,34:,:,:)         = ext_daysf(:,2,:,:)
 hd_ggyy(gg,34:,:,:)         = ext_daysf(:,3,:,:)
 delete(ext_days)
 delete(ext_daysf)
end do
 hw_hisgg       = dim_avg_n_Wrap(hw_ggyy(:,0:39,:,:),1)
 hw_ssp1gg      = dim_avg_n_Wrap(hw_ggyy(:,40:79,:,:),1)
 hw_ssp2gg      = dim_avg_n_Wrap(hw_ggyy(:,80:119,:,:),1)
 
 dr_hisgg       = dim_avg_n_Wrap(dr_ggyy(:,0:39,:,:),1)
 dr_ssp1gg      = dim_avg_n_Wrap(dr_ggyy(:,40:79,:,:),1)
 dr_ssp2gg      = dim_avg_n_Wrap(dr_ggyy(:,80:119,:,:),1)

 hd_hisgg       = dim_avg_n_Wrap(hd_ggyy(:,0:39,:,:),1)
 hd_ssp1gg      = dim_avg_n_Wrap(hd_ggyy(:,40:79,:,:),1)
 hd_ssp2gg      = dim_avg_n_Wrap(hd_ggyy(:,80:119,:,:),1)

 hd_tmax_hisgg  = dim_avg_n_Wrap(hd_tmax_ggyy(:,0:39,:,:),1)
 hd_tmax_ssp1gg = dim_avg_n_Wrap(hd_tmax_ggyy(:,40:79,:,:),1)
 hd_tmax_ssp2gg = dim_avg_n_Wrap(hd_tmax_ggyy(:,80:119,:,:),1)

 hd_drght_hisgg  = dim_avg_n_Wrap(hd_drght_ggyy(:,0:39,:,:),1)
 hd_drght_ssp1gg = dim_avg_n_Wrap(hd_drght_ggyy(:,40:79,:,:),1)
 hd_drght_ssp2gg = dim_avg_n_Wrap(hd_drght_ggyy(:,80:119,:,:),1)

 mask1C          = conform(hw_hisgg,mask1,(/1,2/))
 hw_hisgg        = where(ismissing(mask1C),hw_hisgg@_FillValue,hw_hisgg)
 hw_ssp1gg       = where(ismissing(mask1C),hw_ssp1gg@_FillValue,hw_ssp1gg)
 hw_ssp2gg       = where(ismissing(mask1C),hw_ssp2gg@_FillValue,hw_ssp2gg)

 hd_tmax_hisgg   = where(ismissing(mask1C),hd_tmax_hisgg@_FillValue,hd_tmax_hisgg)
 hd_tmax_ssp1gg  = where(ismissing(mask1C),hd_tmax_ssp1gg@_FillValue,hd_tmax_ssp1gg)
 hd_tmax_ssp2gg  = where(ismissing(mask1C),hd_tmax_ssp2gg@_FillValue,hd_tmax_ssp2gg)

 dr_hisgg        = where(ismissing(mask1C),dr_hisgg@_FillValue,dr_hisgg)
 dr_ssp1gg       = where(ismissing(mask1C),dr_ssp1gg@_FillValue,dr_ssp1gg)
 dr_ssp2gg       = where(ismissing(mask1C),dr_ssp2gg@_FillValue,dr_ssp2gg)

 hd_drght_hisgg  = where(ismissing(mask1C),hd_drght_hisgg@_FillValue,hd_drght_hisgg)
 hd_drght_ssp1gg = where(ismissing(mask1C),hd_drght_ssp1gg@_FillValue,hd_drght_ssp1gg)
 hd_drght_ssp2gg = where(ismissing(mask1C),hd_drght_ssp2gg@_FillValue,hd_drght_ssp2gg)

 hw_hisgg        = where(hw_hisgg.eq.0,hw_hisgg@_FillValue,hw_hisgg)
 hw_ssp1gg       = where(hw_ssp1gg.eq.0,hw_ssp1gg@_FillValue,hw_ssp1gg)
 hw_ssp2gg       = where(hw_ssp2gg.eq.0,hw_ssp2gg@_FillValue,hw_ssp2gg)

 dr_hisgg        = where(dr_hisgg.eq.0,dr_hisgg@_FillValue,dr_hisgg)
 dr_ssp1gg       = where(dr_ssp1gg.eq.0,dr_ssp1gg@_FillValue,dr_ssp1gg)
 dr_ssp2gg       = where(dr_ssp2gg.eq.0,dr_ssp2gg@_FillValue,dr_ssp2gg)

 hd_hisgg        = where(ismissing(mask1C),hd_hisgg@_FillValue,hd_hisgg)
 hd_ssp1gg       = where(ismissing(mask1C),hd_ssp1gg@_FillValue,hd_ssp1gg)
 hd_ssp2gg       = where(ismissing(mask1C),hd_ssp2gg@_FillValue,hd_ssp2gg)

 perhw_concur_hisgg  = 100*(hd_hisgg/hw_hisgg)
 perhw_concur_ssp1gg = 100*(hd_ssp1gg/hw_ssp1gg)
 perhw_concur_ssp2gg = 100*(hd_ssp2gg/hw_ssp2gg)

 perdr_concur_hisgg  = 100*(hd_hisgg/dr_hisgg)
 perdr_concur_ssp1gg = 100*(hd_ssp1gg/dr_ssp1gg)
 perdr_concur_ssp2gg = 100*(hd_ssp2gg/dr_ssp2gg)

 hw_diff1gg      = hw_ssp1gg - hw_hisgg
 hw_diff2gg      = hw_ssp2gg - hw_hisgg

 hd_tmax_diff1gg = hd_tmax_ssp1gg - hd_tmax_hisgg
 hd_tmax_diff2gg = hd_tmax_ssp2gg - hd_tmax_hisgg

 dr_diff1gg      = dr_ssp1gg - dr_hisgg
 dr_diff2gg      = dr_ssp2gg - dr_hisgg

 hd_drght_diff1gg = hd_drght_ssp1gg - hd_drght_hisgg
 hd_drght_diff2gg = hd_drght_ssp2gg - hd_drght_hisgg

 hw_diff1gg       = hw_ssp1gg - hw_hisgg
 hw_diff2gg       = hw_ssp2gg - hw_hisgg

 hd_diff1gg       = hd_ssp1gg - hd_hisgg
 hd_diff2gg       = hd_ssp2gg - hd_hisgg

 perhw_concur_diff1gg = perhw_concur_ssp1gg - perhw_concur_hisgg
 perhw_concur_diff2gg = perhw_concur_ssp2gg - perhw_concur_hisgg
 
 perdr_concur_diff1gg = perdr_concur_ssp1gg - perdr_concur_hisgg
 perdr_concur_diff2gg = perdr_concur_ssp2gg - perdr_concur_hisgg
 
;mask1C = conform(hw_gg,mask1,(/1,2/))
;hw_gg = where(ismissing(mask1C),hw_gg@_FillValue,hw_gg)
;dr_gg = where(ismissing(mask1C),dr_gg@_FillValue,dr_gg)
;dr_gg = where(dr_gg.eq.0,dr_gg@_FillValue,dr_gg)

 hw_diff1 = dim_avg_n_Wrap(hw_diff1gg,0)
 hw_diff2 = dim_avg_n_Wrap(hw_diff2gg,0)

 dr_diff1 = dim_avg_n_Wrap(dr_diff1gg,0)
 dr_diff2 = dim_avg_n_Wrap(dr_diff2gg,0)

 hd_diff1 = dim_avg_n_Wrap(hd_diff1gg,0)
 hd_diff2 = dim_avg_n_Wrap(hd_diff2gg,0)

 hd_tmax_diff1 = dim_avg_n_Wrap(hd_tmax_diff1gg,0)
 hd_tmax_diff2 = dim_avg_n_Wrap(hd_tmax_diff2gg,0)

 hd_drght_diff1 = dim_avg_n_Wrap(hd_drght_diff1gg,0)
 hd_drght_diff2 = dim_avg_n_Wrap(hd_drght_diff2gg,0)

 perhw_concur_diff1 = dim_avg_n_Wrap(perhw_concur_diff1gg,0)
 perhw_concur_diff2 = dim_avg_n_Wrap(perhw_concur_diff2gg,0)
 perdr_concur_diff1 = dim_avg_n_Wrap(perdr_concur_diff1gg,0)
 perdr_concur_diff2 = dim_avg_n_Wrap(perdr_concur_diff2gg,0)

 hw_his = dim_avg_n_Wrap(hw_hisgg,0)
 dr_his = dim_avg_n_Wrap(dr_hisgg,0)
 hd_his = dim_avg_n_Wrap(hd_hisgg,0)
 perhw_concur_his = dim_avg_n_Wrap(perhw_concur_hisgg,0)
 perdr_concur_his = dim_avg_n_Wrap(perdr_concur_hisgg,0)

 hw_ssp1 = dim_avg_n_Wrap(hw_ssp1gg,0)
 dr_ssp1 = dim_avg_n_Wrap(dr_ssp1gg,0)
 hd_ssp1 = dim_avg_n_Wrap(hd_ssp1gg,0)
 perhw_concur_ssp1 = dim_avg_n_Wrap(perhw_concur_ssp1gg ,0)
 perdr_concur_ssp1 = dim_avg_n_Wrap(perdr_concur_ssp1gg ,0)

 hw_ssp2 = dim_avg_n_Wrap(hw_ssp2gg,0)
 dr_ssp2 = dim_avg_n_Wrap(dr_ssp2gg,0)
 hd_ssp2 = dim_avg_n_Wrap(hd_ssp2gg,0)
 perhw_concur_ssp2 = dim_avg_n_Wrap(perhw_concur_ssp2gg ,0)
 perdr_concur_ssp2 = dim_avg_n_Wrap(perdr_concur_ssp2gg ,0)

 hw_his&lat = lat
 hw_his&lon = lon
 copy_VarCoords(hw_his,dr_his)
 copy_VarCoords(hw_his,hd_his)
 copy_VarCoords(hw_his,perhw_concur_his)
 copy_VarCoords(hw_his,perdr_concur_his)

 copy_VarCoords(hw_his,hw_ssp1)
 copy_VarCoords(hw_his,dr_ssp1)
 copy_VarCoords(hw_his,hd_ssp1)
 copy_VarCoords(hw_his,perhw_concur_ssp1)
 copy_VarCoords(hw_his,perdr_concur_ssp1)

 copy_VarCoords(hw_his,hw_ssp2)
 copy_VarCoords(hw_his,dr_ssp2)
 copy_VarCoords(hw_his,hd_ssp2)
 copy_VarCoords(hw_his,perhw_concur_ssp2)
 copy_VarCoords(hw_his,perdr_concur_ssp2)

 copy_VarCoords(hw_his,hw_diff1)
 copy_VarCoords(hw_his,dr_diff1)
 copy_VarCoords(hw_his,hd_diff1)
 copy_VarCoords(hw_his,perhw_concur_diff1)
 copy_VarCoords(hw_his,perdr_concur_diff1)
 copy_VarCoords(hw_his,hw_diff2)
 copy_VarCoords(hw_his,dr_diff2)
 copy_VarCoords(hw_his,hd_diff2)
 copy_VarCoords(hw_his,perhw_concur_diff2)
 copy_VarCoords(hw_his,perdr_concur_diff2)

 copy_VarCoords(hw_his,hd_tmax_diff1)
 copy_VarCoords(hw_his,hd_tmax_diff2)
 copy_VarCoords(hw_his,hd_drght_diff1)
 copy_VarCoords(hw_his,hd_drght_diff2)


 wks                        = gsn_open_wks ("pdf", "FigureS2")
 setvalues NhlGetWorkspaceObjectId()
 "wsMaximumSize" : 300000000
 end setvalues
 plot                       = new ( 20, "graphic" )
 gsn_define_colormap (wks, "MPL_RdBu")
 res                        = True               ; plot mods desired
 ;cmap                      = gsn_retrieve_colormap(wks)
 ;cmap(2:,:)                = cmap(2::-1,:)
 ;gsn_define_colormap(wks,cmap)
 res@gsnDraw                = False
 res@gsnFrame               = False
 res@cnRasterModeOn         = True
 res@cnFillOn               = True
 res@cnLinesOn              = False
 res@cnLineLabelsOn         = False
 res@gsnSpreadColors        = True               ; use total colormap
 res@cnInfoLabelOn          = False
 res@pmTickMarkDisplayMode  = "Always"
 res@tiMainFontHeightF      = 0.020
 res@gsnAddCyclic           = True
 res@cnConstFEnableFill     = True
 lat                        = fll->lat
 lon                        = fll->lon
 res@mpLimitMode            = "Corners"            ; choose range of map
 res@mpLeftCornerLatF       = 23
 res@mpLeftCornerLonF       = -126
 res@mpRightCornerLatF      = 50
 res@mpRightCornerLonF      = -66
 res@tiMainOffsetYF         = 0.
 res@cnLevelSelectionMode   = "ExplicitLevels"
 res@cnLevelSelectionMode   = "AutomaticLevels"
 res@cnLevelSelectionMode   = "ManualLevels"
 res@mpPerimOn              = True
 res@tfDoNDCOverlay         = True ; do not transform data
 res@mpLandFillColor        = "white"
 res@mpOutlineBoundarySets  = "NoBoundaries"
 res@mpUSStateLineColor     = "Black"
 res@mpNationalLineColor    = "Black"
 res@mpGeophysicalLineColor = "Black"

 hw_his!0                   = "lat"
 hw_his!1                   = "lon"
 hw_his&lat                 = lat
 hw_his&lon                 = lon

 copy_VarCoords(hw_his,dr_his)
 copy_VarCoords(hw_his,hd_his)
 copy_VarCoords(hw_his,perhw_concur_his)
 copy_VarCoords(hw_his,perdr_concur_his)

 copy_VarCoords(hw_his,hw_ssp1)
 copy_VarCoords(hw_his,dr_ssp1)
 copy_VarCoords(hw_his,hd_ssp1)
 copy_VarCoords(hw_his,perhw_concur_ssp1)
 copy_VarCoords(hw_his,perdr_concur_ssp1)

 copy_VarCoords(hw_his,hw_ssp2)
 copy_VarCoords(hw_his,dr_ssp2)
 copy_VarCoords(hw_his,hd_ssp2)
 copy_VarCoords(hw_his,perhw_concur_ssp2)
 copy_VarCoords(hw_his,perdr_concur_ssp2)

 copy_VarCoords(hw_his,hw_diff1)
 copy_VarCoords(hw_his,dr_diff1)
 copy_VarCoords(hw_his,hd_diff1)
 copy_VarCoords(hw_his,perhw_concur_diff1)
 copy_VarCoords(hw_his,perdr_concur_diff1)
 copy_VarCoords(hw_his,hw_diff2)
 copy_VarCoords(hw_his,dr_diff2)
 copy_VarCoords(hw_his,hd_diff2)
 copy_VarCoords(hw_his,perhw_concur_diff2)
 copy_VarCoords(hw_his,perdr_concur_diff2)

 res@cnLevelSpacingF        = 5.0
 res@cnMinLevelValF         = -50.0
 res@cnMaxLevelValF         = 50
 res@lbLabelStride          = 2
 res@tiMainString           = "No. of HW days "
 plot(0)                    = gsn_csm_contour_map(wks,hw_diff1(:,:),res)
 plot(6)                    = gsn_csm_contour_map(wks,hw_diff2(:,:),res)

if(drght_indx.eq."spei") then
 res@cnLevelSpacingF        = 5.0
 res@cnMinLevelValF         = -45.0
 res@cnMaxLevelValF         = 45
else
 res@cnLevelSpacingF        = 1.0
 res@cnMinLevelValF         = -8.0
 res@cnMaxLevelValF         = 8
end if

 res@lbLabelStride          = 2
 res@tiMainString           = "No. of  Drought days "
 plot(1)                    = gsn_csm_contour_map(wks,dr_diff1(:,:),res)
 plot(7)                    = gsn_csm_contour_map(wks,dr_diff2(:,:),res)

if(drght_indx.eq."spei") then
 res@cnLevelSpacingF        = 5.0
 res@cnMinLevelValF         = -45.0
 res@cnMaxLevelValF         = 45
else
 res@cnLevelSpacingF        = 1.0
 res@cnMinLevelValF         = -8.0
 res@cnMaxLevelValF         = 8
end if
 res@lbLabelStride          = 2
 res@tiMainString           = "No. of Concurrent days "
 plot(2)                    = gsn_csm_contour_map(wks,hd_diff1(:,:),res)
 plot(8)                    = gsn_csm_contour_map(wks,hd_diff2(:,:),res)

 res@cnLevelSpacingF        = 0.2
 res@cnMinLevelValF         = -3.0
 res@cnMaxLevelValF         = 3
 res@lbLabelStride          = 2
 res@tiMainString           = "Heatwave Intensity "
 plot(3)                    = gsn_csm_contour_map(wks,hd_tmax_diff1(:,:),res)
 delete(res@cnMaxLevelValF)

 res@tiMainString           = "Drought Intensity "

if(drght_indx.eq."spei") then
 res@cnLevelSpacingF        = 0.1
 res@cnMinLevelValF         = -1.0
 res@cnMaxLevelValF         = 1.0
else
 res@cnLevelSpacingF        = 0.025
 res@cnMinLevelValF         = -0.2
 res@cnMaxLevelValF         = 0.2
end if

 res@lbLabelStride          = 2
 plot(4)                    = gsn_csm_contour_map(wks,hd_drght_diff1(:,:),res)

 res@cnLevelSpacingF        = 0.2
 res@cnMinLevelValF         = -3.0
 res@cnMaxLevelValF         = 3.0
 res@lbLabelStride          = 2
 res@tiMainString           = "HW Intensity "
 plot(9)                    = gsn_csm_contour_map(wks,hd_tmax_diff2(:,:),res)
 delete(res@cnMaxLevelValF)

 res@tiMainString           = "Drought Intensity "

if(drght_indx.eq."spei") then
 res@cnLevelSpacingF        = 0.1
 res@cnMinLevelValF         = -1.0
 res@cnMaxLevelValF         = 1.0
else
 res@cnLevelSpacingF        = 0.025
 res@cnMinLevelValF         = -0.2
 res@cnMaxLevelValF         = 0.2
end if

 res@lbLabelStride          = 2
 plot(10)                   = gsn_csm_contour_map(wks,hd_drght_diff2(:,:),res)
 gsn_panel(wks,(/plot/),(/4,3/),False)


end
