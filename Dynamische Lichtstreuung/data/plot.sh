#!/bin/sh

for z in 5 10 15
do
	echo "set terminal tikz scale 0.6,0.6"
	echo "set logscale x"
	echo "set xrange [0.0001:1]"
	m=1
	for file in $(find . -name "Ouzo5_Wasser"$z"*Auto");
	do
		echo "file$m = \"../data/$file\"";
		let m+=1;
	done

	printf "k=1.3806e-023\ni=1e-03\nn=1.33\nl=543e-09\nt=293\na=(16*k*t*pi*n**2)/(3*i**3)\n\n"
	n=1
	i=10
	for file in $(find . -name "Ouzo5_Wasser"$z"*Auto");
	do
		if [ $i -gt 40 ]; then
			echo "set output \"O5W"$z"_5grad.tikz\"";
			echo "winkel$n = 5";
		else
			echo "set output \"O5W"$z"_"$i"grad.tikz\"";
			echo "winkel$n = $i";
		fi
		echo "b$n = a*sin(winkel$n*pi/180/2)**2";
		a=$(sed '3q;d' "$file" | awk '{print $2}');
		echo "g$n = $a";
		if [ $n -gt 1 ]; then
			echo "r$n = r$(($n-1))"
		else
			echo "r$n = 1e-14";
		fi
		echo "f$n(x) = g$n*exp(-b$n*x/r$n)";
		echo "fit f$n(x) file$n via r$n";
		if [ $i -gt 40 ]; then
			echo "plot file$n using 1:2 w l t 'Winkel 5°', f$n(x) t sprintf(\"Fit, r=%.2e\",r"$n")"
		else
			echo "plot file$n using 1:2 w l t 'Winkel $i°', f$n(x) t sprintf(\"Fit, r=%.2e\",r"$n")"
		fi
		printf "\n";
		let n+=1;
		let i+=5;
	done
	echo "save var \"O5W"$z".dat\""
done
