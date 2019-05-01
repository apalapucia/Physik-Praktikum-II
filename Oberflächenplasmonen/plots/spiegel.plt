set terminal tikz color scale .6,.6

file1 = "../data/Spiegel1_650nm.txt"
file2 = "../data/Spiegel1_850nm.txt"
file3 = "../data/Spiegel2_650nm.txt"
file4 = "../data/Spiegel2_850nm.txt"

file5 = "../data/Spiegel3_650nm.txt"
file6 = "../data/Spiegel3_850nm.txt"
file7 = "../data/Spiegel4_650nm.txt"
file8 = "../data/Spiegel4_850nm.txt"

set ylabel 'Voltage [V]'
set xlabel 'Angle $\alpha$ [°]'

set output "spiegel1_650nm.tikz"
plot file1 using ($1*5.88/10000):2 w l lt rgb 'dark-red' notitle, file3 using ($1*5.88/10000):2 w l lt rgb 'dark-red' notitle 
set output "spiegel1_850nm.tikz"
plot file2 using ($1*5.88/10000):2 w l lt rgb 'royalblue' notitle, file4 using ($1*5.88/10000):2 w l lt rgb 'royalblue' notitle 

set output "spiegel2_650nm.tikz"
plot file5 using ($1*5.88/10000):2 w l lt rgb 'dark-red' notitle, file7 using ($1*5.88/10000):2 w l lt rgb 'dark-red' notitle 
plot file6 using ($1*5.88/10000):2 w l lt rgb 'royalblue' notitle, file8 using ($1*5.88/10000):2 w l lt rgb 'royalblue' notitle 
