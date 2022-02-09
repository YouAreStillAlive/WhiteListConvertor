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
    });

    describe('Validation', async () => {
        it('Price validation', async () => {
            const wrongPrice = 0;

            await truffleAssert.reverts(
                instance.SetPrice(1, wrongPrice, newOperation, { from: ownerAddress }),
                "Price should be greater than zero"
            );
        });

        it('Contract validation', async () => {
            const zeroAddress = "0x0000000000000000000000000000000000000000"
            await truffleAssert.reverts(
                instance.ChangeCreator(1, zeroAddress),
                "Should be contract address"
            );
            await truffleAssert.reverts(
                instance.Register(zeroAddress, '1', '10000'),
                "Should be contract address"
            )
            await truffleAssert.reverts(
                instance.LastRoundRegister(zeroAddress, '1'),
                "Should be contract address"
            )
            await truffleAssert.reverts(
                instance.CreateManualWhiteList('10000', zeroAddress),
                "Should be contract address"
            )
            await truffleAssert.reverts(
                instance.Check(zeroAddress, '1'),
                "Should be contract address"
            )
        });
    });
});