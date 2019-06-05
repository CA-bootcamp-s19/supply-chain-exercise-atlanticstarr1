pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChain {
    uint public initialBalance = 10 ether;
    SupplyChain supply = SupplyChain(DeployedAddresses.SupplyChain());

    // Test for failing conditions in this contracts:
    // https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests

    // buyItem

    function testbuyItem() public {

        // add item
        bool itemAdded = supply.addItem("book", 1000);
        Assert.equal(itemAdded,true,"Item not added");

        (string memory name, uint sku, uint price, uint state, address seller, address buyer) = supply.fetchItem(0);

        Assert.equal(price,1000 wei,"not equal");
        Assert.equal(sku,0,"sku don't match");
        //supply.buyItem.gas(3000000).value(100)(0);
        bytes4 methodId = supply.buyItem.selector;
        bool r;
        // test for failure if user does not send enough funds
        (r, ) = address(supply).transfer.value(2000)(abi.encodeWithSelector(methodId,0));
        //supply.buyItem.gas(3000000).value(10000 wei)(uint(0));
        //Assert.isFalse(r, "Not enough funds sent.");

        // test for purchasing an item that is not for Sale
        // first: purchase the item
        //address(supply).call.gas(3000000).value(0.1 ether)(abi.encodeWithSelector(methodId,0));
        //(name, sku, price, state, seller, buyer) = supply.fetchItem(0);
        // check item is purchased
        //Assert.isTrue(state == 1, "Item not purchased");

    }

    // shipItem

    // test for calls that are made by not the seller
    // test for trying to ship an item that is not marked Sold

    // receiveItem

    // test calling the function from an address that is not the buyer
    // test calling the function on an item not marked Shipped

}
