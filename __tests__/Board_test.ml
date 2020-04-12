open Jest
open Expect

open Board

let k rank : Board.position = (Board.King, (Board.Rank rank))
let q rank : Board.position = (Board.Queen, (Board.Rank rank))

let () =
  describe "Initial board" (fun () ->
      test "moves the white king to K1" (fun () ->
          expect (Board.get (k 1)) |> toEqual Board.Moved);
      test "moves the white queen to Q1" (fun () ->
          expect (Board.get (q 1)) |> toEqual Board.Moved);
      test "removes all pieces from K3" (fun () ->
          expect (Board.get (k 3)) |> toEqual (Board.Removed (k 3)));
      test "removes all pieces from Q5" (fun () ->
          expect (Board.get (q 5)) |> toEqual (Board.Removed (q 5)));
      test "removes all pieces from the third rank" (fun () ->
          expect (Board.get (k 3)) |> toEqual (Board.Removed (k 3)));
    );
  describe "P-K7" (fun () ->
      test "is unreachable when the board is initialized" (fun () ->
          expect (Board._turn Board.Pawn (Board.Removed (k 7))) |> toBe Board.Unreachable);
    );
  describe "K-K2" (fun () ->
      test "creates conflict when the board is initialized" (fun () ->
          expect (Board._turn Board.King Board.Moved) |> toBe Board.Conflict);
    );
  describe "Initial pawn movement" (fun () ->
      test "fails when the destination is K7" (fun () ->
          expect (Board.turn Board.Pawn (Board.Empty (k 7))) |> toBe Board.Unreachable);
      test "fails when moved backward" (fun () ->
          expect (Board.turn Board.Pawn (Board.Empty (k 1))) |> toBe Board.Unreachable);
      test "succeeds when the move is P-K3" (fun () ->
          expect (Board.turn Board.Pawn (Board.Empty (k 3))) |> toBe Board.Moved);
      test "succeeds when the move is P-Q3" (fun () ->
          expect (Board.move Board.Pawn (q 3)) |> toBe Board.Moved);
    );
  describe "Initial knight movement" (fun () ->
      test "fails when the destination is K7 and K7 is empty" (fun () ->
          expect (Board.turn Board.Knight (Board.Empty (k 7))) |> toBe Board.Unreachable);
    );
  describe "Initial King movement" (fun () ->
      test "fails when the destination is K2 and K2 is occupied" (fun () ->
          expect (Board.turn Board.King (Occupied ((k 2), Board.Pawn))) |> toBe Board.Conflict);
      test "fails when the move is K-K3" (fun () ->
          expect (Board.move Board.King (k 3)) |> toBe Board.Unreachable);
    );
  describe "Game play" (fun () ->
      test "fails when first move is K-K2" (fun () ->
          expect (Board.play [(Board.King, (k 2))]) |> toBe Board.Conflict);
      test "fails when first move is K-K2 and second move is valid" (fun () ->
          expect (Board.play [(Board.King, (k 2)); (Board.Pawn, (q 3))]) |> toBe Board.Conflict);
      test "fails when first move is P-K7 and second move is valid" (fun () ->
          expect (Board.play [(Board.Pawn, (k 7)); (Board.Pawn, (q 3))]) |> toBe Board.Unreachable);
      test "fails when second move is K-K2" (fun () ->
          expect (Board.play [(Board.Pawn, (q 3)); (Board.King, (k 2))]) |> toBe Board.Conflict);
    );
