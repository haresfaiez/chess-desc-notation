module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type turn =
    | Unreachable
    | OccupiedDestination
    | Moved

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type position = (piece * rank)

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

  let rec play moves =
    let playTurn piece position = turn piece (square position) in
    match moves with
    | (piece, position) :: []   -> turn piece (square position)
    | (piece, position) :: next -> match (turn piece (square position)) with
                                   | Moved -> play next
                                   | _     -> (turn piece (square position))
end
