var Web3 = require("web3");

var contract = require("truffle-contract");
var data = require("../build/contracts/Commodity.json");

var Commodity = contract(data);

var provider = new Web3.providers.HttpProvider("http://localhost:8545");
Commodity.setProvider(provider);

// console.info(WeiboRegistry.web3.eth.accounts)
var deployed;
WeiboRegistry.deployed().then(function (instance) {
    var deployed = instance;
    return instance.createProductType(100, "title", "company", "description");
});
