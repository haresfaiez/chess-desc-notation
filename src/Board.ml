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

  type movement = piece * source * position

  type history = movement list

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | End

  let setup piece =
    let at rank = (piece, Rank rank) in
    let pawnAt file = ((file, Rank 2), [(file, Rank 3)]) in
    match piece with
    | King   -> [(at 1, [(at 2)])]
    | Queen  -> [(at 1, [(at 2); (at 3); (at 4)])]
    | Pawn   -> [(pawnAt Knight); (pawnAt Queen); (pawnAt King); (pawnAt Knight)]
    | _      -> [((piece, Rank 1), []); ((piece, Rank 1), [])]

  let init position =
    match position with
    | (file, Rank 1) -> [(file, List.hd (setup file), position)]
    | (_, Rank 2)    -> [(Pawn, (position, []), position)] (* TODO: Use setup *)
    | _              -> []

  let rec moveOptions piece sources destination =
    let check (piece, (source, options), destination) next =
      if (List.exists (fun e -> e = destination) options)
      then [Moved (piece, (source, options), destination)]
      else if (piece = Queen) (* TODO: Remove this *)
      then [Moved (piece, (source, options), destination)]
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
    | (_, (src, _), _) :: _ when destination = src -> move piece (setup piece) destination
    | _                                            -> turn piece destination (List.tl history)

  let rec play moves history =
    match moves with
    | []                         -> End
    | (piece, nextPosition) :: _ -> let outcome = turn piece nextPosition (List.append history (init nextPosition)) in
                                    match outcome with
                                    | Moved _ -> let source = ((Queen, Rank 2), []) in (* TODO: and fix this *)
                                                 play (List.tl moves) ((piece, source, nextPosition) :: history)
                                    | _       -> outcome

end
