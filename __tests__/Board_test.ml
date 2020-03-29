open Jest
open Expect

open Board

let k1 : Board.position = (Board.King, (Board.Rank 1))
let k7 : Board.position = (Board.King, (Board.Rank 7))
let k2 : Board.position = (Board.King, (Board.Rank 2))

let occupiedK rank piece : Board.square = ((Board.King, (Board.Rank rank)), (Some piece))

let () =
  describe "Initial board" (fun () ->
      test "puts the white king in K1" (fun () ->
          expect (Board.get k1) |> toEqual (occupiedK 1 Board.King));
      test "puts the white queen in Q1" (fun () ->
          expect (Board.occupant (Board.Queen, (Board.Rank 1))) |> toBe (Some Board.Queen));
      test "puts no piece in K3" (fun () ->
          expect (Board.occupant (Board.King, (Board.Rank 3))) |> toBe None);
      test "puts no piece in Q5" (fun () ->
          expect (Board.occupant (Board.Queen, (Board.Rank 5))) |> toBe None);
      test "third rank is empty" (fun () ->
          expect (Board.occupant (Board.King, (Board.Rank 3))) |> toBe None);
    );
  describe "Initial pawn movement" (fun () ->
      test "fails when the destination is K7" (fun () ->
          expect (Board._move Board.Pawn (k7, None)) |> toBe Board.NoPieceToMove);
      test "fails when moved backward" (fun () ->
          expect (Board.move Board.Pawn k1 None) |> toBe Board.NoPieceToMove);
    );
  describe "Initial knight movement" (fun () ->
      test "fails when the destination is K7" (fun () ->
          expect (Board.move Board.Knight k7 None) |> toBe Board.NoPieceToMove);
    );
  describe "Initial King movement" (fun () ->
      test "fails when the destination is K2" (fun () ->
          expect (Board.move Board.King k2 (Some Board.Pawn)) |> toBe Board.OccupiedDestination);
    );
