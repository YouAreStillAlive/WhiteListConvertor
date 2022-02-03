const WhiteListConvertor = artifacts.require("WhiteListConvertor");
const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract('Managable', accounts => {
    let instance, ownerAddress;
    const newOperation = false;
    const newPrice = 50;

    before(async () => {
        instance = await WhiteListConvertor.deployed();
        const owner = await instance.owner();
        ownerAddress = owner.toString();
    })

    describe('Setting new price', async () => {
        const id = 1;

        it('should set new price', async () => {
            await instance.SetPrice(id, newPrice, newOperation, { from: ownerAddress });
            const newCheckPrice = await instance.Identifiers(id);

            assert.equal(newCheckPrice[0].toNumber(), newPrice);
            assert.equal(newCheckPrice[1], newOperation);
        });

        it('NewPrice event is emitted', async () => {
            result = await instance.SetPrice(id, newPrice, newOperation, { from: ownerAddress });
            // Check event
            truffleAssert.eventEmitted(result, 'NewPrice', (ev) => {
                return ev.Id == id && ev.Price == newPrice;
            });
        });

        it('Require works', async () => {
            await truffleAssert.reverts(
                instance.SetPrice(0, newPrice, newOperation, { from: ownerAddress }),
                "Id should be greater than zero"
            );
        });
    });

    describe('Validation', async () => {
        it('Validate address', async () => {
            await truffleAssert.reverts(
                instance.SetWhiteListAddress("0x0000000000000000000000000000000000000000"),
                "Can't be zero address"
            );
        });

        it('Price validation', async () => {
            const wrongPrice = 0;

            await truffleAssert.reverts(
                instance.SetPrice(1, wrongPrice, newOperation, { from: ownerAddress }),
                "Price should be greater than zero"
            );
        });
    });
});