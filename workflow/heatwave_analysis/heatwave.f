C NCLFORTSTART

        subroutine main(x,nday,nlat,nlon,min_hw_start,max_break,
     +  min_subsequent,hw_days_all,sub_hw_days_all,break_days_all,
     +  hw_ix_all)

        INTEGER dd,xx,yy,nlat,nlon,nday,min_hw_start
        INTEGER max_break,min_subsequent
        INTEGER y(nday),x(nlon,nlat,nday)
        INTEGER hw_days_all(nlon,nlat,nday),hw_days(nday)
        INTEGER break_days_all(nlon,nlat,nday),break_days(nday)
        INTEGER sub_hw_days_all(nlon,nlat,nday),sub_hw_days(nday) 
        INTEGER hw_ix_all(nlon,nlat,nday),hw_ix(nday)
C NCLEND
C Loop through all lat lon
        do xx = 1,nlon
        do yy = 1,nlat
C Do calculations only for the grids without any missing data
        if(any(x(xx,yy,:).eq.-999)) then
C       print *, 0
 
       else 
C Print the grid point for which calculations is done
        print *,xx
        print *,yy
C Initialize heat wave start, break, subsequent heat wave days to 0
        hw_days = 0
        sub_hw_days = 0
        break_days = 0
        hw_ix = 0 
C Intialize y with x at that grid point and then calculate y as
C cummulative sum which restarts during the hot days break (i.e when 
C array hits 0)
        y(:) = x(xx,yy,:)
        do dd = 1, nday
                if(x(xx,yy,dd).eq.0) then
                       y(dd) = 0
                else
                        y(dd) = y(dd-1) +x(xx,yy,dd)
                end if
        end do
C Call the heatwave subroutine that identifies compound heat wave event 
C and returns arrays containing heatwave start, break, subsequent hot days
C time and length
        call heatwave(y,nday,min_hw_start,max_break,
     +  min_subsequent,hw_days,sub_hw_days,break_days,hw_ix)

C Store heatwave start,break,subsequent hot days time and length in
C gridded arrays

        hw_ix_all(xx,yy,:) = hw_ix
        hw_days_all(xx,yy,:) = hw_days
        sub_hw_days_all(xx,yy,:) = sub_hw_days
        break_days_all(xx,yy,:) = break_days


        end if
        end do
        end do
        END

C NCLFORTSTART

        subroutine heatwave(y,nday,min_hw_start,max_break,
     +  min_subsequent,hw_days,sub_hw_days,break_days,hw_ix)
        INTEGER current_ind,nday,i,hw_ind,min_hw_start
        INTEGER max_break,min_subsequent,ind,cc
        INTEGER hw_days(nday),sub_hw_days(nday)
        INTEGER y(nday),summer,break_days(nday)
        INTEGER hw_ix(nday),hw_strt_ix,hw_end_ix
C NCLEND
        i = 1
C summer variable is a switch to start/end summer season
        summer = 1
        cc = 0
        current_ind = 1
C Do these calculation while it is still summer
        do while(summer.eq.1)

C Look for start of heat wave
        if((y(i+1).eq.0.or.i.eq.nday).and.(y(i).ge.min_hw_start)) then
          cc = cc + 1
C Store the heat wave start length at the start index
          ind = i - (y(i)) + 1
          hw_strt_ix = ind
          hw_end_ix  = ind + y(i) - 1
          hw_ix(hw_strt_ix:hw_end_ix) = cc
          hw_days(ind) = y(i)

C Check for end of season
C hw_ind is a switch for the presence of a heat wave

           if(i.eq.nday) then
            hw_ind = 0
            summer = 0
           else      
            hw_ind = 1
           end if

C Look for break period if it is summer, while a heatwave is present 
C and i is less than nday
C Repeat the loop until it is summer and heat wave is present

           do while(summer.eq.1.and.hw_ind.eq.1.)

C Check if enough days are left in the season for break

           if(i+max_break.lt.nday) then

C Call the subroutine that checks break period

            call check_break(i,current_ind,y,nday,max_break,hw_ind,
     +                       break_days)

C Update i with the current position in the array
 
            i = current_ind

C Check if heat wave is still occuring (i.e. max break condition was met) 
C and sufficient days are left in the season for a subsequent heat wave

            if(hw_ind.eq.1.and.(i+min_subsequent).le.nday) then

C Call the subroutine that checks for subequent hot days
C This subroutine returns lenght of subsequent hot days if the 
C condition is met

               call check_subsequent_hdays(i,current_ind,nday,y,
     +                                     min_subsequent,hw_ind,
     +                                     sub_hw_days,hw_end_ix)
               hw_ix(hw_strt_ix:hw_end_ix) = cc

C Update i to current position in the array

               i = current_ind

C If insufficient days are left in the season to check for heat wave
C instead of calling check_subsequent_hdays subroutine
C turn summer and heat wave switch to off (0)

            else if((i+min_subsequent).gt.nday) then
               summer = 0
               hw_ind = 0
            end if

C If insufficient days are left in the season to check for break
C instead of calling check_break subroutine
C turn summer and heat wave switch to off (0)

           else
             summer = 0
             hw_ind = 0
             i = i +1
           end if

C Repeat the while loop until it is summer and heat wave is present

          end do     

C If no heatwave is found, increment the loop by 1 and look again            

           else
             i = i+1 
           end if

C Finally, check for end of season

          if(i.gt.nday) then
           summer = 0
          end if 

C Repeat until the end of summer

        end do

        RETURN
        END

C NCLFORTSTART

        subroutine check_break(ii,current_ind,y,nday,max_break,hw_ind,
     +                         break_days)
        INTEGER current_ind,nday,i,hw_ind
        INTEGER max_break,bb,ii
        INTEGER break_days(nday)
        INTEGER y(nday)

C NCLEND

C Check if max break condition fails

       if(sum(y(ii+1:ii+1+max_break)).eq.0) then

C if max break condition fails, increment the position in the array
C Set heatwave index (hw_ind) to 0

        current_ind =ii+1
C        break_days(ii+1) =0
        hw_ind = 0       

      else

C if max break condition is met, check for no, of break days

        do bb = ii+1,ii+max_break

            if(y(bb).eq.0) then
                current_ind = bb+1
                break_days(ii+1) = bb-ii           
            end if

        end do

       end if
       RETURN
       END

 
C NCLFORTSTART

        subroutine check_subsequent_hdays(jj,current_ind,nday,y,
     +   min_subsequent,hw_ind,sub_hw_days,hw_end_ix)
        INTEGER jj,ix,nday,current_ind,hw_ind
        INTEGER min_subsequent,check_subs,hw_end_ix
        INTEGER y(nday),sub_hw_days(nday)

C NCLEND
C Check for minimum subsequent hot days condition

       if(product(y(jj:jj+min_subsequent-1)).eq.0) then

C If the condition is false turn heat wave index (hd_ind) to 0 
C Increment in the array

        hw_ind = 0
        current_ind = jj+1
       else

C If condition is met,create a check subsequent days switch and 
C set it to 1

        check_subs = 1

        do  ix = jj,nday

            if(check_subs.eq.1)then

C Check for subsequent heat wave length

                if((y(ix+1).eq.0).or.(ix.eq.nday).and.(y(ix)
     +             .ge.min_subsequent)) then

                    sub_hw_days(jj) = y(ix)
                    current_ind = ix 
                        
                    hw_end_ix = ix
                    check_subs = 0

                end if
            
            else 

C If check_subs = 0 exit the loop

                 EXIT
            end if

        end do
         
       end if
        
       RETURN
       END
