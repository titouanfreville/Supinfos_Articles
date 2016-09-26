(** 
  @name print_list
  @ Fonction affichant les éléments d'une liste 1 à 1 a -> b -> x -> []
  @param l string list Liste de chaînes de charactère à afficher
  @print List element in the format E -> E -> E -> ... -> []
*)
let rec print_list l =
  match l with
  |[] -> print_string "[]"
  |t::q -> print_string t; print_string " -> "; print_list q;;

let ltest = ["Test"; "Impression"; "Liste"; "NonVide"];;

print_list ltest;;
(**
  @name est_dans
  @ Fonction permettant de savoir si un élement E est dans une liste L
  @param e 'a Paramètre de type quelconque 
  @param l 'a list List d'élément du même type que e
  @return true si e in list, false else
*)
let rec est_dans e l = 
  match l with
  |[] -> false
  |t::q -> t = e || est_dans e q;;
(**
  @name doublons_sk
  @ Fonction retirant les doublons d'une liste
  @param l 'a list list d'élément.
  @return liste l sans doublons
*)
let rec doublons_sk l =
  match l with
  |[] -> []
  |t::q -> if est_dans t q then doublons_sk q else t :: doublons_sk q;;
(**
  @name nb_de
  @ Fonction permettant de calculer le nombre d'occurence d'un élément dans une liste
  @param e 'a élément de type quelconque
  @param l 'a list Liste d'élément du même type
  @return nb d'occurence de e dans a
*)
let rec nb_de e l =
  match l with
  |[] -> 0
  |t::q -> if t = e then 1 + nb_de e q else nb_de e q;;

let l1=["Test"; "Sans"; "Doublons"; "Test"; "Sans"; "Doublons"];;
let l2 = [1;2;3;4;2;3;4;5;5;6;7;8;8;9;1;3;4];;

est_dans "Test" l1;; 
est_dans "NotInside" l1;; 
print_int (nb_de 5 l2);; 
print_int (nb_de 20 l2);;
print_list (doublons_sk l1);; 
doublons_sk l2;;
