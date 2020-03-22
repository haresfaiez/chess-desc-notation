module Board : sig
  type piece =
    | King
    | Queen
    | Pawn

  type rank =
    | Rank of int

  type moveFailure =
    | NotInStartPosition
    | UnauthorizedMove

  val occupant: (piece * int) -> piece option
  val _occupant: (piece * rank) -> piece option
  val move    : piece -> (piece * int) -> moveFailure
end
