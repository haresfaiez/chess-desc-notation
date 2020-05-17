module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type position = (piece * rank)

  type source = position * position list

  type movement = piece * position * position

  type turn =
    | Unreachable
    | Conflict
    | Moved: (piece * source * position) -> turn
    | End

  let init position =
    match position with
    | (file, Rank 1) -> [(file, position, position)]
    | (_, Rank 2)    -> [(Pawn, position, position)]
    | _              -> []

  let setup piece =
    let at rank = (piece, Rank rank) in
    let pawnAt file = ((file, Rank 2), [(file, Rank 3)]) in
    match piece with
    | King   -> [(at 1, [(at 2)])]
    | Queen  -> [(at 1, [(at 2); (at 3); (at 4)])]
    | Pawn   -> [(pawnAt Knight); (pawnAt Queen); (pawnAt King); (pawnAt Knight)]
    | _      -> [((piece, Rank 1), []); ((piece, Rank 1), [])]

  let rec moveOptions piece sources destination =
    let check (piece, (source, options), destination) next =
      if (List.exists (fun e -> e = destination) options)
      then [Moved (piece, (source, options), destination)]
      else if (piece = Queen)
      then [Moved (piece, (source, []), destination)]
      else moveOptions piece next destination
    in
    match sources with
    | []             -> [Unreachable]
    | source :: next -> check (piece, source, destination) next

  (* Implement a strategy to select the option *)
  let move piece sources destination = List.hd (moveOptions piece sources destination)

  let rec turn piece destination history =
    match history with
    | []                                           -> move piece (setup piece) destination
    | (_, _, dst) :: _      when destination = dst -> Conflict
    | (_, src, _)      :: _ when destination = src -> move piece (setup piece) destination
    | _                                            -> turn piece destination (List.tl history)

  let rec play moves history =
    match moves with
    | []                     -> End
    | (piece, position) :: _ -> let outcome = turn piece position (List.append history (init position)) in
                                match outcome with
                                | Moved _ -> play (List.tl moves) ((piece, (Queen, Rank 2), position) :: history)
                                | _       -> outcome

end
