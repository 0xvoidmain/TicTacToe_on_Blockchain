export default [
	{
		"constant": false,
		"inputs": [
			{
				"name": "player",
				"type": "address"
			}
		],
		"name": "addNewGame",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "place",
				"type": "uint256"
			}
		],
		"name": "doMove",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "joinGame",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "gameIndex",
				"type": "uint256"
			}
		],
		"name": "checkWinner",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "games",
		"outputs": [
			{
				"name": "player1",
				"type": "address"
			},
			{
				"name": "player2",
				"type": "address"
			},
			{
				"name": "isFinish",
				"type": "bool"
			},
			{
				"name": "moveOf",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "player",
				"type": "address"
			}
		],
		"name": "getGameOf",
		"outputs": [
			{
				"name": "player1",
				"type": "address"
			},
			{
				"name": "player2",
				"type": "address"
			},
			{
				"name": "board",
				"type": "uint256[]"
			},
			{
				"name": "isFinish",
				"type": "bool"
			},
			{
				"name": "moveOf",
				"type": "address"
			},
			{
				"name": "result",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getNumberOfGame",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "players",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]