## Description of university projects

- [First year](#firstyear)
  - [Introduction to Functional Programming](#ifp)
    - [Arithmetics of Numbers](#aon)
    - [Interval Set](#is)
    - [Leftiest Trees](#lt)
    - [Origami](#or)
    - [Topological Sorting](#ts)
    - [Pouring Water](#pw)
 
- [Second year](#secondyear)
  - [Databases](#db)
    - [Flights search engine with tickets management system](#dbproj)
  - [Probability Theory and Statistics](#rpis)
    - [Bucket Sampling](#bs)
    - [Discrete Distribution's Properties](#dd)
    
## Second year
### Databases
#### Flights search engine with tickets management system
  <img src='https://github.com/olafplacha/MIMUW/blob/main/Second_Year/Databases/Project/doc/result.png'/>

The web application lets users search for <b>flights based on their cost preferences</b>. By setting a large time-value coefficient, the user is shown a fast connection, where total price is not of great importance. On the other hand, setting a small time-value coefficient, the user is shown the cheapest connection, but not necessarily the fastest one. Users can also <b>register</b> and <b>manage their tickets</b>.<br/>
Moreover, the application lets airlines <b>register</b>, <b>add new airplanes</b> to their fleets and <b>manage their flights</b>.

<img src='https://github.com/olafplacha/MIMUW/blob/main/Second_Year/Databases/Project/doc/airlinePanel.png'/>

Under the hood a modified version of <b>Dijkstra's algorithm</b> is used. You can see my implementation here: [link](https://github.com/olafplacha/MIMUW/blob/main/Second_Year/Databases/Project/algorithm/dijkstra.py)

Technologies used: <b>Python, SQL, PL/SQL, HTML, PHP, JavaScript</b>

In order to maintain data integrity <b>triggers</b>, <b>constraints</b> and <b>serializable transactions</b> are used.
In order to speed up finding best connection <b>indices</b> are used.
