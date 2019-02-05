        .data
        .balign 8
        .global season
season_m: .dword  win_s,spr_s,sum_s,fal_s

        .balign 8
        .global month
month_m:  .dword jan_m,feb_m,mar_m,apr_m,may_m,jun_m,jul_m,aug_m,sep_m,nov_m,dec_m

        .balign 8
        .global suffix
suffix_m: .dword st_m,nd_m,rd_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,st_m,nd_m,rd_m,th_m,th_m,th_m,th_m,th_m,th_m,th_m,st_m

        .text
jan_m:	.string	"January"
feb_m:	.string	"February"
mar_m:	.string	"March"
apr_m:	.string	"April"
may_m:	.string "May"
jun_m:	.string	"June"
jul_m:	.string "July"
aug_m:	.string	"August"
sep_m:	.string	"September"
oct_m:	.string	"October"
nov_m:	.string	"November"
dec_m:	.string	"December"

st_m:     .string "st"
nd_m:     .string "nd"
rd_m:     .string "rd"
th_m:     .string "th"

win_s: .string "Winter"
spr_s: .string "Spring"
sum_s: .string "Summer"
fal_s: .string "Fall"

fmt:    .string "%s %d%s is %s\n"
fmt2:   .string "%s\n"
        
error:  .string "usage: a5b mm dd\n"
        define(season_r,x25)
        define(month_r,x22)
        define(suffix_r,x21)
        define(i_r,w22)
        define(j_r,w23)
       
        .balign 4
        .global main

main:   stp    x29,x30,[sp,-16]!
        mov    x29,sp
         
        mov  w19,1
        mov  x20,x1 
        ldr  x0,[x20,w19,sxtw 3]
        bl   atoi
        mov  i_r,w0                  //the first arg is put in i_r
        
        mov  w19,2
        ldr  x0,[x20,w19,sxtw 3]
        bl   atoi
     
        mov  j_r,w0                  //the second arg is put in j_r
        mov  w0,0
        mov  x19,0
        mov  x20,0
      
         cmp    i_r,1                //checking if i_r is less than 1 because month start from 1
         b.lt   error1
         cmp    i_r,12               //checking if i_r is greater than 12 because month end at 12
         b.gt   error1
        
         cmp    j_r,1             //checking if j_r is less than 1 because month  date start from 1
         b.lt   error1
         cmp    j_r,31            //checking if j_r is greater than 31 because month date end at 31
         b.gt   error1 
        

win_c:   cmp    i_r,12              //if month is december
         b.eq   check_11
         cmp    i_r,3               //if month is march
         b.eq   check1
         cmp    i_r,3               //if month is march or before march
         b.gt   spr_c
         b      win_p

check1:  cmp    j_r,20         //check if it march 21
         b.gt   spr_c


check_11:cmp    j_r,21        //check if it is december 20 or less
         b.lt   spr_c

win_p:   adrp   x0,fmt
         add    x0,x0,:lo12:fmt
         
         sub  i_r,i_r,1
         mov  w11,j_r

         adrp suffix_r,suffix_m     
         add  suffix_r,suffix_r,:lo12:suffix_m
         ldr  x3,[suffix_r,w11,SXTW 3]                    //3rd arg for number suffix
         
         mov  w9,0
         adrp season_r,season_m
         add  season_r,season_r,:lo12:season_m
         ldr  x4,[season_r,w9,SXTW 3]                  //4th arg for season

         adrp month_r,month_m
         add  month_r,month_r,:lo12:month_m
         mov  w10,i_r  
         ldr  x1,[month_r,w10,SXTW 3]                 //1st arg for month
         
         mov    w2,j_r                             //2nd arg for date in decimal
           
         bl     printf                            //calling the print

         b      done

spr_c:  cmp    i_r,3         //if month is june
        b.eq   check2
        cmp    i_r,6         //if month is june or before june
        b.gt   sum_c
        b      spr_p

check2: cmp    j_r,20               //check if it june 20
        b.gt   sum_c

spr_p:   adrp   x0,fmt
         add    x0,x0,:lo12:fmt

         sub  i_r,i_r,1
         mov  w11,j_r
         adrp suffix_r,suffix_m   
         add  suffix_r,suffix_r,:lo12:suffix_m
         ldr  x3,[suffix_r,w11,SXTW 3]                    //3rd arg for number suffix
         
         mov  w9,0
         adrp season_r,season_m
         add  season_r,season_r,:lo12:season_m
         ldr  x4,[season_r,w9,SXTW 3]                  //4th arg for season

         adrp month_r,month_m
         add  month_r,month_r,:lo12:month_m
         mov  w10,i_r  
         ldr  x1,[month_r,w10,SXTW 3] 

         mov    w2,j_r                                 //2nd arg date decimal
         bl     printf

         b      done

sum_c:  cmp    i_r,9           //if month is September
        b.eq   check3
        cmp    i_r,9           //if month is September or before September
        b.gt   fal_c
        b      sum_p

check3:  cmp    j_r,20           //check if it September 20
         b.gt   fal_c

sum_p:   adrp   x0,fmt
         add    x0,x0,:lo12:fmt

         sub  i_r,i_r,1
         mov  w11,j_r
         adrp suffix_r,suffix_m     
         add  suffix_r,suffix_r,:lo12:suffix_m
         ldr  x3,[suffix_r,w11,SXTW 3]                    //3rd arg for number suffix
         
         mov  w9,0
         adrp season_r,season_m
         add  season_r,season_r,:lo12:season_m
         ldr  x4,[season_r,w9,SXTW 3]                  //4th arg for season

         adrp month_r,month_m
         add  month_r,month_r,:lo12:month_m
         mov  w10,i_r  
         ldr  x1,[month_r,w10,SXTW 3]                  //1st arg for month

         mov    w2,j_r                                 //2nd arg date decimal
         bl     printf                               //calling the print
         
         b      done

fal_c:   cmp    i_r,9                 //if month is September or after
         b.eq   check4

check4:  cmp    j_r,21
         b.gt   fal_p

fal_p:   adrp   x0,fmt
         add    x0,x0,:lo12:fmt

         sub  i_r,i_r,1
         mov  w11,j_r
         adrp suffix_r,suffix_m     
         add  suffix_r,suffix_r,:lo12:suffix_m
         ldr  x3,[suffix_r,w11,SXTW 3]                    //3rd arg for number suffix
         
         mov  w9,0
         adrp season_r,season_m
         add  season_r,season_r,:lo12:season_m
         ldr  x4,[season_r,w9,SXTW 3]                  //4th arg for season

         adrp month_r,month_m
         add  month_r,month_r,:lo12:month_m
         mov  w10,i_r  
         ldr  x1,[month_r,w10,SXTW 3] 

         mov    w2,j_r                                 //2nd arg date decimal
         bl     printf                               //calling the print

         b      done

error1: adrp   x0,error
        add    x0,x0,:lo12:error
        bl     printf

done:   mov  w0,0
        ldp  x29,x30,[sp],16
        ret 
