let stringToList s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []
(*
  @type dicTree
  Define a simple structure for dictionnary tree
  E -> empty dic
  L i -> leaf for the dic mean you found a word
  N (r * dic list) -> node of the dic
*)
type dicTree = E | L of char | N of char * dicTree list

(*
  @initDicTree
  Initialise a dictionnary tree.
  @return empty dicTree
*)
let initDicTree () = N (' ', []);;

let rec initDicFromList l =
	let rec ex l c =
		match (l,c) with
		| (_, true) -> N(' ', ex l false :: [])
		| ([], false) -> E
		| (t::[], false) -> L t
		| (t::q, false) -> N(t, ex q false :: [])
	in ex l true;;

let rec createDicNodeFromList l =
    match l with
    | [] -> E
    | t::[] -> L t
    | t::q -> N(t, createDicNodeFromList q :: [])

let rec addCharInNode e childs =
	match childs with
	| [] -> L e :: []
	| t::q -> match t with
		| L c -> if e == c then childs else addCharInNode e q
		| _ -> addCharInNode e q;;

(*
	@addInDic_rec
	Word to dic
	@param word char list word to add
	@param tree dicTree dictionnary for the word
	@return new dicTree with word added
*)
let rec addInDic_rec word dic =
	match (word, dic) with
  | (_, N(' ', tl)) -> N(' ', addWordInNode word tl)
	| ([], _) -> dic
	| (t::[], E) -> L t
	| (t::[], L c) -> N(c, (L t)::[])
	| (t::[], N(c, tl)) -> N(c, addCharInNode t tl)
	| (t::q, E) -> createDicNodeFromList word
	| (t::q, L c) -> N(c, (createDicNodeFromList word)::[])
	| (t::q, N(c, tl)) -> N(c, addWordInNode word tl)
and addWordInNode word dicList =
	match (word, dicList) with
	| (t::q, []) -> let sd = L t in let el = addInDic_rec q sd in el :: []
	| (t::q, n :: dq) -> begin
    match n with
		| N(c, ch) -> if t == c then addInDic_rec q n :: dq else n :: addWordInNode word dq
    | _ -> addWordInNode word dq
  end
	| (_, _) -> dicList;;

let addInDic word dic =
	let cList = stringToList word in addInDic_rec cList dic;;

let rec isValidWord_rec word dic =
  match (word, dic) with
  | (t::[], L c) -> t == c
  | (t::q, N(c, tl)) -> if c == ' '
    then validateInNode word tl
    else t == c && validateInNode q tl
  | (_, _) -> false
and validateInNode word dicList =
  match (word, dicList) with
  | (t::_, n :: dq) -> begin
    match n with
    | N(c, ch) -> if t == c then isValidWord_rec word n else validateInNode word dq
    | L e -> if t == e then isValidWord_rec word n else validateInNode word dq
    | _ -> validateInNode word dq
  end
  | (_, _) -> false;;

let isValidWord word dic =
  let cList = stringToList word in isValidWord_rec cList dic;;

(* TESTS ------------------------------------ *)
(* let test = initDicTree() *)

let test = initDicFromList (stringToList "banane");;
let test = addInDic "banone" test;;
let test = addInDic "canone" test;;
let test = addInDic "calon" test;;
let test = addInDic "ccc" test;;

let re = isValidWord "banane" test;;
let re = isValidWord "ccc" test;;
let re = isValidWord "nope" test;;
let re = isValidWord "b *)an" test;;