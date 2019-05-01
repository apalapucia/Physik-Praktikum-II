set terminal tikz color

file1 = "../data/Au1_650nm.txt"
file2 = "../data/Au2_650nm.txt"
file3 = "../data/Au1_850nm.txt"
file4 = "../data/Au2_850nm.txt"

set xlabel 'Angle $\alpha$ [°]'
set ylabel 'Voltage [V]'

set output "Au.tikz"
plot file1 using ($1*5.88/10000):2 w l lt rgb 'dark-red' t 'Au 650 nm', file2 using ($1*5.88/10000):2 w l lt rgb 'dark-red' notitle, file3 using ($1*5.88/10000):2 w l lt rgb 'royalblue' t 'Au 850 nm', file4 using ($1*5.88/10000):2 w l lt rgb 'royalblue' notitle
