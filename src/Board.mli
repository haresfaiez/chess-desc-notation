module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type moveFailure =
    | NoPieceToMove
    | OccupiedDestination

  val get     : position -> (position * (piece option))
  val occupant: (piece * rank) -> piece option
  val move    : piece -> (piece * int) -> moveFailure
end
