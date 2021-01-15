(* =========================================
  | Implementation of topol.mli interface   |
  | Author: Olaf Placha            | 429584 |
  | Code review: Łukasz Wnuk       | ------ |
   ========================================= *)

exception Cykliczne;;
(** As we traverse the graph, we mark our nodes with one of three states. 
It helps us in cycle detection and prevents from processing vertices a few times *)
type state = Unvisited | Active | Visited

let topol l =

  let res = ref [] and h = ref (Hashtbl.create 64) in

  (** Creating Hashtable - adjacency table - with vertices and their initial state - Unvisited *)
  List.iter (function (x, y) -> 
    if not (Hashtbl.mem !h x) then Hashtbl.add !h x (Unvisited, []) else ();
    List.iter (function v -> 
      let s, vertices = Hashtbl.find !h x in
      Hashtbl.add !h x (s, (v :: vertices))) y) l;

  let rec traverse v =
    (** Check if vertex doesn't have any children and hasn't been visited yet *)
    if not (Hashtbl.mem !h v) then 
      begin
        (** Then we add it to the hashtable with 'Visited' state, and add to the result list *)
        Hashtbl.add !h v (Visited, []); res := v :: !res
      end
    else
      let (s, children) = Hashtbl.find !h v in
      match s with
      | Unvisited ->
        (** We mark current vertex as 'Active' and proceed to its childern *)
        Hashtbl.add !h v (Active, children);
        List.iter (function x -> traverse x) children;
        Hashtbl.add !h v (Visited, children);
        (** We add vertex to the result list *)
        res := v :: !res
      (** If we encounter a vertex which we have already seen, but not yet exited from - it must be a cycle *)
      | Active -> raise Cykliczne
      | Visited -> () in
  
  (** We start from each vertex. If its state is 'Visited' then we can skip proceeding with it *)
  List.iter (function x, _ -> traverse x) l;
  !res;;

  (** The solution utilizes hashtable - lookup takes O(1) time
      The overall time complexity is O(|V| + |E|) as we traverse every vertex and every edge
      The overall space complexity is O(|V| + |E|) as we build an adjacency table *)
      
  