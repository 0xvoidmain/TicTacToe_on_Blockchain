pragma solidity 0.4.0;


contract TicTacToe {
  struct Game {
    uint[] board;
    address player1; // X
    address player2; // O
    bool isFinish;
    address moveOf;
  }

  Game[] public games;
  mapping(address => uint) public players;

  constructor() public {
    games.push(Game({
      board: new uint[](9),
      player1: address(0x0),
      player2: address(0x0),
      isFinish: true,
      moveOf: address(0x0)
    }));
  }

  function joinGame() public payable {
    address player = msg.sender;
    uint value = msg.value;

    require(value >= 1 ether, "Value less than 1 ether");
    require(games[players[player]].isFinish, "You are playing in other game");

    if (value > 1 ether) {
      player.transfer(value - 1 ether);
      value = 1 ether;
    }

    Game storage lastGame = games[games.length - 1];
    if (lastGame.isFinish) {
      addNewGame(player);
    }
    else if (lastGame.player2 == address(0x0)) {
      lastGame.player2 = player;
      players[player] = games.length - 1;
    }
    else {
      addNewGame(player);
    }
  }

  function addNewGame(address player)  public {
    games.push(Game({
      board: new uint[](9),
      player1: player,
      player2: address(0x0),
      isFinish: false,
      moveOf: player
    }));
    players[player] = games.length - 1;
  }

  function doMove(uint place) public {
    address player = msg.sender;
    Game storage game = games[players[player]];

    require(game.player1 != address(0x0) && game.player2 != address(0x0), "Error game");
    require(!game.isFinish, "Game finished");
    require(game.moveOf == msg.sender, "Not your turn");
    require(place >= 0 && place <= 8, "Wrong place");
    require(game.board[place] == 0, "Cannot move to this place");

    if (game.moveOf == game.player1) {
      game.moveOf = game.player2;
      game.board[place] = 1;
    }
    else {
      game.moveOf = game.player1;
      game.board[place] = 2;
    }

    uint winner = checkWinner(players[player]);
    if(winner == 1){
      game.player1.transfer(2 ether);
      game.isFinish = true;
    }
    if (winner == 2){
      game.player2.transfer(2 ether);
      game.isFinish = true;
    }
    if (winner == 3) {
      game.player1.transfer(1 ether);
      game.player2.transfer(1 ether);
      game.isFinish = true;
    }
  }

  // 0 1 2
  // 3 4 5
  // 6 7 8
  uint[][]  tests = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]];
  // return 0: isPlaying, 1: X win, 2: O Win, 3: Draw
  function checkWinner(uint gameIndex) private view returns (uint){
    uint[] memory board = games[gameIndex].board;
    uint count = 0;
    for(uint i = 0; i < 8; i++){
      uint[] memory b = tests[i];
      if (board[i] != 0) {
        count++;
      }
      if(board[b[0]] != 0 && board[b[0]] == board[b[1]] && board[b[0]] == board[b[2]]) {
        return board[b[0]];
      }
    }

    return count == 8 ? 3 : 0;
  }

  function getGameOf(address player) public view
    returns(address player1, address player2, uint[] board, bool isFinish, address moveOf, uint result) {
    Game memory game = games[players[player]];
    isFinish = game.isFinish;
    player1 = game.player1;
    player2 = game.player2;
    moveOf = game.moveOf;
    board = game.board;
    result = checkWinner(players[player]);
  }
}