pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChain {
    uint public initialBalance = 10 ether;
    // Test for failing conditions in this contracts:
    // https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
    SupplyChain supply;

    function beforeEach() public {
        supply = SupplyChain(DeployedAddresses.SupplyChain());
         // add item
        bool itemAdded = supply.addItem("book", 1000);
        Assert.equal(itemAdded, true, "Item not added");
    }
    // buyItem

    function testbuyItem() public {
        // test for failure if user does not send enough funds
        // supply.buyItem.value(2000)(0);
        // (string memory name, uint sku, uint price, uint state, address seller, address buyer) = supply.fetchItem(0);
        // Assert.equal(state, 1, "Item not sold.");

        // test for purchasing an item that is not for Sale
    }

    // shipItem
    function testshipItem() public {
        // test for calls that are made by not the seller
        // test for trying to ship an item that is not marked Sold
    }


    // receiveItem
    function testreceiveItem() public {
    // test calling the function from an address that is not the buyer
    // test calling the function on an item not marked Shipped
    }
}
