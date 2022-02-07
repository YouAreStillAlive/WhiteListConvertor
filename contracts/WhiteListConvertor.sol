// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.7.0;

import "./Manageable.sol";
import "poolz-helper/contracts/IWhiteList.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract WhiteListConvertor is Manageable, IWhiteList {
    using SafeMath for uint256;

    constructor(address _WhiteListAddress) public {
        WhiteListAddress = _WhiteListAddress;
    }

    function Register(
        address _Subject,
        uint256 _Id,
        uint256 _Amount
    ) external override contractValidation {
        IWhiteList(WhiteListAddress).Register(
            _Subject,
            _Id,
            Convert(_Amount, _Id, !Identifiers[_Id].Operation)
        );
    }

    function IsNeedRegister(uint256 _Id)
        external
        view
        override
        contractValidation
        returns (bool)
    {
        return IWhiteList(WhiteListAddress).IsNeedRegister(_Id);
    }

    function LastRoundRegister(address _Subject, uint256 _Id)
        external
        override
        contractValidation
    {
        IWhiteList(WhiteListAddress).LastRoundRegister(_Subject, _Id);
    }

    function CreateManualWhiteList(uint256 _ChangeUntil, address _Contract)
        external
        payable
        override
        contractValidation
        returns (uint256 Id)
    {
        uint256 id = IWhiteList(WhiteListAddress).CreateManualWhiteList(
            _ChangeUntil,
            address(this)
        );
        // IWhiteList(WhiteListAddress).ChangeCreator(id, msg.sender);
        return id;
    }

    function ChangeCreator(uint256 _Id, address _NewCreator)
        external
        override
        contractValidation
    {
        IWhiteList(WhiteListAddress).ChangeCreator(_Id, _NewCreator);
    }

    function Check(address _Subject, uint256 _Id)
        external
        view
        override
        contractValidation
        returns (uint256)
    {
        uint256 convertAmount = IWhiteList(WhiteListAddress).Check(
            _Subject,
            _Id
        );
        return Convert(convertAmount, _Id, Identifiers[_Id].Operation);
    }

    function Convert(
        uint256 _AmountToConvert,
        uint256 _Id,
        bool _Operation
    ) internal view returns (uint256) {
        uint256 amount = _AmountToConvert;
        bool operation = _Operation;
        uint256 price = Identifiers[_Id].Price;
        return operation ? amount.mul(price) : amount.div(price);
    }
}