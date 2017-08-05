(*
    @type : alphaTree
    Define a simple tree using a match for single value and any type.
    V -> empty tree
    F (i) -> Tree containing one element only
    N (ln * r * rn) -> Tree with a left node, a root and a right node
*)
type alphaTree = V | F of string | N of (alphaTree * string * alphaTree)

(*
    @newEmptyTree
    Simple function to initiate an empty tree using alphaTree type.
    @return empty tree V
*)
let newEmptyTree ()= V;;

(*
    @getHeight
    Get tree heigh
    @param tree alphaTree tree we want to get hight from.
    @return tree height
 *)
 let rec getHeight tree =
    match tree with
    | V -> 0
    | F(_) -> 1
    | N(fg,_,fd) -> max (getHeight fg) (getHeight fd) + 1;;

(*
    @rightRotate
    Swap tree element to right
    @param tree alphaTree tree to rotate
    @return tree rotated
 *)
let rec rightRotate tree =
    match tree with
    | N(F(a),r,V) -> N(V, a, F(r))
    | N(
        N(fgg, rg, fgd),
        r, fd
      ) -> N(fgg, rg, N(fgd, r, fd))
    | _ -> tree;;

(*
    @leftRotate
    Swap tree element to left
    @param tree alphaTree tree to rotate
    @return tree rotated
 *)
let rec leftRotate tree =
    match tree with
    | N(V,r,F(a)) -> N(F(r), a, V)
    | N(
        fg, r,
        N(fdg, rd, fdd)
      ) -> N(N(fg, r, fdg), rd, fdd)
    | _ -> tree;;

(*
    @balance
    Balance a tree to avoid having a big useless tree
    @param tree alphaTree tree to balance
    @return tree balanced
 *)
let rec balance tree =
    match tree with
    | V -> V
    | F (_) -> tree
    | N (fg, _, fd) ->
        begin
            let h1 = getHeight (balance fg) and h2 = getHeight (balance fd) in
            let diff = h1 - h2 in
            if (diff > 1)
            then rightRotate tree
            else
                if (diff < -1)
                then leftRotate tree
                else tree
        end;;

(*
    @add
    Simple function to add an element into a alphaTree tree.
    @param i string element to add
    @param tree alphaTree tree in whom we which to add the element
    @return new tree with i added into old tree
*)
let rec add i tree =
    match tree with
    | V -> F (i)
    | F (a) -> if a < i then N (V, a, F(i)) else N (F(i), a, V)
    | N(fg, r, fd) -> if i < r then balance (N (add i fg, r, fd)) else balance (N(fg, r, add i fd));;

(*
    @addTreeInTree
    Function to add a correct tree into a correct tree
    @param tree1 alphaTree tree to add
    @param tree2 alphaTree tree where to add
    @return new tree
 *)
let rec addTreeInTree tree1 tree2 =
    match tree1 with
    | V-> tree2
    | F (e) -> add e tree2
    | (N (fg, r, fd)) ->
        begin
            let newTree = add r tree2 in
            let newTree = addTreeInTree fg newTree in
            addTreeInTree fd newTree
        end;;

(*
    @isIn
    Function to check if some element is in the tree
    @param e string element to find
    @param tree alphaTree tree where to find the element
    @return true if e is in tree, false else
 *)
 let rec isIn e tree =
    match tree with
    | V -> false
    | F(a) -> a == e
    | N(fg,r,fd) -> r == e || (r > e && isIn e fg) || (isIn e fd);;

(*
    @myMapEasy
    Function to applu some function to each element in a tree
    @param tree alphaTree tree where to find the elements
    @param f string -> string function to apply'
    @return new tree with no moved elements
 *)
let rec myMapEasy tree f =
    match tree with
    | F(a) -> F (f a)
    | N(fg,r,fd) -> N(myMapEasy fg f, f r, myMapEasy fd f)
    | _ -> V;;

(*
    @myMap
    Function to applu some function to each element in a tree
    @param tree alphaTree tree where to find the elements
    @param f string -> string function to apply'
    @return new tree correctly formed
 *)
let rec myMap tree f =
    match tree with
    | F(a) -> F (f a)
    | N(fg,r,fd) -> let tmpTree = add (f r) (myMapEasy fg f) in addTreeInTree tmpTree (myMapEasy fd f)
    | _ -> V;;

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
    @param t alphaTree tree to draw
    @param x string initial width position in px
    @param y string initial height position in px
    @param h string height of step in px
    @param w string width of step in px
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


openGraph "1900" "1000";;

#trace balance;;

resetGraph;;
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
let testTree = add (- 10) testTree


let newTree = newEmptyTree ();;
let newTree = add 10 newTree;;
let newTree = add 2 newTree;;
let newTree = add 84 newTree;;
let newTree = add 10 newTree;;
let newTree = add 51 newTree;;
let newTree = add 67 newTree;;
let newTree = add 91 newTree;;
let newTree = add 17 newTree;;
let newTree = add 100 newTree;;
let newTree = add (- 41) newTree;;
let newTree = add (- 872) newTree;;
let newTree = add (- 13) newTree;;
let newTree = add (- 31) newTree;;
let newTree = add (- 46) newTree;;
let newTree = add (- 90) newTree;;
let newTree = add (- 788) newTree;;
let newTree = add (- 1) newTree;;

magicDrawing testTree drawInt;;

getHeight (V);;
getHeight (F(1));;
getHeight (N(V,1,F(2)));;
getHeight testTree;;
print_newline();;
print_newline();;

isIn 1 V;;
print_newline();;
isIn 2 (F(1));;
isIn 1 (F(1));;
print_newline();;
isIn 0 (N(F(1),2,F(3)));;
isIn 1 (N(F(1),2,F(3)));;
isIn 2 (N(F(1),2,F(3)));;
isIn 3 (N(F(1),2,F(3)));;
print_newline();;
isIn (1000) testTree;;
isIn (-1000) testTree;;
isIn(8) testTree;;
isIn (-10) testTree;;
isIn(7) testTree;;

print_newline();;
print_newline();;
addTreeInTree V V;;
addTreeInTree V (F(1));;
addTreeInTree V (N(F(1), 0, V));;
print_newline();;
addTreeInTree (F(1)) V;;
addTreeInTree (F(2)) (F(1));;
addTreeInTree (F(1)) (N(F(1), 2, F(3));;
print_newline();;
let newTestTree = addTreeInTree newTree testTree;;
magicDrawing  newTestTree drawInt;;

(* let tranform a = a * 2 +1;;

let testTransformedTree = myMapEasy testTree tranform;;
magicDrawing testTransformedTree drawInt;;

let testTransformedTree = myMap testTree tranform;;
magicDrawing testTransformedTree drawInt;; *)