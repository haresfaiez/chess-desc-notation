const board = require('../src/board')

describe('board', () => {
  it('finds a black piece in the queen-bishop file', () => {
    const game = board.empty()
    game[0] = ['', '', 'K', '', '', 'Q', '', '']

    expect(board.blackAt(game, 'QB', 1)).toEqual('K')
  })

  it('finds a black piece in the king-bishop file', () => {
    const game = board.empty()
    game[0] = ['', '', '', '', '', 'Q', '', '']

    expect(board.blackAt(game, 'KB', 1)).toEqual('Q')
  })

  it('finds a white piece in the queen-bishop file', () => {
    const game = board.empty()
    game[7] = ['', '', 'K', '', '', 'Q', '', '']

    expect(board.whiteAt(game, 'QB', 1)).toEqual('K')
  })

  it('finds a white piece in the king-bishop file', () => {
    const game = board.empty()
    game[7] = ['', '', '', '', '', 'Q', '', '']

    expect(board.whiteAt(game, 'KB', 1)).toEqual('Q')
  })

  it('finds a piece in the king file', () => {
    const game = board.init()

    expect(board.whiteAt(game, 'K', 1)).toEqual('K')
  })

  it('initializes the lines of the black player', () => {
    const game = board.init()

    expect(board.black(game, 1)).toEqual(['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'])
    expect(board.black(game, 2)).toEqual(['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'])
  })

  it('initializes the lines of the white player', () => {
    const game = board.init()

    expect(board.white(game, 1)).toEqual(['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'])
    expect(board.white(game, 2)).toEqual(['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'])
  })

  it('returns the first line of the white player', () => {
    const singleton = ['B1', 'B2', '', '', '', '', 'W2', 'W1']

    expect(board.white(singleton, 1)).toEqual('W1')
  })

  it('has no pieces on creation', () => {
    const game = board.empty()

    const expected = [
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '']
    ]
    expect(game).toBeTruthy(expected)
  })
})
