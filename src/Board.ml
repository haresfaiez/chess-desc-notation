module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type position = (piece * rank)

  type turn =
    | Unreachable
    | OccupiedDestination
    | Moved
    | Removed: position -> turn

  type square =
    | Occupied: position * piece -> square
    | Empty   : position -> square

  let occupant (file, Rank rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let square position =
    match (occupant position) with
    | Some piece -> Occupied (position, piece)
    | _          -> Empty position

  let get position =
    match (occupant position) with
    | Some piece -> Moved
    | _          -> Removed position

  let move piece destination =
    match destination with
    | (_, (Rank 3)) -> (match piece with
                          | King -> Unreachable
                          | Pawn -> Moved)
    | _             -> Unreachable

  let turn piece destination =
    match destination with
    | Occupied _      -> OccupiedDestination
    | Empty position  -> move piece position

  let _turn piece destination = Unreachable

  let rec play moves =
    match moves with
    | []                     -> Moved
    | (piece, position) :: _ -> match (turn piece (square position)) with
                                   | Moved -> play (List.tl moves)
                                   | _     -> turn piece (square position)
end
