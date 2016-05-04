DOUBLE PRECISION FUNCTION VT(y)
DOUBLE PRECISION Y

!Etching function V	for protons

 
A1=0.4306
A2=7.3736e-3
A3=1.0559
A4=0.1072
A5=1.4120

VT=1.+ (a1*exp(-a2*y) + a3*exp(-a4*y))*(1. -exp(-a5*y)) 



END FUNCTION  VT

 			   