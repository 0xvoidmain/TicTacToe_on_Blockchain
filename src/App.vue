<template>
  <div id="app">
    <vue-progress-bar></vue-progress-bar>
    <div class="Game">
      <div>{{balance}} TOMO</div>
      <h1 class="title">Tic Tac Toe</h1>
      <div v-if="!isPlaying">
        <button @click="join" class="btn mt40">Join Game</button>
      </div>
      <div v-else>
        <p>{{statusOfGame}}</p>
        <div class="board">
          <button v-for="(e, i) in game.board" :key="`${i}${e}`" class="square" @click="() => move(i)">
            <img v-if="e == 1" src="./assets/x.svg"/>
            <img v-if="e == 2" src="./assets/o.svg"/>
          </button>
        </div>
        <div v-if="game.result > 0">
        <button @click="join" class="btn">Play again</button>
      </div>
      </div>
    </div>
  </div>
</template>

<script>

import Web3 from 'web3';
import abi from './contractABI';
import HDWalletProvider from 'truffle-hdwallet-provider';
import { setInterval, clearInterval, setTimeout } from 'timers';
const contractAddress = '0x50f735463f2b67a4d8ba560f41896879e327fe66';
const RPC = 'https://testnet.tomochain.com';

// const contractAddress = '0xccbca03079d4e4178f646d2184bd1fbfca905219';
// const RPC = 'http://localhost:8545';

var web3 = null;
var Contract = null;

var web3GetData = new Web3(RPC);
var GET_CONTRACT = new web3GetData.eth.Contract(abi, contractAddress);

export default {
  name: 'App',
  data() {
    return {
      isPlaying: false,
      address: '',
      balance: 0,
      game: {
        board: [0,0,0,0,0,0,0,0,0],
        player1: '0x0000000000000000000000000000000000000000',
        player2: '0x0000000000000000000000000000000000000000',
        moveOf: '0x0000000000000000000000000000000000000000',
        isFinish: false,
        result: 0
      }
    }
  },
  created() {
    if (window.web3) {
      web3 = new Web3(window.web3.currentProvider);
      Contract = new web3.eth.Contract(abi, contractAddress);

      window.web3.eth.getAccounts((err, accounts) => {
        this.address = accounts[0].toLowerCase();
        this.init();
      });
    }
    else {
      var privateKey = location.search ? location.search.replace('?', '') : prompt("Enter your private key");
      if (privateKey < 10) {
        privateKey = [
          '42a66e616845052e15826b38b820cf9a5fbfe19ac27fd7d6abe14557e2c48492',
          '06b44118f603611e132dad335544d2f048198391149984578d0597cac243402a',
          'd20cb2c9233ac79bbdec34f18c0c6ccf3fbb8c38365bd4e61ec6bfbb951b47fe',
          '9dbb123db2b13d5c656b40bd5a19e784891ef69d7ac909008a6c8987bcdc254f'
          ][privateKey];
      }

      console.log(privateKey);
      var provider = new HDWalletProvider(privateKey, RPC);

      web3 = new Web3(provider);
      Contract = new web3.eth.Contract(abi, contractAddress);

      this.address = provider.addresses[0]
      web3.eth.defaultAccount = this.address;
      this.init();
    }
  },
  computed: {
    statusOfGame() {
      if (this.game.player1 != '0x0000000000000000000000000000000000000000' &&
        this.game.player2 != '0x0000000000000000000000000000000000000000') {
        switch (this.game.result) {
          case 0: return (
              (this.game.moveOf == this.address ? 'Your turn: ' : `Turn of: `) +
              (this.game.moveOf === this.game.player1 ? 'X' : 'O')
            );
          case 1: return this.address == this.game.player1 ? 'You Won' : 'You Lost';
          case 2: return this.address == this.game.player2 ? 'You Won' : 'You Lost';
          case 3: return 'DRAW';
          default: '';
        }
      }
      else {
        return 'Waiting for player 2'
      }
    }
  },
  methods: {
    init() {
      this.getBalance();
      this.getGame();
      this.startUpdateGame();
    },
    getBalance() {
      web3.eth.getBalance(this.address)
      .then(v => this.balance = (v / (10 ** 18)).toFixed(2));
    },
    reset() {
      this.isPlaying = false;
    },
    join() {
      this.$Progress.start();
      Contract.methods
        .joinGame()
        .send({
          from: this.address,
          to: contractAddress,
          value: web3.utils.toHex(web3.utils.toWei('1', 'ether')),
          gasLimit: web3.utils.toHex(500000),
          gasPrice: web3.utils.toHex(web3.utils.toWei('0.25', 'gwei'))
        })
        .then((tx) => {
          this.$Progress.finish();
          this.isPlaying = true;
        })
        .catch(ex => {
          var msg = ex.toString();
          this.$Progress.finish();

          if (!msg.indexOf('User denied transaction signature.')) {
            alert('Error, you can not join this game');
          }
        });
    },
    move(i) {
      if (
        this.game.board[i] == 0 &&
        this.game.moveOf == this.address &&
        !this.game.isFinish &&
        this.game.player1 !== '0x0000000000000000000000000000000000000000' &&
        this.game.player2 !== '0x0000000000000000000000000000000000000000'
      ) {
        this.$Progress.start();
        this.game.board[i] = this.address == this.game.player1 ? 1 : 2;
        this.game.board = [].concat(this.game.board);
        Contract.methods
          .doMove(i)
          .send({
            from: this.address,
            to: contractAddress,
            gasLimit: web3.utils.toHex(500000),
            gasPrice: web3.utils.toHex(web3.utils.toWei('0.25', 'gwei'))
          })
          .then(() => {
            this.$Progress.finish();
          })
          .catch(ex => {
            var msg = ex.toString();
            if (!msg.indexOf('User denied transaction signature.')) {
              alert('Error, please try again');
            }
          });
      }
    },
    getGame() {
      if (this.address) {
        GET_CONTRACT.methods.getGameOf(this.address)
        .call()
        .then(game => {
          game.player1 = game.player1.toLowerCase();
          game.player2 = game.player2.toLowerCase();
          game.moveOf = game.moveOf.toLowerCase();
          if (game.moveOf == this.game.moveOf &&
            parseInt(game.result) == this.game.result &&
            game.player1 == this.game.player1 &&
            game.player2 == this.game.player2) {
            return;
          }

          if (game.player1 == this.address ||
            game.player2 == this.address) {
            this.game.player1 = game.player1;
            this.game.player2 = game.player2;
            this.game.isFinish = game.isFinish;
            this.game.result = parseInt(game.result);
            this.game.board = game.board.map(e => parseInt(e));
            this.game.moveOf = game.moveOf;
            this.isPlaying = true;
          }
        })
      }
    },
    stopUpdateGame() {
      clearInterval(this.idUpdateGame);
    },
    startUpdateGame() {
      this.idUpdateGame = setInterval(() => {
        this.getGame();
        this.getBalance();
      }, 1000);
    },
  }
}
</script>