set terminal tikz color

file1 = "../data/Ag40nm_650_1.txt"
file2 = "../data/Ag45nm_650_1.txt"
file3 = "../data/Ag45nm_650_2.txt"
file4 = "../data/Ag45nm_850_1.txt"
file5 = "../data/Ag55nm_650_1.txt"
file6 = "../data/Ag55nm_650_2.txt"

set xlabel 'Angle $\alpha$ [°]'
set ylabel 'Voltage [V]'

set output "Ag_650nm.tikz"
plot file1 using ($1*5.88/10000):2 w l t 'Ag 40 nm', file2 using ($1*5.88/10000):2 w l lt rgb 'dark-red' notitle, file3 using ($1*5.88/10000):2 w l lt rgb 'dark-red' t 'Ag 45 nm', file5 using ($1*5.88/10000):2 w l lt rgb 'royalblue' notitle, file6 using ($1*5.88/10000):2 w l lt rgb 'royalblue' t 'Ag 55 nm'
set output "Ag45nm_850nm.tikz"
plot file4 using ($1*5.88/10000):2 w l t '850 nm', file2 using ($1*5.88/10000):2 w l lt rgb 'dark-red' notitle, file3 using ($1*5.88/10000):2 w l lt rgb 'dark-red' t '650 nm'
