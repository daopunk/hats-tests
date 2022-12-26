// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./hats/HatsAccessControl.sol";
import "./hats/IHats.sol";

contract Implementation is HatsAccessControl {
    // Access Control roles
    bytes32 public constant ADMIN = keccak256("ADMIN");
    bytes32 public constant OPERATOR = keccak256("OPERATOR");

    // Hats protocol deployments
    address public constant goerli = 0xcf912a0193593f5cD55D81FF611c26c3ED63f924;
    address public constant polygn = 0x95647F88dcbC12986046fc4f49064Edd11a25d38;
    address public constant gnosis = 0x6B49b86D21aBc1D60611bD85c843a9766B5493DB;

    // Hats Implementation
    IHats public Hats;

    // Hats
    uint256 public topId;
    uint256 public adminId;
    uint256 public operatorId;

    // other vars
    address public deployer;
    address public admin;
    address public operator;
    uint256 public testVal;

    // mock vars
    address eligibilty = address(222);
    address toggle = address(333);

    // test var
    bool public pass;

    constructor(address _admin, address _operator) {
        deployer = msg.sender;
        admin = _admin;
        operator = _operator;

        // Hats protocol implementation
        Hats = IHats(goerli);
    }

    function initTopHat() external {
        // mint top hat to this contract
        topId = Hats.mintTopHat(address(this), "TopHat", "");
    }

    function checkTopHat() external view returns (bool) {
        // confirm top hat was minted
        return Hats.isTopHat(topId);
    }

    // function setHatsContract() external {
    //     // changes Hats protocol implementation pointer
    //     _changeHatsContract(goerli);
    // }

    function createAdminHat() external {
        // create admin hat (child of top hat)
        adminId = Hats.createHat(
            topId,
            "AdminHat",
            2,
            eligibilty,
            toggle,
            false,
            ""
        );
    }

    function mintAdminHat() external {
        // mint admin hat
        Hats.mintHat(adminId, admin);
        // set access control
        _grantRole(ADMIN, adminId);
    }

    function createOperatorHat() external {
        // create operator hat (child of admin)
        operatorId = Hats.createHat(
            adminId,
            "OperatorHat",
            3,
            eligibilty,
            toggle,
            true,
            ""
        );
    }

    function mintOperatorHat() external {
        // mint operator hat
        Hats.mintHat(operatorId, operator);
        // set access control
        _grantRole(OPERATOR, operatorId);
    }

    function transferTopHat() external {
        Hats.transferHat(topId, address(this), deployer);
    }

    function testTransfer() external {
        if (checkWearerOfTopHat() && checkHierarchy()) {
            pass = true;
        }
    }

    function checkWearerOfTopHat() internal view returns (bool) {
        return Hats.isWearerOfHat(deployer, topId);
    }

    function checkHierarchy() internal view returns (bool) {
        return Hats.isAdminOfHat(admin, operatorId);
    }

    // TESTS:

    // only admin can call
    function adminTest(uint256 n) external onlyRole(ADMIN) returns (uint256) {
        testVal = n;
        return testVal;
    }

    // only operator can call (and admin?)
    function operatorTest(uint256 n)
        external
        onlyRole(OPERATOR)
        returns (uint256)
    {
        testVal = n;
        return testVal;
    }
}
