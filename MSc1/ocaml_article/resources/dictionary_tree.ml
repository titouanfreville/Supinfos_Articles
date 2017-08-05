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
	| ([], _) -> dic
	| (t::[], E) -> L t
	| (t::[], L c) -> N(c, (L t)::[])
	| (t::[], N(c, tl)) -> N(c, addCharInNode t tl)
	| (t::q, E) -> initDicFromList word
	| (t::q, L c) -> N(c, (initDicFromList word)::[])
	| (t::q, N(c, tl)) -> N(c, addWordInNode word tl)
and addWordInNode word dicList =
	match (word, dicList) with
	| (t::q, []) -> let sd = L t in let el = addInDic_rec q sd in el :: []
	| (t::q, n :: dq) -> match n with
		| L _ -> addWordInNode word dq
		| N(c, ch) -> if t == c then addInDic_rec q n :: dq else n :: addWordInNode word dq
	| _ -> dicList;;

let addInDic word dic = 
	let cList = stringToList word in addInDic_rec cList dic;;


(* Loading graphics library to used in REPL *)
#load "graphics.cma";;
(* Opening graphics module to avoid having to call Graphics.method*)
open Graphics;;

(*
    @openGraph
    Create a new graphic window using provided size.
    @param w string width of the window in pixels
    @param h string heigth of the window in pixels
    @ensures a new graphic window is open
*)
let openGraph w h = let st = " " ^ w ^ "x" ^ h in open_graph st;;

let resetGraph = clear_graph;;

(*
    @treeDrawing
    Draw a tree in order
    @param t myTree tree to draw
    @param x int initial width position in px
    @param y int initial height position in px
    @param h int height of step in px
    @param w int width of step in px
    @param printer 'a -> unit function to print element
    @param textColor color text color
    @param lineColor color line color
    @effect Draw correctly the tree.
*)
let rec treeDrawing t x y h w printer textColor lineColor=
  let drawingZoneWidth = w / 2 and drawingZoneHeight = h / 2 in
  match t with
  | F(l) -> moveto (x + drawingZoneWidth) y; set_color textColor; printer l; set_color black;
  | N(fg,r,fd) -> begin
                    moveto (x + drawingZoneWidth) (y + 12);
                    set_color lineColor; lineto (x + drawingZoneWidth / 2) (y + h - 5);
                    moveto (x + drawingZoneWidth) (y + 12); lineto (x+ drawingZoneWidth + drawingZoneWidth / 2) (y + h - 5);
                    set_color textColor; moveto (x + drawingZoneWidth) y; printer r; set_color black;
                    treeDrawing fg x (y+h) drawingZoneHeight drawingZoneWidth printer textColor lineColor;
                    treeDrawing fd (x+drawingZoneWidth) (y+h) drawingZoneHeight drawingZoneWidth printer textColor lineColor;
                  end
  | _ -> moveto (x + drawingZoneWidth) y; set_color textColor; draw_string "X"; set_color black;;

let magicDrawing t printer =
resetGraph();
treeDrawing t 0 0 450 1800 printer red blue;;

let soi i = string_of_int i;;

let drawInt i = draw_string (soi i);;

let drawString s = draw_string s;;

(* openGraph "1900" "1000";; *)
open_graph "";;

resetGraph;;

(* TESTS ------------------------------------ *)
(* let test = initDicTree() *)

let test = initDicFromList (stringToList "banane")
(* let test = addInDic " banone" test *)
magicDrawing test drawString
