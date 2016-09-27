(**
  @name fibo
  Fonction that will calculate the Nth term of fibonnacci serie.
  @param n int Range where you want to calculate
  @return finbonnacci value @ Nth poosition
*)
let rec fibo n = 
  match n with 
  |0 -> 0
  |1 -> 1
  |_ -> fibo (n-1) + fibo (n-2);;

fibo 4;;
fibo 22;;
(**
  @name hanoi
  fonction affichant la combinaison d'étape à faire pour résoudre le problème.
  @param n int nombre de disque 
  @para d string pique de départ
  @para a string pique intermédiaire
  @para i string pique d'arrivée $
*)
let rec hanoi n d a i =
  match n with
  |0 -> ""
  |1 -> d ^ a 
  |_ -> hanoi (n-1) d i a ^ "- " ^ hanoi 1 d a i ^ " - " ^ hanoi (n-1) i a d;;

hanoi 10 "D" "A" "I";;
