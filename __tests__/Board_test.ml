open Jest
open Expect

open Board

let k rank : Board.position = (Board.King, (Board.Rank rank))
let q rank : Board.position = (Board.Queen, (Board.Rank rank))

let () =
  describe "Initial board" (fun () ->
      test "puts the white king in K1" (fun () ->
          expect (Board.square (k 1)) |> toEqual (Board.Occupied ((k 1), Board.King)));
      test "moves the white king to K1" (fun () ->
          expect (Board.get (k 1)) |> toEqual Board.Moved);
      test "puts the white queen in Q1" (fun () ->
          expect (Board.square (q 1)) |> toEqual (Board.Occupied ((q 1), Board.Queen)));
      test "puts no piece in K3" (fun () ->
          expect (Board.square (k 3)) |> toEqual (Board.Empty (k 3)));
      test "removes all pieces from K3" (fun () ->
          expect (Board.get (k 3)) |> toEqual (Board.Removed (k 3)));
      test "puts no piece in Q5" (fun () ->
          expect (Board.square (q 5)) |> toEqual (Board.Empty (q 5)));
      test "third rank is empty" (fun () ->
          expect (Board.square (k 3)) |> toEqual (Board.Empty (k 3)));
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
          expect (Board.turn Board.King (Occupied ((k 2), Board.Pawn))) |> toBe Board.OccupiedDestination);
      test "fails when the move is K-K3" (fun () ->
          expect (Board.move Board.King (k 3)) |> toBe Board.Unreachable);
    );
  describe "Game play" (fun () ->
      test "fails when first move is K-K2" (fun () ->
          expect (Board.play [(Board.King, (k 2))]) |> toBe Board.OccupiedDestination);
      test "fails when first move is K-K2 and second move is valid" (fun () ->
          expect (Board.play [(Board.King, (k 2)); (Board.Pawn, (q 3))]) |> toBe Board.OccupiedDestination);
      test "fails when first move is P-K7 and second move is valid" (fun () ->
          expect (Board.play [(Board.Pawn, (k 7)); (Board.Pawn, (q 3))]) |> toBe Board.Unreachable);
      test "fails when second move is K-K2" (fun () ->
          expect (Board.play [(Board.Pawn, (q 3)); (Board.King, (k 2))]) |> toBe Board.OccupiedDestination);
    );
