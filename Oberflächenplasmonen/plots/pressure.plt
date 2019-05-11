set terminal tikz color

file1 = "../data/pressure.csv"

set xlabel 'Angle $\alpha$ [°]'
set ylabel 'Preasure $p$ [bar]'

set output "pressure.tikz"
f1(x) = a1*x + b1
f2(x) = a2*x + b2
fit f1(x) file1 using ($1*5.88/10000):2 via a1,b1
fit f2(x) file1 using ($3*5.88/10000):4 via a2,b2
plot file1 using ($1*5.88/10000):2 t 'Ambient light on', f1(x) t 'Fit f1(x)', file1 using ($3*5.88/10000):4 t 'Ambient light off', f2(x) t 'Fit f2(x)'
