const empty = () => {
  return [
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '']
    ]
}

const init = () => {
  const pieces = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']
  const pawns = ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P']

  const result = empty()
  result[0] = pieces
  result[1] = pawns
  result[6] = pawns
  result[7] = pieces
  return result
}

const white = (index, board) => {
  return board[8 - index]
}

const black = (index, board) => {
  return board[index - 1]
}

module.exports = {
  empty,
  init,
  white,
  black
}
