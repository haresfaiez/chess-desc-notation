module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type square = (piece * rank)

  type position = square * square list

  type history = (piece * position * square) list

  type turn =
    | Unreachable
    | Conflict
    | Moved: (piece * position * position) -> turn
    | End

  val moveOptions  : piece -> position list -> square -> turn list
  val move         : piece -> position list -> square -> turn
  val play         : (piece * square) list -> history -> turn
  val turn         : piece -> square -> history -> turn
  val init         : square -> history
  val setup        : piece -> position list
end
