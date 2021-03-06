# Chess descriptive notation emulator

> Descriptive notation is a notation system for recording chess games which was used in English,
> Spanish and French chess literature until about 1980 (Brace 1977:79–80) (Sunnucks 1970:325).
> [Wikipedia](https://en.wikipedia.org/wiki/Descriptive_notation)

## Test

Use `npm test` to run tests

## Chess notation

### Rank
A row of the chess board. We use numbers from 1 to 8 to denote ranks.

### File
A column of the chess board. We refer to each file using the name of the piece
we put in that column in the initial configuration.

### Pieces
* K : King
* Q : Queen
* Kt: Knight (some notations use `N` here)
* B : Bishop
* R : Rook
* P : Pawn

## Problems with descriptive notation
* `B1` is can be either on the queen side or on the king side. You can specify that as
  `KB1` or `QB1`.

## TCR

### [-]
* Need to commit README updates manually
* Sometimes the test pass because it was badly written, not because it fails (you catch it
in the diff analysis).
* The slow degradation of quality is still hard to see.

### [+]
* It is similar to repl driven development.
* If you want to make the sure you have written the test correctly or that the test normally fails,
  change the implementation or the test. You probably have a flawed model of the code.
* It is about small safe steps. You could have big unsafe steps even with a strong type system.
* Works well with types (those tests won't compile in TDD).
* You get another chance to revert if you leave the git message empty.
* Behavior change and structure changes are separated.
* A lot of refactoring will be extracting/rearranging type definitions.
* When a test fails, you write a more specific one, narrowing down the scope each time.
* Refactoring strategies: test-add-change usage-remove vs. extract-test-add-change usage-remove
* There is an interesting play. When you replace a constant with a function call to make an early test work
  and you fail. Change the code so that the next time you do the change with the same assumptions, you succeeds.
  When the commit fails because of wrong assumptions, think about simplifying the code or about changing your
  next step.
* To make a change, "extract a function". Usually, I extract a function then change all the remaining
  code to call that function. Then, run the tests.
  Now, I extract it. I run tcr. I reflect on the diff to see any improvement to the calling code.
  The I change another, same thing. Then I change the rest.
* If the change is small and the test/build fails. Then, our model is flawed.
  Eiither because we are not doing the right change, we are not doing the right change in the right way,
  or we are missing something fundamental.
* I used to test my code with a `git diff` before committing, now I use `npm run tcr`.
  The cost of revert is low, I get to see the diff, and what I expect to fail is in the test.
  If the test fails, the code should be modified/rewritten better. If the test succed and I notice
  a defect, we have a clean state for the known next test.
* Baby steps will tiny. You will have to introduce one change at a time.
  If you want to introduce two and forget to finish one, the compiler or the test
  disagrees. Example: add new movement for a new piece -> failure.
  You need to first add the piece, tcr, then add the movement, tcr.
* "Make the test pass as soon as possible" needs to be weighted against "Remove the test and think harder".
  Otherwise, you heading toward a tunnel.

### Ocaml
* Deconstruction is a good way to avoid booleans/compression, or at least delay their use.

## How to
* Emacs `auto-revert-mode`
* Start with failed cases (the non-happy path), e.g Board.move implementation.
* Baby steps: want a refactoring repeated. Either change the design to make failure of test/revert
  less costly (This means better design, less possible states and less bugs, and continuous iteration)
  or one-two-many (change one and commit, change two with the most gap and commit, change the others).
* More time testing/analyzing the code before commit (feedback to fix glitches early, when have little impact).