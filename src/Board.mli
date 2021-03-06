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

  type movement = position * position

  type history = (piece * position * position) list

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | End

  type setup = piece -> position list

  val moveOptions  : position list -> square -> turn list
  val move         : position list -> square -> turn
  val play         : (piece * square) list -> history -> turn
  val start        : (piece * square) list -> turn
  val turn         : position list -> square -> history -> turn
  val init         : square -> history
  val setup        : setup
  val nextSetup    : setup -> piece -> movement -> setup
end
