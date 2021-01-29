(* =============================================
   | Implementation of przelewanka.mli interface |
   | Author: Olaf Placha                | 429584 |
   | Code review: Piotr Ulanowski       | ------ |
   ============================================= *)

(* Computes greatest common divisor of two numbers using Eucledean algorithm *)
let rec gcd a b =
  if b = 0 then a else gcd b (a mod b);;

(* Returns true iff input meets necessary conditions, i.e.
    - GCD of all glasses' capacities divide each glass's target volume. It is 
      a necessary condition, because of the invariant - in the beginning all 
      the volumes are divisible by GCD of all glasses' capacities and any operation 
      allowed will preserve the invariant  
    - for at least one glass: target volume is equal to 0 or equal to glass's capacity *)
let checkNecessaryCondition input =
  let currentGCD = ref (fst input.(0))
  and n = Array.length input 
  and divisableFlag = ref true
  and fullOrEmptyFlag = ref false in

  (* Computing GCD *)
  for i = 1 to (n - 1) do 
    currentGCD := gcd !currentGCD (fst input.(i))
  done;

  (* Checking necessary conditions *)
  for i = 0 to (n - 1) do
    if (fst input.(i) > 0) then (
      if ((snd input.(i) mod !currentGCD) == 0) then () else (divisableFlag := false)
    );
    if (snd input.(i) == 0 || fst input.(i) == snd input.(i)) then (fullOrEmptyFlag := true);
  done;

  (* Returning flag denoting is necessary conditions are met *)
  if (!divisableFlag = false || !fullOrEmptyFlag = false) then false else true;;

let przelewanka input =
  let n = Array.length input in
  if n = 0 then 0
  else if (checkNecessaryCondition input) = false then -1
  else begin
    (* Hashmap with already visited states *)
    let visited = Hashtbl.create 64
    (* Queue used for breadth-first search *)
    and q = Queue.create () 
    and target = Array.make n 0 
    and flag = ref false in

    Queue.add (Array.make n 0) q;
    Hashtbl.add visited (Array.make n 0) 0;

    for i = 0 to (n - 1) do
      target.(i) <- snd input.(i);
    done;

    if target = (Array.make n 0) then 0 else (

      (* BFS *)
      while (Queue.is_empty q = false) do
        let currentState = Queue.take q in
        let currentDist = ((Hashtbl.find visited currentState) + 1) in

        (* Pouring water in and out of glasses *)
        for i = 0 to (n - 1) do

          let pouredOut = Array.copy currentState
          and pouredIn = Array.copy currentState in

          (* If empty then nothing to pour out *)
          if currentState.(i) = 0 then () else (
            pouredOut.(i) <- 0;
            (* If the state already visited, do nothing *)
            if (Hashtbl.mem visited pouredOut) then () else (
              if (pouredOut = target) then (flag := true);
              Hashtbl.add visited pouredOut currentDist; Queue.add pouredOut q
            )
          );

          (* If full then nothing to pour in *)
          if currentState.(i) = (fst input.(i)) then () else (
            pouredIn.(i) <- (fst input.(i));
            (* If the state already visited, do nothing *)
            if (Hashtbl.mem visited pouredIn) then () else (
              if (pouredIn = target) then (flag := true);
              Hashtbl.add visited pouredIn currentDist; Queue.add pouredIn q
            )
          );
        done;
        
        (* Pouring water from one glass to another *)
        for i = 0 to (n - 1) do
          for j = 0 to (n - 1) do
            (* If i != j and ith glass not empty *)
            if (i <> j && currentState.(i) > 0) then (
              let pouredTo = Array.copy currentState in
              if (currentState.(i) + currentState.(j) > (fst input.(j))) then (
                pouredTo.(j) <- fst input.(j);
                pouredTo.(i) <- currentState.(i) + currentState.(j) - pouredTo.(j);
              )
              else (
                pouredTo.(j) <- currentState.(j) + currentState.(i);
                pouredTo.(i) <- 0;
              );
              if not (Hashtbl.mem visited pouredTo) then (
                if (pouredTo = target) then (flag := true);
                Hashtbl.add visited pouredTo currentDist; Queue.add pouredTo q
              )
            )
          done;
        done;
      
      (* We have found our target, leave the loop by clearing the queue *)
      if (!flag) then Queue.clear q;
      done;
      if (!flag) then (Hashtbl.find visited target) else -1;
    )
  end;