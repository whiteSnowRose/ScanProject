var Commodity = artifacts.require("./Commodity.sol");

module.exports = function(deployer) {
  deployer.deploy(Commodity);
};
