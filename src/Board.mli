module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type square = (position * (piece option))

  type moveFailure =
    | NoPieceToMove
    | OccupiedDestination

  val get     : position -> square
  val occupant: position -> piece option
  val _move   : piece -> square -> moveFailure
end
