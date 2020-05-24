module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type source = position * position list

  type movement = piece * position * position

  type history = movement list

  type turn =
    | Unreachable
    | Conflict
    | Moved: (piece * source * position) -> turn
    | End

  val moveOptions  : piece -> source list -> position -> turn list
  val move         : piece -> source list -> position -> turn
  val play         : (piece * position) list -> history -> turn
  val turn         : piece -> position -> history -> turn
  val init         : position -> history
  val setup        : piece -> source list
end
