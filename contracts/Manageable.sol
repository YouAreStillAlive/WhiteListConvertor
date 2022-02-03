// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.7.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract Manageable is Ownable {
    event NewPrice(uint256 Id, uint256 Price);

    struct PriceConvert {
        uint256 Price;
        bool Operation; // false - divide || true - multiply
    }

    address public WhiteListAddress;
    mapping(uint256 => PriceConvert) public Identifiers;// Pools

    modifier ValidateAddress(address _Addr) {
        require(_Addr != address(0), "Can't be zero address");
        _;
    }

    modifier PriceValidation(uint256 _NewPrice) {
        require(_NewPrice > 0, "Price should be greater than zero");
        _;
    }

    modifier isContract(address _Addr) {
        uint32 size;
        assembly {
            size := extcodesize(_Addr)
        }
        require(size > 0, "Should be contract address");
        _;
    }

    function SetPrice(
        uint256 _Id,
        uint256 _NewPrice,
        bool _Operation
    ) external onlyOwner PriceValidation(_NewPrice) {
        require(_Id > 0, "Id should be greater than zero");
        Identifiers[_Id].Price = _NewPrice;
        Identifiers[_Id].Operation = _Operation;
        emit NewPrice(_Id, _NewPrice);
    }

    function SetPrices(
        uint256[] calldata _Ids,
        uint256[] calldata _NewPrices,
        bool[] calldata _Operations
    ) external onlyOwner {
        require(
            _Ids.length == _NewPrices.length,
            "Both arrays should have same length"
        );
        require(
            _Ids.length > 0 && _NewPrices.length > 0,
            "Array length should be greater than 0"
        );
        for (uint256 i = 0; i < _Ids.length; i++) {
            if (_NewPrices[_Ids[i]] > 0) {
                Identifiers[_Ids[i]].Price = _NewPrices[i];
                Identifiers[_Ids[i]].Operation = _Operations[i];
            }
        }
    }

    function SetWhiteListAddress(address _NewAddress)
        public
        onlyOwner
        ValidateAddress(_NewAddress)
        isContract(_NewAddress)
    {
        WhiteListAddress = _NewAddress;
    }
}