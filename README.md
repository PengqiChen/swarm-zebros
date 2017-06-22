Swarm Dispersion/Coverage Algorithm:

1. Uniform Dispersion/Coverage
2. Wall avoidance
3. Turning angle limitation: pi/3 per iteration

Input: relative distance/orientation.
Output: speed and turning angle.

To get input of the Algorithm
1. Calculate relative distances from the neighbor zebro to the current zebro
2. Get the information(relative distance/orientation) of zebros, whose relative
   distance is in detection range as the INPUT of the algorithm.
PS. If there is no zebros whose relative distance is in the detection range,
   the iteration will be skipped.

Details of Algorithm:

3. In the Algorithm, sort the zebros by relative distances in ascending order.
   If one zebro is: 

&emsp;3.1 one of the numOfNeighbors(maximum number of neighbors for calculation) closest neighbors

&emsp;3.2 its relative distance to the current zebro is less than distDisp(distance of dispersion)  
&emsp;&emsp;This zebro will be included in nZebros(neighbor zebro)for calculation  
&emsp;&emsp;PS. If there is no zebro whose relative distance is less than distDisp,  
&emsp;&emsp;the calculation will be skipped.

4. Calculate the speed and turning angle of the current zebro. The result 
   will be the out put of the Algorithm.

To do visualization, after getting the output of the Algorithm

5. Calculate the coordinates of the current zebro according to the speed and
   turning angle, which is necessary for visualization on matlab. 

How to execute the code:

Open zebros.m in Matlab and press 'F5'.

State:

In Process
