import Color            exposing (..)
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Transform2D      exposing (..)
import Text             exposing ( fromString )

label : a -> Float -> Form
label elm size = 
  elm |> toString
      |> fromString
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

leg : Direction -> (Float, Float) -> Path
leg direction (x, y) = 
  case direction of
    Left  -> pathTo ( x, y)
    Right -> pathTo (-x, y)

legs : (Float, Float) -> Maybe Direction -> List Path
legs point direction = 
  case Maybe.map2 leg direction (Just point) of
    Nothing -> [ ]
    Just a  -> [a]

wedgeWidth : Float -> Height -> Float
wedgeWidth w h = w / toFloat (2 ^ h + 2 ^ (h - 1) - 1) * (3 / 8) * 2 ^ toFloat h

treeForm : Float -> Tree a -> Form
treeForm nodeSize tree = 
  let 
    h = height tree
    yOffs = 400 / (toFloat h - 1)
    legForm : Path -> Form
    legForm = moveY (yOffs / 2) << traced defaultLine
    subtree : Maybe Direction -> Tree a -> Float -> Form
    subtree direction tree xOffs = 
      group <| case tree of 
       Empty -> []
       Node left elm right -> 
         (legForm `List.map` legs (2 * xOffs, yOffs) direction
      ++ [ subtree (Just Left ) left  (xOffs / 2) |> move (-xOffs, -yOffs) 
         , subtree (Just Right) right (xOffs / 2) |> move ( xOffs, -yOffs)
         , node elm nodeSize |> moveY (yOffs / 2) ])
  in group 
      [ moveY (200 - yOffs / 2) (subtree Nothing tree (wedgeWidth 400 h))
      , outlined defaultLine (rect 400 400) ]

type Tree a = Empty | Node (Tree a) a (Tree a)

type alias Height = Int

height : Tree a -> Height
height tree = 
  case tree of
    Empty -> 0 
    Node left _ right -> 1 + max (height left) (height right)

------------

myTree = Node (Node (Node (Node Empty 1 Empty) 2 (Node Empty 3 Empty)) 4 (Node Empty 5 Empty)) 6 (Node Empty 7 Empty) --Node (Node (Node (Node (Node (Node Empty 0 Empty) 0 (Node Empty 0 Empty)) 1 (Node Empty 2 Empty)) 2 (Node Empty 3 Empty)) 4 Empty) 5 (Node Empty 7 Empty)

main : Element
main = collage 500 700 [ treeForm 18 myTree ]
