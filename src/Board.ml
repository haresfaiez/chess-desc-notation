module Board = struct
  type piece =
    | King
    | Queen
  let pieceAt file rank =
    match file with
    | 'K' -> King
    | 'Q' -> Queen
  let at file rank =
    match file with
    | King -> King
    | Queen -> Queen
end

