(* ======================================
  | Implenentation of iSet.mli interface |
  | Author: Olaf Placha         | 429584 |
  | Code review: Jakub Jagiella | ------ |
   ====================================== *)

(* Defining interval set type: 
another set * interval * another set * height * no elements in the node and subtrees *)
type t =
  | Empty
  | Node of t * (int * int) * t * int * int;;

let empty = Empty;;

(* Returns height of a node. 
   Time and space complexity: O(1) *)
let height = function
  | Node (_, _, _, h, _) -> h
  | Empty -> 0;;

(* Returns no elements in the subtrees of the node + 1, unless the node is empty.
   Time and space complexity: O(1) *)
let numElements = function
  | Node (_, _, _, _, n) -> n
  | Empty -> 0;;

(* Adds two numbers considering possible overflow.
   Time and space complexity: O(1) *)
let safeAdd a b =
  if a > 0 && b > 0 && a >= max_int - b then max_int
  else if a < 0 && b < 0 && a <= min_int - b then min_int
  else a + b;;
  

(* Creates a new tree given left and right subtrees and an interval 
   Time and space complexity: O(1) *)
let make l ((a, b) as interval) r = 
  let h = safeAdd (max (height l) (height r)) 1 in
  let pom = if a = min_int then max_int else (-a) in
  let n = safeAdd (safeAdd (numElements l) (numElements r)) (safeAdd (safeAdd b (pom)) 1)  in
  Node (l, interval, r, h, n);;

(* Balances the tree so that the property of a balanced tree is preserved 
   Time and space complexity: O(1) as it relies on a few "pointers" changes *)
let bal l k r =
  let hl = height l in
  let hr = height r in
  if hl > hr + 2 then
    match l with
    | Node (ll, lk, lr, _, _) ->
        if height ll >= height lr then make ll lk (make lr k r)
        else
          (match lr with
          | Node (lrl, lrk, lrr, _, _) ->
              make (make ll lk lrl) lrk (make lrr k r)
          | Empty -> assert false)
    | Empty -> assert false
  else if hr > hl + 2 then
    match r with
    | Node (rl, rk, rr, _, _) ->
        if height rr >= height rl then make (make l k rl) rk rr
        else
          (match rl with
          | Node (rll, rlk, rlr, _, _) ->
              make (make l k rll) rlk (make rlr rk rr)
          | Empty -> assert false)
    | Empty -> assert false
  else make l k r;;

(* Returns minimum interval - starting with the lowest number 
   Space complexity: O(1) as we use tail recursion
   Time complexity: O(log n) as we have to get down to the lowest node *)
let rec min_elt = function
| Node (Empty, k, _, _, _) -> k
| Node (l, _, _, _, _) -> min_elt l
| Empty -> raise Not_found;;

(* Removes minumum interval and preserves balanced tree property 
   Space complexity: O(log n) as we call the function O(log n) times without tail recursion
   Time complexity: O(log n) as we have to get down to the lowest node and balance the tree if needed *)
let rec remove_min_elt = function
| Node (Empty, _, r, _, _) -> r
| Node (l, k, r, _, _) -> bal (remove_min_elt l) k r
| Empty -> invalid_arg "iSet.remove_min_elt";;

(* Analogous to min_elt function *)
let rec max_elt = function
| Node (_, k, Empty, _, _) -> k
| Node (_, _, r, _, _) -> max_elt r
| Empty -> raise Not_found;;

(* Analogous to remove_min_elt function *)
let rec remove_max_elt = function
| Node (l, _, Empty, _, _) -> l
| Node (l, k, r, _, _) -> bal l k (remove_max_elt r)
| Empty -> invalid_arg "iSet.remove_min_elt";;

(* Merges two trees into one tree
   Space and time complexity: O(log n) as this is the complexity of finding and removing minimum interval *)
let merge t1 t2 =
  match t1, t2 with
  | Empty, _ -> t2
  | _, Empty -> t1
  | _ ->
      let k = min_elt t2 in
      bal t1 k (remove_min_elt t2);;

(* Adds interval that is not in the set 
   Space complexity: O(log n) as we call the function O(log n) times without tail recursion 
   Time complexity: O(log n) as we have to get down to the lowest node and balance the tree if needed *)
let rec add_one ((a, b) as interval) = function
| Node (l, ((c, d) as k), r, h, n) ->
    if b < c then
      let nl = add_one interval l in
      bal nl k r
    else
      let nr = add_one interval r in
      bal l k nr
| Empty -> make Empty interval Empty;;

(* Joins two trees with disjoint intervals 
   Time and space complexity: O(log n) as we call the join function recursively at each level of the trees,
   while at each level we do only matching, comparing and balancing which are done in O(1) time *)
let rec join l v r =
  match (l, r) with
    (Empty, _) -> add_one v r
  | (_, Empty) -> add_one v l
  | (Node(ll, lv, lr, lh, _), Node(rl, rv, rr, rh, _)) ->
      if lh > rh + 2 then bal ll lv (join lr v r) else
      if rh > lh + 2 then bal (join l v rl) rv rr else
      make l v r;;

(* Returns intervals strictly smaller and strictly greater than x from the set and a flag 
   denoting presence of x in the set
   Time and space complexity: O(log n) as in the worst case we have to go down to a leaf. Although we
   do joining at each level (joining's worst time complexity is O(log n)), we join subtrees whose height 
   difference is limited by a constant and thus join function will be executed in O(1) (limited number 
   of balancing) *)
let split x set =
  let rec loop x = function
    | Empty ->
        (Empty, false, Empty)
    | Node (l, ((a, b) as v), r, _, _) ->
        if (a <= x && x <= b) then 
          let smaller = if a = x then l else add_one (a, x - 1) l in
          let greater = if b = x then r else add_one (x + 1, b) r in
          (smaller, true, greater)
        else if x <= a then
          let (ll, pres, rl) = loop x l in (ll, pres, join rl v r)
        else
          let (lr, pres, rr) = loop x r in (join l v lr, pres, rr)
  in
  loop x set;;

(* Adds interval to the set 
   Time and space complexity: O(log n) as we call split and join functions *)
let add ((a, b) as interval) set =
  let la, _, ra = split a set in
  let lb, _, rb = split b set in
  match (la, rb) with
  | Empty, Empty -> make Empty interval Empty
  | Empty, _ -> 
      let (ar, br) = min_elt rb in
      if (safeAdd b 1) = ar then add_one (a, br) (remove_min_elt rb) 
      else add_one interval rb
  | _, Empty ->
      let (al, bl) = max_elt la in
      if (safeAdd bl 1) = a then add_one (al, b) (remove_max_elt la)
      else add_one interval la
  | _, _ ->
      let (ar, br) = min_elt rb in
      let (al, bl) = max_elt la in
      if (safeAdd b 1) = ar && (safeAdd bl 1) = a then join (remove_max_elt la) (al, br) (remove_min_elt rb)
      else if (safeAdd b 1) = ar then join la (a, br) (remove_min_elt rb)
      else if (safeAdd bl 1) = a then join (remove_max_elt la) (al, b) rb
      else join la interval rb;;

(* Returns all intervals from the set
   Time and space complexity: O(n) as we have to visit every node in a recursive manner *)
let elements set = 
  let rec loop acc = function
    | Empty -> acc
    | Node(l, k, r, _, _) -> loop (k :: loop acc r) l in
  loop [] set;;

(* Returns number of elements below x in the set
   Space complexity: O(1) as the loop function is tail recursive
   Time complexity: O(log n) as in the worst case we have to go down to a leaf *)
let below x set =
  let rec loop subTree aux =
    match subTree with
    | Empty -> aux
    | Node (l, (a, b), r, _, n) ->
        if x < a then loop l aux
        else if x > b then 
            if a = min_int then loop r (safeAdd aux (safeAdd (numElements l) (safeAdd (safeAdd b (max_int)) 2)))
            else loop r (safeAdd aux (safeAdd (numElements l) (safeAdd (safeAdd b (-a)) 1)))
        else 
            if a = min_int then safeAdd aux (safeAdd (safeAdd (safeAdd x (max_int)) 2) (numElements l))
            else safeAdd aux (safeAdd (safeAdd (safeAdd x (-a)) 1) (numElements l)) in
  loop set 0;;

(* Removes the interval from the set
   Time and space complexity: O(log n) as we have to split and merge *)
let remove (a, b) set =
  let (al, _, ar) = split a set in
  let (_, _, br) = split b ar in
  merge al br;;

(* Checks if x is in the set
   Space complexity: O(1) as loop is tail recursive
   Time complexity: O(log n) as in the worts case we have to go down to a leaf *)
let mem x set =
  let rec loop = function
  | Empty -> false
  | Node (l, (a, b), r, _, _) ->
      if (a <= x && x <= b) then true
      else if x < a then loop l
      else loop r in
  loop set;;

(* Applies f to all intervals in increasing order
   Space complexity: O(n) as we call loop function for every interval 
   Time complexity: O(n) * [time complexity of f] as we apply f to every interval *)
let iter f set =
  let rec loop = function
    | Empty -> ()
    | Node (l, k, r, _, _) -> loop l; f k; loop r in
  loop set;;

(* Computes f composite on all intervals in increasing order
   Space complexity: O(1) as loop is tail recursive
   Time complexity: O(n) as we have to visit every node *)
let fold f set acc =
  let rec loop acc = function
    | Empty -> acc
    | Node (l, k, r, _, _) ->
          loop (f k (loop acc l)) r in
  loop acc set;;

let is_empty set = set = Empty;