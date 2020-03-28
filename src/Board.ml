module Board = struct
  type piece =
    | King
    | Queen
    | Pawn

  type moveFailure =
    | NoPieceToMove

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  let occupant (file, Rank rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let move piece (toFile, toRank) =
    match toRank with
    | 7 -> NoPieceToMove
    | 1 -> NoPieceToMove
end

