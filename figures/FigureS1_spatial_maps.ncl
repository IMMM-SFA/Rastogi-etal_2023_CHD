load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
 dir                       = "./data/"
 drght_intsc               = "extreme_drought"

;SPI/SPEI
 drght_indxc               = "spei"
 drght_durc                = "06"
 hw_threshc                = "t95"
 hw_lengthc                = "3days"

;ERA5/PRISM
 refdata                   = "ERA5"
 year                      = ispan(1981,2014,1)

;Read GCMs names
 gcm                       = asciiread(dir+"gcm.txt",-1,"string")
 ng                        = dimsizes(gcm)
 nlat                      = 29
 nlon                      = 61

;Create new variables to store values
 hw_daycount_diff          = new((/ng,nlat,nlon/),"float")
 drght_daycount_diff       = new((/ng,nlat,nlon/),"float")
 hw_ints_diff              = new((/ng,nlat,nlon/),"float")
 drght_ints_diff           = new((/ng,nlat,nlon/),"float")
 per_hwdays_concur_diff    = new((/ng,nlat,nlon/),"float")
 per_drghtdays_concur_diff = new((/ng,nlat,nlon/),"float")

;Read reference dataset
 if(refdata.eq."ERA5")then
 fe                        = addfile("../../ERA-land-1deg/heatmap_stats_"+hw_threshc+"_"+hw_lengthc+"_"+drght_indxc+"_"+drght_intsc+"_"+drght_durc+"_"+refdata+".1deg.nc","r")
else
 fe                        = addfile("../../"+refdata+"/heatmap_stats_"+hw_threshc+"_"+hw_lengthc+"_"+drght_indxc+"_"+drght_intsc+"_"+drght_durc+"_"+refdata+".1deg.nc","r")
end if

 hw_daycount_ERA            = fe->hw_daycount
 drght_daycount_ERA         = fe->drght_daycount
 hw_ints_ERA                = fe->hw_ints
 drght_ints_ERA             = fe->drght_ints
 per_hwdays_concur_ERA      = fe->per_hwdays_concur
 per_drghtdays_concur_ERA   = fe->per_drghtdays_concur

;Read GCM data
 do gg                      = 0,dimsizes(gcm)-1
 dataname1                  = gcm(gg)
 f1                         = addfile("heatmap_stats_"+hw_threshc+"_"+hw_lengthc+"_"+drght_indxc+"_"+drght_intsc+"_"+drght_durc+"_"+dataname1+".1deg.nc","r")

 hw_daycount_gg             = f1->hw_daycount
 drght_daycount_gg          = f1->drght_daycount
 hw_ints_gg                 = f1->hw_ints
 drght_ints_gg              = f1->drght_ints
 per_hwdays_concur_gg       = f1->per_hwdays_concur
 per_drghtdays_concur_gg    = f1->per_drghtdays_concur

;Calculate bias for each GCM
 hw_daycount_diff(gg,:,:)         = hw_daycount_gg - hw_daycount_ERA
 drght_daycount_diff(gg,:,:)      = drght_daycount_gg - drght_daycount_ERA
 hw_ints_diff(gg,:,:)		 = hw_ints_gg - hw_ints_ERA
 drght_ints_diff(gg,:,:)		 = drght_ints_gg - drght_ints_ERA
 per_hwdays_concur_diff(gg,:,:)   = per_hwdays_concur_gg - per_hwdays_concur_ERA 
 per_drghtdays_concur_diff(gg,:,:)= per_drghtdays_concur_gg - per_drghtdays_concur_ERA

end do


 drght_daycount_diff       = where(ismissing(drght_daycount_diff),0,drght_daycount_diff)
 drght_daycount_diff       = where(ismissing(hw_daycount_diff),drght_daycount_diff@_FillValue,drght_daycount_diff)
 drght_ints_diff           = where(ismissing(drght_ints_diff),0,drght_ints_diff)
 drght_ints_diff           = where(ismissing(hw_daycount_diff),drght_ints_diff@_FillValue,drght_ints_diff)
 per_drghtdays_concur_diff = where(ismissing(per_drghtdays_concur_diff),0,per_drghtdays_concur_diff)
 per_drghtdays_concur_diff = where(ismissing(hw_daycount_diff),per_drghtdays_concur_diff@_FillValue,per_drghtdays_concur_diff)

;Calculate multi-model mean bias 
 hw_daycount          = 10*dim_avg_n_Wrap(hw_daycount_diff,0)
 drght_daycount       = 10*dim_avg_n_Wrap(drght_daycount_diff,0)
 hw_ints              = dim_avg_n_Wrap(hw_ints_diff,0)
 drght_ints           = dim_avg_n_Wrap(drght_ints_diff,0)
 per_hwdays_concur    = dim_avg_n_Wrap(per_hwdays_concur_diff,0)
 per_drghtdays_concur = dim_avg_n_Wrap(per_drghtdays_concur_diff,0)

 lat                  = doubletofloat(f1->lat)
 lon                  = doubletofloat(f1->lon)
 lat@units            = "degrees_north"
 lon@units            = "degrees_east"
 hw_daycount!0        = "lat"
 hw_daycount!1        = "lon"
 hw_daycount&lat      = lat
 hw_daycount&lon      = lon
 copy_VarCoords(hw_daycount,drght_daycount)
 copy_VarCoords(hw_daycount,hw_ints)
 copy_VarCoords(hw_daycount,drght_ints)
 copy_VarCoords(hw_daycount,per_hwdays_concur)
 copy_VarCoords(hw_daycount,per_drghtdays_concur)

;Plotting
 wks                        = gsn_open_wks ("pdf", "FigureS1_"+drght_indxc+"_"+refdata)
 setvalues NhlGetWorkspaceObjectId()
 "wsMaximumSize" : 300000000
 end setvalues
 plot                       = new ( 20, "graphic" )
 gsn_define_colormap (wks,"BlRe")
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
 res@gsnAddCyclic           = False
 res@cnConstFEnableFill     = True
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
;res@tfDoNDCOverlay         = True ; do not transform data
 res@mpLandFillColor        = "white"
 res@mpOutlineBoundarySets  = "NoBoundaries"
 res@mpUSStateLineColor     = "Black"
 res@mpNationalLineColor    = "Black"
 res@mpGeophysicalLineColor = "Black"
 res@cnLevelSpacingF        = 2.0
 res@cnMinLevelValF         = -20.0
 res@cnMaxLevelValF         = 20.0
 res@lbLabelStride          = 2
 res@tiMainString           = "No. of HW days/decade "
 plot(0)                    = gsn_csm_contour_map(wks,hw_daycount(:,:),res)
 res@cnLevelSpacingF        = 3.0
 res@cnMinLevelValF         = -60.0
 res@cnMaxLevelValF         = 60.0
 res@lbLabelStride          = 2 
 res@tiMainString           = "No. of  Drought days/decade "
 plot(1)                    = gsn_csm_contour_map(wks,drght_daycount(:,:),res)
 res@cnLevelSpacingF        = 1.0
 res@cnMinLevelValF         = -8.
 res@cnMaxLevelValF         = 8.0
 res@lbLabelStride          = 2
 res@tiMainString           = " tmax during hw"
 plot(2)                    = gsn_csm_contour_map(wks,hw_ints(:,:),res)
 delete(res@cnMinLevelValF)
 delete(res@cnMaxLevelValF)
 res@cnLevelSpacingF        = 0.05
 res@cnMinLevelValF         = -1.0
 res@cnMaxLevelValF         = 1.0
 res@lbLabelStride          = 2
 res@tiMainString           = "drght intensities dur drought"
 plot(3)                    = gsn_csm_contour_map(wks,drght_ints(:,:),res)
 res@cnLevelSpacingF        = 4.0
 res@cnMinLevelValF         = -40.
 res@cnMaxLevelValF         = 40.0
 res@lbLabelStride          = 2
 res@tiMainString           = " % HW days occuring as Concurrent "
 plot(4)                    = gsn_csm_contour_map(wks,per_hwdays_concur(:,:),res)
 res@tiMainString           = " % Drought days as occuring as Concurrent "
 plot(5)                    = gsn_csm_contour_map(wks,per_drghtdays_concur(:,:),res)
 delete(res@cnMinLevelValF)
 delete(res@cnMaxLevelValF)
 gsn_panel(wks,(/plot/),(/3,2/),False)

end
