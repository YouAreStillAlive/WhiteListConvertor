// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.7.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract Manageable is Ownable {
    event NewPrice(uint256 Id, uint256 Price);

    address public WhiteListAddress;
    mapping(uint256 => uint256) public Identifiers;

    modifier ValidateAddress(address _Addr) {
        require(_Addr != address(0), "Can't be zero address");
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

    function SetPrice(uint256 _Id, uint256 _NewPrice) public onlyOwner {
        require(_NewPrice > 0, "Price should be greater than zero");
        require(_Id > 0, "Id should be greater than zero");
        Identifiers[_Id] = _NewPrice;
        emit NewPrice(_Id, _NewPrice);
    }

    function SetPrices(uint256[] calldata _Ids, uint256[] calldata _NewPrice)
        public
        onlyOwner
    {
        require(
            _Ids.length == _NewPrice.length,
            "Both arrays should have same length"
        );
        require(
            _Ids.length > 0 && _NewPrice.length > 0,
            "Array length should be greater than 0"
        );
        for (uint256 i = 0; i < _Ids.length; i++) {
            if (_NewPrice[i] > 0) {
                Identifiers[i] = _NewPrice[i];
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
