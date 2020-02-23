open Jest

module Board = struct
  type piece =
    | King
  let pieceAt a b = King
end

let () =

  describe "Board" (fun () ->
      let open Expect in
      test "should put the white king in K1" (fun () ->
          expect (Board.pieceAt 'K' 1) |> toBe Board.King);
    );
