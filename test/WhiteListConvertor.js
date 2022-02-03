const WhiteListConvertor = artifacts.require("./WhiteListConvertor.sol");
const { assert } = require('chai');

contract('WhiteListConvertor', async (accounts) => {
    let convertor;

    before(async () => {
        convertor = await WhiteListConvertor.deployed();
    });

    it('should be deployed', async () => {
        
    });
});