## Description of university projects

- [First year](#First-year)
  - [Introduction to Functional Programming](#Introduction-to-Functional-Programming)
    - [Arithmetics of Numbers](#Arithmetics-of-Numbers)
    - [Interval Set](#Interval-Set)
    - [Leftist Trees](#Leftist-Trees)
    - [Origami](#Origami)
    - [Topological Sorting](#Topological-Sorting)
    - [Pouring Water](#Pouring-Water)
 
- [Second year](#Second-year)
  - [Databases](#Databases)
    - [Flights search engine with tickets management system](#Flights-search-engine-with-tickets-management-system)
  - [Probability Theory and Statistics](#Probability-Theory-and-Statistics)
    - [Bucket Sampling](#Bucket-Sampling)
    - [Discrete Distribution's Properties](#Discrete-Distribution's-Properties)
    - [Monte Carlo Estimation](#Monte-Carlo-Estimation)
    - [Chi Square Independence Test](#Chi-Square-Independence-Test)
    
## First year
### Introduction to Functional Programming
#### Arithmetics of Numbers
The project relied on implementing an interface for computations on <b>approximate values</b> (intervals), which are present in various measurements/experiments. I also had to deal with possible <b>float overflow</b>.

Technologies used: <b>Ocaml</b>

#### Interval Set
The project relied on implementing an interface for Interval Set, which is a <b>modification of AVL tree</b>, but used for storing intervals, rather than single values. It allows one to efficiently tell if a given number is present in the set. My implementation was inspired by Xavier Leroy's, Nicolas Cannasse's, Markus Mottl's Polymorphic Set implementation.

Technologies used: <b>Ocaml</b>

#### Leftist Trees
The project replied on implementing an interface for Leftist Tree, which is a <b>priority queue</b> implemented with a variant of <b>binary heap</b>. Their main advantage is <b>quick merging</b>, which has worst case O(log n) complexity, whereas in ordinary binary heaps it takes O(n) time.

Technologies used: <b>Ocaml</b>

#### Origami
The project relied on implementing an interface for creating origami and determining how many times a pin would cross the paper if it was stuck in the origami at an arbitrary point.

Technologies used: <b>Ocaml</b>

#### Topological Sorting
The project relied on implementing an interface for sorting Directed Acyclic Graphs topologically. Input was given as an adjacency list, which I have transformed into <b>hashmap</b> for fast keys lookups. I used a <b>depth-first search</b> approach. If the graph given had cycles, an exception was raised, since no linear order of its vertices existed. 

Technologies used: <b>Ocaml</b>

#### Pouring Water
The project relied on determining if you can reach a given state of amount of water in glasses doing only a few types of operations. If so, the least number of moves that lead to a given state had to be returned. I solved it using <b>breadth-first search</b> implemented with <b>FIFO queue</b>.

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
<br/>

### Probability Theory and Statistics
#### Bucket Sampling
The project relied on implementing <b>Bucket Sampling algorithm</b> which enables sampling from a discrete distribution without rejection (much faster than naive sampling with rejection when probabilities are small, which was the case in the project). I <b>vectorized</b> the code so that is takes advantage of <b>SIMD operations</b> (data level parallelism).

Technologies used: <b>Python</b>(Numpy, Matplotlib) 
#### Discrete Distribution's Properties
#### Monte Carlo Estimation
#### Chi Square Independence Test
