set terminal tikz color

file1 = "../data/PrismaUnbeschichtet1.txt"

set xlabel 'Angle $\alpha$ [°]'
set ylabel 'Voltage [V]'
set output "prismUncoated.tikz"
plot file1 using ($1*5.88/10000):2 w l notitle
