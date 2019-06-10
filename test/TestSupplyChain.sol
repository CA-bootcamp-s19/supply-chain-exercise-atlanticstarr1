pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChain {
    uint public initialBalance = 1 ether;
    SupplyChain supply = SupplyChain(DeployedAddresses.SupplyChain());

    function beforeAll() public {
        // add  2 items
        // sku 0
        bool itemAdded = supply.addItem("book 1", 1000);
        Assert.equal(itemAdded, true, "Item not added");
        // sku 1
        itemAdded = supply.addItem("book 2", 1000);
        Assert.equal(itemAdded, true, "Item not added");
    }

    function testbuyItem() public {
        bool r;
        // test for failure if user does not send enough funds
        (r, ) = address(supply).call.value(500)(abi.encodePacked(supply.buyItem.selector, uint(0)));
        Assert.isFalse(r, "Should fail b/c not enought ether sent");

        // test for purchasing an item that is not for Sale
            // 1. buy the item
        supply.buyItem.value(5000)(0);
        (, , , uint state, , ) = supply.fetchItem(0);
        Assert.equal(state, 1, "Item not sold.");

            // 2. try to buy the item again. It should now be sold.
        (r, ) = address(supply).call.value(5000)(abi.encodePacked(supply.buyItem.selector, uint(0)));
        Assert.isFalse(r, "Item is already sold");
    }

    function testshipItem() public {
        bool r;
        // test for calls that are made by not the seller
        (r, ) = address(supply).call(abi.encodePacked(supply.shipItem.selector, uint(0)));
        Assert.isTrue(r, "seller is not caller");
        // test for trying to ship an item that is not marked Sold
        (r, ) = address(supply).call(abi.encodePacked(supply.shipItem.selector, uint(1)));
        Assert.isFalse(r, "item marked sold");
    }

    function testreceiveItem() public {
        bool r;
        // ship item 0
        //supply.shipItem(0);
        (, , , uint state, , ) = supply.fetchItem(0);
        Assert.equal(state, 2, "Item not shipped.");
        // test calling the function from an address that is not the buyer
        (r, ) = address(supply).call(abi.encodePacked(supply.receiveItem.selector, uint(0)));
        Assert.isTrue(r, "caller is not the buyer");
        // test calling the function on an item not marked Shipped
        (r, ) = address(supply).call(abi.encodePacked(supply.receiveItem.selector, uint(1)));
        Assert.isFalse(r, "item not shipped");
    }

    function() external payable {}
}
