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
    | _             -> Unreachable

  let turn piece position =
    match occupant position with
    | Some piece -> Conflict
    | None       -> move piece position

  let rec playTurn piece position history =
    match history with
    | []                                                   -> Moved
    | (_, _, destination) :: _ when position = destination -> Conflict
    | (_, source, _)      :: _ when position = source      -> Moved
    | _                                                    -> playTurn piece position (List.tl history)

  let rec play moves =
    match moves with
    | []                     -> Moved
    | (piece, position) :: _ -> let turnOutcome = turn piece position in
                                match turnOutcome with
                                | Moved -> play (List.tl moves)
                                | _     -> turnOutcome

  let shiftRank piece (file, Rank origin) steps = (piece, (file, Rank origin), (file, Rank (origin + steps)))
end
