open Jest
open Expect

open Board

let () =
  describe "Initial board" (fun () ->
      test "puts the white king in K1" (fun () ->
          expect (Board.occupant (Board.King, (Board.Rank 1))) |> toBe (Some Board.King));
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
      test "fails when moved to K7" (fun () ->
          expect (Board.move Board.Pawn (Board.King, 7)) |> toBe Board.NoPieceToMove);
      test "fails when moved backward" (fun () ->
          expect (Board.move Board.Pawn (Board.King, 1)) |> toBe Board.NoPieceToMove);
    );
  describe "Initial knight movement" (fun () ->
      test "fails when moved to K7" (fun () ->
          expect (Board.move Board.Knight (Board.King, 7)) |> toBe Board.NoPieceToMove);
    );
