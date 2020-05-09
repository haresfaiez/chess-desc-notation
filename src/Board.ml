module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type position = (piece * rank)

  type movement = piece * position * position

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | NoSources
    | End

  let rec moveOptions piece sources destination =
    match sources with
    | []          -> [Unreachable]
    | source :: _ -> (match destination with
                       | (_, (Rank 3)) -> (match piece with
                                           | King -> moveOptions piece (List.tl sources) destination
                                           | Pawn -> [Moved (Pawn, source, destination)])
                       | (Queen, _)    -> [Moved (Queen, source, destination)]
                       | _             -> moveOptions piece (List.tl sources) destination)
    

  let move piece sources destination =
    match sources with
    | [] -> NoSources
    | _  -> List.hd (moveOptions piece sources destination) (* Implement a strategy to select the option *)

  let rec turn piece position history =
    match history with
    | []                                                   -> move piece [position] position
    | (_, _, destination) :: _ when position = destination -> Conflict
    | (_, source, _)      :: _ when position = source      -> move piece [position] position
    | _                                                    -> turn piece position (List.tl history)

  let init position =
    match position with
    | (file, Rank 1) -> [(file, position, position)]
    | (_, Rank 2)    -> [(Pawn, position, position)]
    | _              -> []

  let rec play moves history =
    match moves with
    | []                     -> End
    | (piece, position) :: _ -> let outcome = turn piece position (List.append history (init position)) in
                                match outcome with
                                | Moved _ -> play (List.tl moves) ((piece, (Queen, Rank 2), position) :: history)
                                | _       -> outcome

  let shiftRank piece (file, Rank origin) steps = (piece, (file, Rank origin), (file, Rank (origin + steps)))
end
