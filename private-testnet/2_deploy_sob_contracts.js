var TestToken = artifacts.require('TestToken');
var TokenReg = artifacts.require("TokenReg");
var MultiSigFactory = artifacts.require("MultiSigFactory");
var MultiSigTokenWallet = artifacts.require("MultiSigTokenWallet");

module.exports = function(deployer) {
	deployer.deploy(TestToken, 'Test Token Token', 'TTT', 18
	).then(() => {
		return TestToken.deployed().then(function(instance) {
			 return instance.issueTokens(web3.eth.accounts[0], 1000000 * 10**18);
		 });
	 });

	deployer.deploy(TokenReg);

	deployer.deploy(MultiSigFactory);
	deployer.deploy(MultiSigTokenWallet);
};
