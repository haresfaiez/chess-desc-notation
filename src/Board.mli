module Board : sig
  type piece =
    | King
    | Queen
  val pieceAt: char -> int -> piece
end
