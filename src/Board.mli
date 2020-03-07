module Board : sig
  type piece =
    | King
    | Queen
    | Pawn
  type moveFailure =
    | NotInStartPosition
    | UnauthorizedMove
  val occupant: (piece * int) -> piece option
  val move    : piece -> (piece * int) -> moveFailure
end
