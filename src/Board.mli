module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type square = (piece * rank)

  type source = square * square list

  type movement = piece * source * square

  type history = movement list

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | End

  val moveOptions  : piece -> source list -> square -> turn list
  val move         : piece -> source list -> square -> turn
  val play         : (piece * square) list -> history -> turn
  val turn         : piece -> square -> history -> turn
  val init         : square -> history
  val setup        : piece -> source list
end
