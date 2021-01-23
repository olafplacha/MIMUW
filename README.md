## Description of university projects

- [First year](#firstyear)
  - [Introduction to Functional Programming](#Introduction-to-Functional-Programming)
    - [Arithmetics of Numbers](#Arithmetics-of-Numbers)
    - [Interval Set](#Interval-Set)
    - [Leftiest Trees](#lt)
    - [Origami](#or)
    - [Topological Sorting](#ts)
    - [Pouring Water](#pw)
 
- [Second year](#secondyear)
  - [Databases](#Databases)
    - [Flights search engine with tickets management system](#Flights-search-engine-with-tickets-management-system)
  - [Probability Theory and Statistics](#rpis)
    - [Bucket Sampling](#bs)
    - [Discrete Distribution's Properties](#dd)
    
## First year
### Introduction to Functional Programming
#### Arithmetics of Numbers
The project relied on implementing interface for computations on <b>approximate values</b> (intervals), which are present in various measurements/experiments. I also had to deal with possible <b>float overflow</b>.

Technologies used: <b>Ocaml</b>

#### Interval Set
The project relied on implementing interface for Interval Set, which is a <b>modification of AVL tree</b>, but used for storing intervals, rather than single values. It allowes one to efficiently tell if a given number is present in the set. My implementation was inspired by Xavier Leroy's, Nicolas Cannasse's, Markus Mottl's Polymorphic Set implementation.

Technologies used: <b>Ocaml</b>

#### Leftiest Trees

<hr>
    
## Second year
### Databases
#### Flights search engine with tickets management system
  <img src='https://github.com/olafplacha/MIMUW/blob/main/Second_Year/Databases/Project/doc/result.png'/>

The web application lets users search for <b>flights based on their cost preferences</b>. By setting a large time-value coefficient, the user is shown a fast connection, where the total price is not of great importance. On the other hand, setting a small time-value coefficient, the user is shown the cheapest connection, but not necessarily the fastest one. Users can also <b>register</b> and <b>manage their tickets</b>.<br/>
Moreover, the application lets airlines <b>register</b>, <b>add new airplanes</b> to their fleets and <b>manage their flights</b>.

<img src='https://github.com/olafplacha/MIMUW/blob/main/Second_Year/Databases/Project/doc/airlinePanel.png'/>

Under the hood a modified version of <b>Dijkstra's algorithm</b> is used. You can see my implementation here: [link](https://github.com/olafplacha/MIMUW/blob/main/Second_Year/Databases/Project/algorithm/dijkstra.py)

Technologies used: <b>Python, PHP, SQL, PL/SQL, HTML, JavaScript</b><br/>
Database: <b>Oracle SQL*Plus</b>

In order to maintain data integrity <b>triggers</b>, <b>constraints</b> and <b>serializable transactions</b> are used.<br/>
In order to speed up finding the best connection <b>indices</b> are used.<br/>
You can see the project here: [link](https://students.mimuw.edu.pl/~op429584/project/)
