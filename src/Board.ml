module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type position = (piece * rank)

  type turn =
    | Unreachable
    | Conflict
    | Moved

  type movement = piece * position * position

  (* Remove this *)
  let occupant (file, Rank rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let move piece destination =
    match destination with
    | (_, (Rank 3)) -> (match piece with
                        | King -> Unreachable
                        | Pawn -> Moved)
    | (Queen, _)    -> Moved
    | _             -> Unreachable

  let turn piece position =
    let (file, Rank rank) = position in
    let current = (match rank with
                   | 1 -> Conflict
                   | 2 -> Conflict
                   | _ -> move piece position) in
    current

  let rec playTurn piece position history =
    match history with
    | []                                                   -> move piece position
    | (_, _, destination) :: _ when position = destination -> Conflict
    | (_, source, _)      :: _ when position = source      -> move piece position
    | _                                                    -> playTurn piece position (List.tl history)

  let rec play moves =
    match moves with
    | []                     -> Moved
    | (piece, position) :: _ -> let outcome = turn piece position in
                                match outcome with
                                | Moved -> play (List.tl moves)
                                | _     -> outcome

  let shiftRank piece (file, Rank origin) steps = (piece, (file, Rank origin), (file, Rank (origin + steps)))
end
