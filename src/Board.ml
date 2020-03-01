module Board = struct
  type piece =
    | King
    | Queen
  let pieceAt file rank =
    match file with
    | 'K' -> King
    | 'Q' -> Queen
  let at file rank = King
end

