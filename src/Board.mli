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

  type movement = piece * position * position

  type _square =
    | P of position

  type history = (piece * position * _square) list

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | End

  val moveOptions  : piece -> position list -> square -> turn list
  val move         : piece -> position list -> square -> turn
  val play         : (piece * square) list -> history -> turn
  val start        : (piece * square) list -> turn
  val turn         : piece -> square -> history -> turn
  val init         : square -> history
  val setup        : piece -> position list
end
