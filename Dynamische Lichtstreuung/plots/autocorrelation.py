import numpy as np
#import matplotlib.pyplot as plt
files = ["../data/Ouzo5_Wasser10_10grad-new.txt",
"../data/Ouzo5_Wasser10_15grad-new.txt",
"../data/Ouzo5_Wasser10_20grad-new.txt",
"../data/Ouzo5_Wasser10_25grad-new.txt",
"../data/Ouzo5_Wasser10_30grad-new.txt",
"../data/Ouzo5_Wasser10_35grad-new.txt",
"../data/Ouzo5_Wasser10_40grad-new.txt",
"../data/Ouzo5_Wasser10_5grad-new.txt",
"../data/Ouzo5_Wasser15_10grad-new.txt",
"../data/Ouzo5_Wasser15_15grad-new.txt",
"../data/Ouzo5_Wasser15_20grad-new.txt",
"../data/Ouzo5_Wasser15_25grad-new.txt",
"../data/Ouzo5_Wasser15_30grad-new.txt",
"../data/Ouzo5_Wasser15_35grad-new.txt",
"../data/Ouzo5_Wasser15_40grad-new.txt",
"../data/Ouzo5_Wasser15_5grad-new.txt",
"../data/Ouzo5_Wasser5_10grad-new.txt",
"../data/Ouzo5_Wasser5_15grad-new.txt",
"../data/Ouzo5_Wasser5_20grad-new.txt",
"../data/Ouzo5_Wasser5_25grad-new.txt",
"../data/Ouzo5_Wasser5_30grad-new.txt",
"../data/Ouzo5_Wasser5_35grad-new.txt",
"../data/Ouzo5_Wasser5_40grad-new.txt",
"../data/Ouzo5_Wasser5_5grad_1-new.txt"]
#for file in files:
file=files[0]
print(file)
Zeit,Kanal1 = np.loadtxt(file,delimiter="\t",skiprows=3,unpack=True)
N = len(Zeit)
print(N)
T = Zeit[1]-Zeit[0]
print(T)
Time = np.arange(0,N*T,T)
print(Time)
x = Zeit
y = Kanal1
yun = y - np.mean(y)
print(yun)
ynorm = np.sum(yun**2)
print(ynorm)
Auto = np.correlate(yun,yun,"full")/ynorm
print(Auto)
#Auto = Auto[len(Auto)/2:]
#plt.plot(Time,Auto)
#plt.xscale(log)
#plt.show()
np.savetxt(file + "autocorrelation", (Time,Auto),header='Zeit [s], Autokorrelation')
