set terminal tikz scale 0.6,0.6
set logscale x
set xrange [0.0001:1]
file1 = "../data/./Ouzo5_Wasser10_10grad-new.txtAuto"
file2 = "../data/./Ouzo5_Wasser10_15grad-new.txtAuto"
file3 = "../data/./Ouzo5_Wasser10_20grad-new.txtAuto"
file4 = "../data/./Ouzo5_Wasser10_25grad-new.txtAuto"
file5 = "../data/./Ouzo5_Wasser10_30grad-new.txtAuto"
file6 = "../data/./Ouzo5_Wasser10_35grad-new.txtAuto"
file7 = "../data/./Ouzo5_Wasser10_40grad-new.txtAuto"
file8 = "../data/./Ouzo5_Wasser10_5grad-new.txtAuto"
k=1.3806e-023
i=1e-03
n=1.33
l=543e-09
t=293
a=(16*k*t*pi*n**2)/(3*i**3)

set output "O5W10_10grad.tikz"
winkel1 = 10
b1 = a*sin(winkel1*pi/180/2)**2
g1 = 1.809487598327661761e-01
r1 = 1e-14
f1(x) = g1*exp(-b1*x/r1)
fit f1(x) file1 via r1
plot file1 using 1:2 w l t 'Winkel 10°', f1(x) t sprintf("Fit, r=%.2e",r1)

set output "O5W10_15grad.tikz"
winkel2 = 15
b2 = a*sin(winkel2*pi/180/2)**2
g2 = 1.741913627889465077e-01
r2 = r1
f2(x) = g2*exp(-b2*x/r2)
fit f2(x) file2 via r2
plot file2 using 1:2 w l t 'Winkel 15°', f2(x) t sprintf("Fit, r=%.2e",r2)

set output "O5W10_20grad.tikz"
winkel3 = 20
b3 = a*sin(winkel3*pi/180/2)**2
g3 = 1.143873195511865282e-01
r3 = r2
f3(x) = g3*exp(-b3*x/r3)
fit f3(x) file3 via r3
plot file3 using 1:2 w l t 'Winkel 20°', f3(x) t sprintf("Fit, r=%.2e",r3)

set output "O5W10_25grad.tikz"
winkel4 = 25
b4 = a*sin(winkel4*pi/180/2)**2
g4 = 6.590123108563968046e-02
r4 = r3
f4(x) = g4*exp(-b4*x/r4)
fit f4(x) file4 via r4
plot file4 using 1:2 w l t 'Winkel 25°', f4(x) t sprintf("Fit, r=%.2e",r4)

set output "O5W10_30grad.tikz"
winkel5 = 30
b5 = a*sin(winkel5*pi/180/2)**2
g5 = 4.046070515519557820e-02
r5 = r4
f5(x) = g5*exp(-b5*x/r5)
fit f5(x) file5 via r5
plot file5 using 1:2 w l t 'Winkel 30°', f5(x) t sprintf("Fit, r=%.2e",r5)

set output "O5W10_35grad.tikz"
winkel6 = 35
b6 = a*sin(winkel6*pi/180/2)**2
g6 = 2.606970828273805565e-02
r6 = r5
f6(x) = g6*exp(-b6*x/r6)
fit f6(x) file6 via r6
plot file6 using 1:2 w l t 'Winkel 35°', f6(x) t sprintf("Fit, r=%.2e",r6)

set output "O5W10_40grad.tikz"
winkel7 = 40
b7 = a*sin(winkel7*pi/180/2)**2
g7 = 1.892782776396273112e-02
r7 = r6
f7(x) = g7*exp(-b7*x/r7)
fit f7(x) file7 via r7
plot file7 using 1:2 w l t 'Winkel 40°', f7(x) t sprintf("Fit, r=%.2e",r7)

set output "O5W10_5grad.tikz"
winkel8 = 5
b8 = a*sin(winkel8*pi/180/2)**2
g8 = 3.052194700620393109e-01
r8 = r7
f8(x) = g8*exp(-b8*x/r8)
fit f8(x) file8 via r8
plot file8 using 1:2 w l t 'Winkel 5°', f8(x) t sprintf("Fit, r=%.2e",r8)

save var "O5W10.dat"

