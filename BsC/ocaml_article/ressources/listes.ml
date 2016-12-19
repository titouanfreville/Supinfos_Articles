(**
  @name gen_list
  @ Fonction to create a list using 2 parameters
  @param max int max value in use [0 .. max] interval will be used to take random element
  @param num int number of element to provide to the list
  @return list containing num elements in [0, max]
*)
Random.self_init;;
let rec gen_list_rec max num acc = 
  match num with
  |0 -> acc
  |_ -> gen_list_rec max (num-1) (Random.int(max)::acc);;
let gen_list max num = gen_list_rec max num [];;
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
let lfun = gen_list 100 1000;;
est_dans "Test" l1;; 
est_dans "NotInside" l1;; 
print_int (nb_de 5 l2);; 
print_int (nb_de 20 l2);;
print_list (doublons_sk l1);; 
doublons_sk l2;;

(**
  @name insert_nt
  @ Fonction permettant d'insérent un élément dans une liste triée.
  @param e 'a Élément du type de la liste
  @param l 'a list Liste d'élément triée
  @param comp 'a->'a->bool fonction de comparaison
  @return e inséré dans l triée.
*)
let rec insert_nt e l comp = 
  match l with
  |[]-> [e]
  |t::q -> if comp e t then e::l else t::insert_nt e q comp;;
(**
  @name tri_bulle_nt
  @ Fonction permettant de trier une liste
  @param l 'a list Liste d'élément
  @param comp 'a->'a->bool fonction de comparaison
  @return l trié
*)
let rec tri_bulle_nt l comp =
  match l with 
  |[]-> []
  |t::q -> insert_nt t (tri_bulle_nt q comp) comp;;
(**
  @name insert
  @ Fonction permettant d'insérent un élément dans une liste triée.
  @param e 'a Élément du type de la liste
  @param l 'a list Liste d'élément triée
  @param acc 'a list Accumulateur. '
  @param comp 'a->'a->bool fonction de comparaison
  @return e inséré dans l triée.
*)
let rec insert e l acc comp =
  match l with
  |[]-> acc@[e]
  |t::q -> if comp e t then acc@(e::l) else insert e q (acc@[t]) comp;;
(**
  @name tri_bulle
  @ Fonction permettant de trier une liste
  @param l 'a list Liste d'élément
  @param acc 'a list Accumulateur. '
  @param comp 'a->'a->bool fonction de comparaison
  @return l trié
*)
let rec tri_bulle l acc comp =
  match l with 
  |[]-> acc
  |t::q -> tri_bulle q (insert t acc [] comp) comp;;

let inf a b = a < b;;
tri_bulle_nt l1 inf;;
tri_bulle_nt l2 inf;;

tri_bulle l1 [] inf;;
tri_bulle l2 [] inf;;

(**
  @name devise
  @ Fonction permettant de diviser une liste
  @param l 'a list Liste d'élément
  @return ('a list, 'a list) liste l divisée en 2.
*)
let rec divise l a1 a2 =
  match l with
  |[] -> (a1,a2)
  |t::[] -> (t::a1,a2)
  |t1::t2::q -> divise q (t1::a1) (t2::a2)
(**
  @name fusion
  @ Fonction permettant de fusionner une liste
  @param l1 'a list Liste d'élément triée selon comp
  @param l2 'a list Liste d'élément triée selon comp
  @param comp 'a->'a->bool fonction de comparaison
  @return 'a list Liste l1 && l2 fusionnée et triée selon comp'
*)
let rec fusion l1 l2 acc comp =
  match (l1,l2) with
  |([],_) -> acc@l2
  |(_,[]) -> acc@l1
  |(t1::q1,t2::q2) -> if comp t1 t2 then fusion q1 l2 (acc@[t1]) comp else fusion l1 q2  (acc@[t2]) comp;;
(**
  @name order
  @ Fonction permettant de trier une liste
  @param l 'a list Liste d'élément
  @param comp 'a->'a->bool fonction de comparaison
  @return l trié
*)
let rec order l comp=
  match l with 
  |[] -> l
  |t::[] -> l
  |_ -> let (l1,l2) = divise l [] [] in fusion (order l1 comp) (order l2 comp) [] comp;;
order l1 inf;;
order l2 inf;;

let s_time=Sys.time();;
tri_bulle lfun [] inf;;
let tri_bulle_time = Sys.time() -. s_time;;
order lfun inf;;
let tri_fusion_time = Sys.time() -. tri_bulle_time -. s_time;;
