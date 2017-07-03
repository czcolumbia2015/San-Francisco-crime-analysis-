kmeans
import os
import csv

data = []
with open("train2.csv", 'r') as f:
    data = [row for row in csv.reader(f.read().splitlines())]

axis = []
lngs = []
lats = []
for i in range(1,76176):
    temp = float(data[i][8])
    axis.append([float("{0:.6f}".format(temp))])
    lats.append(float("{0:.6f}".format(temp)))
    temp = float(data[i][7])
    lngs.append(float("{0:.6f}".format(temp)))
    axis[i-1].append(float("{0:.6f}".format(temp)))



from numpy import array
from scipy.cluster.vq import vq, kmeans, whiten, kmeans2
whitened = whiten(axis)
result = kmeans2(whitened,10)

#plot graph
import pygmaps
col = ["#0000ff","#ff4040","#deb887","#98f5ff","#ff69b4","#68228b","#bebebe",
       "#050505","#a52a2a","#f8f8ff"]
mymap = pygmaps.maps(37.778, -122.412, 16)
#mymap.setgrids(37.6, 38, 0.001, -122.6, -122.2, 0.01)
for i in range(0,10000):
    mymap.addpoint(lats[i], lngs[i], col[result[1][i]]) 
mymap.draw('mymap.html') 
url = 'mymap.html'
