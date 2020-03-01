open Jest
open Expect

open Board

let () =
  describe "Initial board" (fun () ->
      test "puts the white king in K1" (fun () ->
          expect (Board.pieceAt 'K' 1) |> toBe Board.King);
      test "puts the white queen in Q1" (fun () ->
          expect (Board.pieceAt 'Q' 1) |> toBe Board.Queen);
    );
