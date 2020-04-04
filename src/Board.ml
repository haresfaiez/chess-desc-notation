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

  type square = (position * (piece option))

  type _square =
    | Occupied of square
  
  let occupant (file, Rank rank) =
    let piece = match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None in
    ((file, Rank rank), piece)

  let move (subject : piece) (((toFile, (Rank toRank)), occupant) : square) : moveFailure =
    match occupant with
    | Some piece -> OccupiedDestination
    | None       -> match toRank with
                    | _ -> NoPieceToMove

  let _move piece (Occupied square) = (move piece square)
end

