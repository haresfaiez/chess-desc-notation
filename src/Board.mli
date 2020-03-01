module Board : sig
  type piece =
    | King
    | Queen
  val pieceAt: char -> int -> piece
  val at     : piece -> int -> piece
end
