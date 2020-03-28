module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type moveFailure =
    | NoPieceToMove
    | OccupiedDestination

  val occupant: (piece * rank) -> piece option
  val move    : piece -> (piece * int) -> moveFailure
end
