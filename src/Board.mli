module Board : sig
  type piece =
    | King
    | Queen
    | Pawn
  val occupant: piece -> int -> piece option
end
