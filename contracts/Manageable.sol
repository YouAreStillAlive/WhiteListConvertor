// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.7.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract Manageable is Ownable {
    event NewPrice(uint256 Id, uint256 Price, bool Operation);

    struct PriceConvert {
        uint256 Price;
        bool Operation; // false - devide || true - multiply
    }

    address public WhiteListAddress;
    mapping(uint256 => PriceConvert) public Identifiers; // Pools

    modifier contractValidation() {
        require(isContract(WhiteListAddress), "Should be contract address");
        _;
    }

    function isContract(address _Addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_Addr)
        }
        return size > 0;
    }

    function SetPrice(
        uint256 _Id,
        uint256 _NewPrice,
        bool _Operation
    ) external onlyOwner {
        require(_NewPrice > 0, "Price should be greater than zero");
        Identifiers[_Id].Price = _NewPrice;
        Identifiers[_Id].Operation = _Operation;
        emit NewPrice(_Id, _NewPrice, _Operation);
    }

    function SetWhiteListAddress(address _NewAddress) public onlyOwner {
        WhiteListAddress = _NewAddress;
    }
}
