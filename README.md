# TopologyMusic

###(一) 
  app 開始後，上方有 buttons, start, end<br/>
###(二)
  1. 3 * 5 隨機產生 internal node, 個數須在 9~12 間<br/>
  2. 每個 node 皆要有 parent node, child node<br/>
  3. 至少有一個 node 有三個 child node (start node/internal node)<br/>
  4. 至少有三個要有 2 個以上 child node (internal node)<br/>
  5. parent node 只能是左側，child node 可以上下側<br/>
  6. parent node <===> child node 要有連線<br/>
  7. 每個 node 之間隨機 1~7 數字<br/>
  
###(三)
  1. internal node 碰觸後可發出對應聲音<br/>
  2. play button 按下後，發出紅色路徑上對應的 button 聲音<br/>
  <br/><br/>
![](https://github.com/SunXiaoShan/TopologyMusic/blob/master/gif/output.gif)


TODO list
1. uint test
2. audio button action
3. audio delegate
