(* 
    @type : myTree
    Define a simple tree using a match for single value and integers only.
    V -> empty tree
    F (i) -> Tree containing one element only
    N (ln * r * rn) -> Tree with a left node, a root and a right node
*)
type myTree = V | F of int | N of (myTree * int * myTree)

(*
    @newEmptyTree
    Simple function to initiate an empty tree using myTree type.
    @return empty tree V
*)
let newEmptyTree ()= V;;

(*
    @add
    Simple function to add an element into a myTree tree.
    @param i int element to add
    @param tree myTree tree in whom we which to add the element
    @return new tree with i added into old tree
*)
let rec add i tree =
    match tree with
    | V -> F (i)
    | F (a) -> if a < i then N (V, a, F(i)) else N (F(i), a, V)
    | N(fg, r, fd) -> if i < r then N (add i fg, r, fd) else N(fg, r, add i fd);;


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
    @param f_print 'a -> unit function to print element
    @effect Draw correctly the tree.
*)
let rec treeDrawing t x y h w g_print =
  let hw = w / 2 and hh = h / 2 in
  match t with
  | F(l) -> moveto (x + hw) y; set_color green; g_print l; set_color black;
  | N(fg,r,fd) -> begin
                    moveto (x + hw) (y + 12); set_color cyan; lineto (x + hw / 2) (y + h - 5); moveto (x + hw) (y + 12); lineto (x+ hw + hw / 2) (y + h - 5);
                    set_color green; moveto (x + hw) y; g_print r; set_color black;
                    treeDrawing fg x (y+h) hh hw g_print;
                    treeDrawing fd (x+hw) (y+h) hh hw g_print;
                  end
  | _ -> ();;

let magicDrawing t g_print =
resetGraph();
treeDrawing t 0 0 200 1800 g_print;;

let soi i = string_of_int i;;

let drawInt i = draw_string (soi i);;

resetGraph;;

openGraph "1000" "1000";;

let testTree = newEmptyTree ();;
let testTree = add 0 testTree;;
let testTree = add 4 testTree;;
let testTree = add 2 testTree;;
let testTree = add 1 testTree;;
let testTree = add 3 testTree;;
let testTree = add 6 testTree;;
let testTree = add 9 testTree;;
let testTree = add 7 testTree;;
let testTree = add 10 testTree;;
let testTree = add (- 4) testTree;;
let testTree = add (- 2) testTree;;
let testTree = add (- 1) testTree;;
let testTree = add (- 3) testTree;;
let testTree = add (- 6) testTree;;
let testTree = add (- 9) testTree;;
let testTree = add (- 7) testTree;;
let testTree = add (- 10) testTree;;

magicDrawing testTree drawInt;;
