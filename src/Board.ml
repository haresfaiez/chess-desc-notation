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
    | Moved: movement -> turn
    | End

  let init position =
    match position with
    | (file, Rank 1) -> [(file, position, position)]
    | (_, Rank 2)    -> [(Pawn, position, position)]
    | _              -> []

  let setup piece =
    let at rank = (piece, Rank rank) in
    match piece with
    | King   -> [(at 1, [(at 2)])]
    | Queen  -> [(at 1, [(at 2); (at 3); (at 4)])]
    | Pawn   -> [((Knight, Rank 2), []); ((Queen, Rank 2), []); ((King, Rank 2), []); ((Knight, Rank 2), [])]
    | _      -> [((piece, Rank 1), []); ((piece, Rank 1), [])]

  let isDestination (source, options) destination = List.exists (fun each -> each = destination) options

  let rec moveOptions piece sources destination =
    let check (piece, (source, options), destination) next = (* Replace with source.options contains destination *)
      let current = (piece, source, destination) in
      if (isDestination (source, options) destination) then [Moved current] else
      (match current with
       | (King, (_, (Rank 1)), (_, (Rank 2)))                      -> [Moved current]
       | (Pawn, (src, (Rank 2)), (dest, (Rank 3))) when src = dest -> [Moved current]
       | (Queen, _, (Queen, _))                                    -> [Moved current]
       | _                                                         -> moveOptions piece next destination) in
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

  let shiftRank piece (file, Rank origin) steps = (piece, (file, Rank origin), (file, Rank (origin + steps)))
end
