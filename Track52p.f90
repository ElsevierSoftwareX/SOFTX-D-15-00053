	PROGRAM TRAG52p 
   
 !PROGRAM CALCULATES MAJOR AND MINOR AXES OF PROTON TRACK  CR 39 DETECTOR,  AS WELL AS TRACK DEPTH
  
 	  
DOUBLE PRECISION  THETA,THETAS,RANGE,PI,VB,REMOVED,TIME_ETCHING,X,VT
CHARACTER*1,   CONSTANTS 
COMMON VB,PI/ZONA1/RANGE/ZONA2/A1,A2,A3,A4,A5/ZONA3/KOJAF,CONSTANTS  


OPEN(10,FILE='INPUT.DAT')
OPEN(20, FILE='OUTRESULT.DAT')   
   
    						    								 
PI=4.D0*DATAN(1.D+0)	    	          
		       
PRINT *, 'PROGRAM TRACK_VISION proton 1.0'
PRINT *, 'CALCULATES TRACK PARAMETERS, MAJOR AND MINOR AXES AND DEPTH  OF PROTONS IN um  CR-39'
PRINT *, 'CALCULATES BLACK PART OF TRACK  '
print *, 'PLOT TRACK PROFILE AND TRACK OPENING CONTOUR'
PRINT *, 'PROGRAM SIMULATES LIGHT PROPAGATION THROUGH THE TRACK'
PRINT *, 'AUTHORS, D. NIKEZIC AND K.N.YU'
PRINT *, 'CITY UNIVERSITY OF HONG KONG'
PRINT *, 'E mail: nikezic@kg.ac.rs'
PRINT *, 'E mail: peter.yu@cityu.edu.hk'

PRINT *, 'READ INPUT DATA FROM FILE INPUT.DAT' 						    
  	  
   		  
READ(10,*) EPROTON          ! PROTON ENERGY IN MeV
READ(10,*) TIME_ETCHING		! ETCHING TIME IN hours
READ(10,*) VB				! BULK ETCH RATE IN micro m/hours
READ(10,*) THETAS			! INCIDENT ANGLE IN RESPECT TO THE DETECTOR SURFACE IN DEEGRES
   
   
  
X=0.
VMAX=0.1
VMIN=1

DO
VFJA=VT(X)
IF(VFJA>VMAX) VMAX=VFJA
IF(VFJA<1.)VMIN=VFJA	    
X=X+1.
IF(X>100)EXIT
END DO
								    
 
	
!TIME_ETCHING  ETCHING TIME IN (hours)
!VT IS TRACK TO BULK ETCH RATE RATIO 
!VB BULK ETCH RATE IN micrometer/h
!THETA IS ANGLE MEASURED IN RESPECT TO THE DETECTOR SURFACE. ANGLE IN DEGREES
	              
REMOVED=VB*TIME_ETCHING		!REMOVED THICKNESS OF THE DETECTOR DURING THE ETCHING 
		
THETA=THETAS*PI/180.D+0		! TRANSFORM ANGLE IN RADIANS


CALL DETPROTON(Eproton,REMOVED,TIME_ETCHING,THETA,DV,DM,INDICATOR,DEPTH,IAX,blackpart)
!CALL DETPROTON(EPROTON,REMOVED,TIME_ETCHING,THETA,DV,DM,INDICATOR,DEPTH,  BLACKPART )
 									           

PRINT *,'MAJOR AND MINOR AXES ARE',DV,' um', DM,' um'
PAUSE
IF(	BLACKPART<1.E-4)THEN
PRINT *, 'PART OF BLACK SURFACE IS LESS THAT 1.E-4'
ELSE
PRINT *,'PART OF BLACK SURFACE', BLACKPART
END IF 
WRITE(20,109)
109 FORMAT(' ', 'ENERGY   ANGLE   REMOVED   MAJOR    MINOR       DEPTH        BLACKPART')
WRITE(20,110)  EPROTON,THETA*180./PI,REMOVED, DV,DM,DEPTH,BLACKPART

110 FORMAT(' ', 3(F6.3,2X),2(F9.5,2X),2(E12.6,2X)) 

IF(INDICATOR==-1)THEN	       	  

PRINT *, ' THERE IS NO TRACK DEVELOPMENT'
END IF


END PROGRAM TRAG52P
				    