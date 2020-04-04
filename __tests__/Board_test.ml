open Jest
open Expect

open Board

let k rank : Board.position = (Board.King, (Board.Rank rank))
let q rank : Board.position = (Board.Queen, (Board.Rank rank))

let () =
  describe "Initial board" (fun () ->
      test "puts the white king in K1" (fun () ->
          expect (Board.occupant (k 1)) |> toEqual ((k 1), (Some Board.King)));
      test "puts the white queen in Q1" (fun () ->
          expect (Board.occupant (q 1)) |> toEqual ((q 1), (Some Board.Queen)));
      test "puts no piece in K3" (fun () ->
          expect (Board.occupant (k 3)) |> toEqual ((k 3), None));
      test "puts no piece in Q5" (fun () ->
          expect (Board.occupant (q 5)) |> toEqual ((q 5), None));
      test "third rank is empty" (fun () ->
          expect (Board.occupant (k 3)) |> toEqual ((k 3), None));
    );
  describe "Initial pawn movement" (fun () ->
      test "fails when the destination is K7" (fun () ->
          expect (Board.move Board.Pawn (Board.Empty (k 7))) |> toBe Board.NoPieceToMove);
      test "fails when moved backward" (fun () ->
          expect (Board.move Board.Pawn (Board.Empty (k 1))) |> toBe Board.NoPieceToMove);
    );
  describe "Initial knight movement" (fun () ->
      test "fails when the destination is K7 and K7 is empty" (fun () ->
          expect (Board.move Board.Knight (Board.Empty (k 7))) |> toBe Board.NoPieceToMove);
    );
  describe "Initial King movement" (fun () ->
      test "fails when the destination is K2 and K2 is occupied" (fun () ->
          expect (Board.move Board.King (Occupied ((k 2), Board.Pawn))) |> toBe Board.OccupiedDestination);
    );
