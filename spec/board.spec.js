const board = require('../src/board')

describe('board', () => {
  it('finds a piece in the king-bishop file', () => {
    const game = board.empty()
    game[7] = ['', '', '', '', '', 'Q', '', '']
    expect(board.whiteAt(game, 'KB', 1)).toEqual('Q')
  })

  it('finds a piece in the king file', () => {
    expect(board.whiteAt(board.init(), 'K', 1)).toEqual('K')
  })

  it('initializes the lines of the black player', () => {
    const actual = board.init()

    expect(board.black(1, actual)).toEqual(['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'])
    expect(board.black(2, actual)).toEqual(['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'])
  })

  it('initializes the lines of the white player', () => {
    const actual = board.init()

    expect(board.white(1, actual)).toEqual(['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'])
    expect(board.white(2, actual)).toEqual(['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'])
  })

  it('returns the first line of the white player', () => {
    const singleton = ['B1', 'B2', '', '', '', '', 'W2', 'W1']

    expect(board.white(1, singleton)).toEqual('W1')
  })

  it('has no pieces on creation', () => {
    const actual = board.empty()

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
    expect(actual).toBeTruthy(expected)
  })
})
