(* =========================================
  | Implementation of origami.mli interface |
  | Author: Olaf Placha            | 429584 |
  | Code review: Bartłomiej Sadlej | ------ |
   ========================================= *)

(** Punkt na płaszczyźnie *)
type point = float * float;;

(** Funkcja: ile razy kartkę przebije szpilka wbita w danym punkcie *)
type kartka = point -> int;;

(** Funkcje pomocnicze *)
let abs x = if x < 0. then (-.x) else x;;
let isZero x = abs x < 1e-10;;

(** Funkcja zwracająca:
-1 <=> p jest na lewo od prostej AB 
 0 <=> p leży prostej AB
 1 <=> p jest na prawo od prostej AB *)
let whichSide (x1, y1) (x2, y2) (x, y) =
    let d = (x -. x1) *. (y2 -. y1) -. (y -. y1) *. (x2 -. x1) in
    if isZero d then 0
    else if d < 0. then -1 else 1;;

(** Funkcja zwracająca obraz punktu p względem prostej AB *)
let getSymmetrical (x1, y1) (x2, y2) (x, y) =
  (** prosta AB jest pionowa lub pozioma *)
   if x1 = x2 then (2. *. x1 -. x, y)
   else if y1 = y2 then (x, 2. *. y1 -. y) else
  (** prosta AB jest ukośna, obliczamy współczynniki prostej AB
      i prostej do niej prostopadłej przechodzącej przez C *)
   let a = (y2 -. y1) /. (x2 -. x1) in
   let b = y1 -. a *. x1 in
   let aPrim = - 1. /. a in
   let bPrim = y -. aPrim *. x in
   let xPrim = (bPrim -. b) /. (a -. aPrim) in
   let yPrim = aPrim *. xPrim +. bPrim in
   (2. *. xPrim -. x, 2. *. yPrim -. y);;

let zloz ((x1, y1) as a) ((x2, y2) as b) k =
  function (x, y) ->
  let d = whichSide a b (x, y) in
  if d = 0 then k (x, y) 
  else if d < 0 then (k (x, y)) + (k (getSymmetrical a b (x, y)))
  else 0;;

let skladaj l k = List.fold_left (fun acc (a, b) -> zloz a b acc) k l;;

let prostokat (x1, y1) (x2, y2) =
  function (x, y) ->
  if x >= x1 && x <= x2 && y >= y1 && y <= y2 then 1 else 0;;

let kolko (x1, y1) r =
  let kwadrat n = n *. n in
  function (x, y) ->
  if (kwadrat (x1 -. x)) +. (kwadrat (y1 -. y)) <= kwadrat r then 1 else 0;;
