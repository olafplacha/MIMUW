(* =========================================
  | Implenentation of Leftist.mli interface |
  | Author: Olaf Placha            | 429584 |
  | Code review: Michał Skwarek    | 418426 |
   ========================================= *)

(* A recursive definition of a Left-ist Heap, which is either a Leaf - null value - or
   a Node containing left queue, right queue, importance value and Null Path Length value *)
type 'a queue =
  | Leaf
  | Node of 'a queue * 'a queue * 'a * int;;

(* Creating an empty Left-ist Heap *)
let empty = Leaf;;

(* Retrieve Null Path Length from the top element *)
let getNPL q =
  match q with
  | Node (_, _, _, npl) -> npl
  | Leaf -> 0;;

(* Swapping subtrees so that the heap is NLP compliant *)
let swapIfNeeded l r a =
    match l, r with
    | Node _, Leaf -> Node (l, r, a, 1)
    | Leaf, Node _ -> Node (r, l, a, 1)
    | Node (_, _, _, nlp1), Node (_, _, _, nlp2) -> 
        if nlp1 > nlp2 then Node (l, r, a, nlp2 + 1)
        else Node (r, l, a, nlp1 + 1)
    | _, _ -> failwith "Something went wrong!";;

(* Merging two Left-ist Heaps *)
let rec join l1 l2 =
  match l1, l2 with
  | Leaf, _ -> l2
  | _, Leaf -> l1
  | Node (ll1, lr1, a, npl1), Node (ll2, lr2, b, npl2) ->
      if a < b then swapIfNeeded ll1 (join lr1 l2) a
      else swapIfNeeded ll2 (join lr2 l1) b;;

(* Adding a value to the heap *)
let add v q =
  join (Node (Leaf, Leaf, v, 1)) q;;

(* Checking whether heap is empty *)
let is_empty q =
  match q with
  | Leaf -> true
  | Node _ -> false;;

exception Empty;;

(* Delete minimum element from the heap *)
let delete_min q =
  match q with
  | Leaf -> raise Empty
  | Node (l, r, v, npl) -> (v, join l r);;