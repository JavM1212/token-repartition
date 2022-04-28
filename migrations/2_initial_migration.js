const VOLTA_BUSD = artifacts.require("VOLTA_BUSD");

module.exports = function(deployer) {
    deployer.deploy(VOLTA_BUSD);
};
