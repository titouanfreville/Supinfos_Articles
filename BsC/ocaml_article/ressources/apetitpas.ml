(**
  @name: Puissance
  @ Fonction permettant de calculer la valeur a^b sur des réels
  @parameter: a float Nombre à mettre en puissance.
  @parameter: b int Puissance entière..
  @return: a^b 
*)
let rec pow a b = 
  match b with
  |0 -> 1.
  |_ -> a *. pow a (b-1);;

(**
  @name: Puissance
  @ Fonction permettant de calculer la valeur a^b sur des réels
  @parameter: a float Nombre à mettre en puissance.
  @parameter: b int Puissance entière..
  @return: a^b 
*)
let rec factorielle a =
  match a with 
  |0 -> 1
  |_ -> a * factorielle (a-1);;

pow 1.5 2;;
pow 2. 4;;
factorielle 3;;
