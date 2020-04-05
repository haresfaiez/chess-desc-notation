module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type moveFailure =
    | NoPieceToMove
    | OccupiedDestination

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
    | Occupied _                 -> OccupiedDestination
    | Empty (file, (Rank rank))  -> match rank with
                                    | _ -> NoPieceToMove

  let rec play moves =
    match moves with
    | (piece, position) :: []   -> move piece (square position)
    | (piece, position) :: next -> play next
end
