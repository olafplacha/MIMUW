(* =========================================
  | Implementacja interfejsu Arytmetyka.mli |
  | Autor rozwiazania: Olaf Placha | 429584 |
  | Code review: Tomasz Ziebowicz  | 429707 |
   ========================================= *)

(* ----- Definicje typów ----- *)

type wartosc = 
  | Spojny of (float * float) (* Czyli zbiór postaci <a,b> *)
  | Niespojny of (float * float);; (* Czyli zbiór postaci (-inf,a> U <b,inf) *)
  (* Zbior pusty definiujemy jako (inf,-inf) *) 

(* ----- Konstruktory ----- *)

let wartosc_dokladnosc x p =
  let abs n = if n > 0. then n else (-.n) in
  let pom = abs (x *. p /. 100.) in
  Spojny (x -. pom, x +. pom);;

let wartosc_od_do x y =
  Spojny (x, y);;

let wartosc_dokladna x =
  Spojny (x, x);;

(* ----- Selektory ----- *)

let in_wartosc x y =
  match x with
  | Spojny (a, b) -> (a <= y && y <= b)
  | Niespojny (a, b) -> (y <= a || b <= y);;

let min_wartosc x =
  if x = Spojny (infinity, neg_infinity) then nan else
  match x with
  | Spojny (a, _) -> a
  | Niespojny (_, _) -> neg_infinity;;

let max_wartosc x =
  if x = Spojny (infinity, neg_infinity) then nan else
  match x with
  | Spojny (_, b) -> b
  | Niespojny (_, _) -> infinity;;

let sr_wartosc x =
  match x with
  | Spojny (a, b) -> if a = neg_infinity && b = infinity then nan
                     else (((min_wartosc x) +. (max_wartosc x)) /. 2.)
  | Niespojny (_, _) -> nan;;

(* ----- Funkcje pomocnicze ----- *)

let rec scal_przedzialy x y =
  match x, y with
  | Spojny (a, b), Spojny (c, d) -> if (a = 0. && d = 0. && b <> infinity) || (b = 0. && c = 0. && a <> neg_infinity) then Spojny ((min a c), (max b d))
                                    else if (a <> neg_infinity && b <> infinity) || (c <> neg_infinity && d <> infinity) then Spojny ((min a c), (max b d))
                                    else if a = neg_infinity && b < c then Niespojny (b, c)
                                    else if b = infinity && a > c then Niespojny (d, a)
                                    else Spojny (neg_infinity, infinity)
  | Niespojny (a, b), Niespojny (c, d) -> if (max a c) >= (min b d) then Spojny (neg_infinity, infinity)
                                          else Niespojny ((max a c), (min b d))
  | Niespojny (a, b), Spojny (c, d) -> scal_przedzialy y x
  | Spojny (a, b), Niespojny (c, d) -> if a = c then Niespojny (b, d) else Niespojny (c, a);;

(* ----- Modyfikatory ----- *)

let plus x y =
  if x = Spojny (infinity, neg_infinity) || y = Spojny (infinity, neg_infinity) then Spojny (infinity, neg_infinity) else
  match x, y with
  | Spojny (a, b), Spojny (c, d) -> Spojny (a +. c, b +. d)
  | Niespojny (a, b), Spojny (c, d) -> Niespojny (a +. d, b +. c)
  | Spojny (a, b), Niespojny (c, d) -> Niespojny (c +. b, d +. a)
  | Niespojny (_, _), Niespojny (_, _) -> Spojny (neg_infinity, infinity);;

let rec minus x y =
  if x = Spojny (infinity, neg_infinity) || y = Spojny (infinity, neg_infinity) then Spojny (infinity, neg_infinity) else
  match x, y with
  | Spojny (a, b), Spojny (c, d) -> Spojny (a -. d, b -. c)
  | Spojny (_, _), Niespojny (a, b) -> scal_przedzialy (minus x (Spojny (neg_infinity, a))) (minus x (Spojny (b, infinity)))
  | Niespojny (_, _), Niespojny (_, _) -> Spojny (neg_infinity, infinity)
  | Niespojny (a, b), Spojny (c, d) -> if (a -. c) >= (b -. d) then Spojny (neg_infinity, infinity)
                                       else Niespojny (a -. c, b -. d);;

let rec razy x y =
  if x = Spojny (infinity, neg_infinity) || y = Spojny (infinity, neg_infinity) then Spojny (infinity, neg_infinity) else
  if x = Spojny (0., 0.) || y = Spojny (0., 0.) then Spojny (0., 0.) else
  match x, y with
  | Spojny (a, b), Spojny (c, d) -> if a >= 0. && c >= 0. then Spojny (a *. c, b *. d)
                                    else if b <= 0. && d <= 0. then Spojny (b *. d, a *. c)
                                    else if b <= 0. && c >= 0. then Spojny (a *. d, c *. b)
                                    else if d <= 0. && a >= 0. then Spojny (c *. b, a *. d)
                                    else if a <= 0. && b >= 0. && c >= 0. then Spojny (a *. d, b *. d)
                                    else if c <= 0. && d >= 0. && a >= 0. then Spojny (c *. b, b *. d)
                                    else if b <= 0. && c <= 0. && d >= 0. then Spojny (a *. d, a *. c)
                                    else if d <= 0. && a <= 0. && b >= 0. then Spojny (c *. b, a *. c)
                                    else Spojny ((min (a *. d) (c *. b)), (max (a *. c) (b *. d)))
  (* Mnozenie przedzialu niespojnego zamieniamy na dwa mnozenia przedzialu spojnego i scalamy *)
  | Niespojny (a, b), Spojny (c, d) -> (scal_przedzialy (razy (Spojny (neg_infinity, a)) y) (razy (Spojny (b, infinity)) y))
  | Spojny (a, b), Niespojny (c, d) -> (scal_przedzialy (razy (Spojny (neg_infinity, c)) x) (razy (Spojny (d, infinity)) x))
  | Niespojny (a, b), Niespojny (c, d) -> if a *. b >= 0. || c *. d >= 0. then Spojny (neg_infinity, infinity)
                                          else Niespojny (max (c *. b) (d *. a), min (a *. c) (b *. d));;

let rec podzielic x y =
  if x = Spojny (infinity, neg_infinity) || y = Spojny (infinity, neg_infinity) then Spojny (infinity, neg_infinity) else
  match x, y with
  | _, Spojny (0., 0.) -> Spojny (infinity, neg_infinity)
  | Spojny (0., 0.), _ -> Spojny (0., 0.)
  | _, Spojny (a, b) -> if a > 0. || b < 0. then (razy x (Spojny (1. /. b, 1. /. a)))
                        else if b = 0. then (razy x (Spojny (neg_infinity, 1. /. a)))
                        else if a = 0. then (razy x (Spojny (1. /. b, infinity)))
                        (* Jezeli 0 jest pomiedzy kresem gornym a dolnym przedzialu spojnego - ale rozne od tych kresow - to zamieniamy przedzial 
                           na <a,0> U <0,b> i wykonujemy dwa dzielenia. Wyniki scalamy *)
                        else (scal_przedzialy (podzielic x (Spojny (a, 0.))) (podzielic x (Spojny (0., b))))
  (* Dzielenie przez przedzial niespojny <-inf,a> U <b,inf> zamieniamy na dwa dzielenia przez przedzialy spojne <-inf,a> oraz <b,inf> i scalamy wynik *)
  | _, Niespojny (a, b) -> (scal_przedzialy (podzielic x (Spojny (neg_infinity, a))) (podzielic x (Spojny (b, infinity))));;