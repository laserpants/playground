import Color            exposing (..)
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Transform2D      exposing (..)
import Text             exposing (..)

label : a -> Float -> Form
label elm size = 
  elm |> toString
      |> Text.fromString
      |> Text.height size
      |> text

node : a -> Float -> Form
node elm size = group
  [ circle size    |> filled white
  , circle size    |> outlined defaultLine 
  , label elm size |> moveY (size / 5) ]

pathTo : (Float, Float) -> Path
pathTo = segment (0, 0) 

type Direction = Left | Right

leg : (Float, Float) -> Maybe Direction -> List Path
leg point direction = 
  let
    path (x, y) dir = 
      case dir of
        Left  -> pathTo ( x, y)
        Right -> pathTo (-x, y) 
  in 
    Maybe.map2 path (Just point) direction |> maybeToList

wedgeWidth : Float -> Float -> Float
wedgeWidth w h = w / (2^h + 2^(h - 1) - 1) * (3 / 8) * 2^h

tree  : Int 
     -> Int 
     -> Float 
     -> Tree a 
     -> Element
tree xSize ySize nodeSize tree = 
  let 
    xSize'     = toFloat xSize - nodeSize * 2 - 2
    ySize'     = toFloat ySize - nodeSize * 2 - 2
    treeHeight = toFloat (height tree)
    yOffs      = ySize' / (treeHeight - 1)
    legForm    = moveY (yOffs / 2) << traced defaultLine
    subtree : Maybe Direction -> Tree a -> Float -> List Form
    subtree direction tree xOffs = 
      case tree of 
        Empty -> []
        Node left elm right -> 
          List.map legForm (leg (2 * xOffs, yOffs) direction)
       ++ List.map (move (-xOffs, -yOffs)) (subtree (Just Left ) left  (xOffs / 2))
       ++ List.map (move ( xOffs, -yOffs)) (subtree (Just Right) right (xOffs / 2))
       ++ [ node elm nodeSize |> moveY (yOffs / 2) ]
  in collage xSize ySize [ group 
      [ (group <| subtree Nothing tree 
               <| wedgeWidth xSize' treeHeight) 
                |> moveY ((ySize' - yOffs) / 2) ] ]

maybeToList : Maybe a -> List a
maybeToList val =
  case val of
    Nothing -> [ ]
    Just a  -> [a]

type Tree a = Empty | Node (Tree a) a (Tree a)

height : Tree a -> Int
height tree = 
  case tree of
    Empty -> 0 
    Node left _ right -> 1 + max (height left) (height right)

------------

myTree = Node (Node (Node (Node Empty 1 Empty) 2 (Node Empty 3 Empty)) 4 (Node Empty 5 Empty)) 6 (Node Empty 7 Empty) --Node (Node (Node (Node (Node (Node Empty 0 Empty) 0 (Node Empty 0 Empty)) 1 (Node Empty 2 Empty)) 2 (Node Empty 3 Empty)) 4 Empty) 5 (Node Empty 7 Empty)

main : Element
main = tree 500 300 15 myTree 
