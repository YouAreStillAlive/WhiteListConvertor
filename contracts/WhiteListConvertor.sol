// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.7.0;

import "./Manageable.sol";
import "poolz-helper/contracts/IWhiteList.sol";

contract WhiteListConvertor is Manageable, IWhiteList {
    constructor(address _WhiteListAddress)
        public
        ValidateAddress(_WhiteListAddress)
    {
        WhiteListAddress = _WhiteListAddress;
    }

    function Register(
        address _Subject,
        uint256 _Id,
        uint256 _Amount
    ) external override {
        IWhiteList(WhiteListAddress).Register(_Subject, _Id, _Amount);
    }

    function IsNeedRegister(uint256 _Id) external view override returns (bool) {
        return IWhiteList(WhiteListAddress).IsNeedRegister(_Id);
    }

    function LastRoundRegister(address _Subject, uint256 _Id)
        external
        override
    {
        IWhiteList(WhiteListAddress).LastRoundRegister(_Subject, _Id);
    }

    function CreateManualWhiteList(uint256 _ChangeUntil, address _Contract)
        external
        payable
        override
        returns (uint256 Id)
    {
        return
            IWhiteList(WhiteListAddress).CreateManualWhiteList(
                _ChangeUntil,
                _Contract
            );
    }

    function ChangeCreator(uint256 _Id, address _NewCreator) external override {
        IWhiteList(WhiteListAddress).ChangeCreator(_Id, _NewCreator);
    }

    function Check(address _Subject, uint256 _Id)
        external
        view
        override
        returns (uint256)
    {
        IWhiteList(WhiteListAddress).Check(_Subject, _Id);
    }
}
