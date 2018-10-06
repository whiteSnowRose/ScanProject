pragma solidity ^0.4.2;

import "./ProductType.sol";

contract Commodity {
  address public owner;
  mapping(uint256 => ProductType) internal typeList;


 constructor() public {
    owner = msg.sender;
  }

 function createProductType(uint256 index, string title, string company, string description) {
   ProductType productType = new ProductType();
   productType.init(title, company, description);
   typeList[index] = productType;

 }

 function getProductInfo(uint256 index) external  view returns (string t, string c, string d) {
   return (typeList[index].getTitle(), typeList[index].getCompany(),typeList[index].getDescription());

 }

 function addProductItem(uint256 productTypeIndex, uint256 itemIndex, uint256 code, string longti, string lantitude, uint8 state, uint256 time) {
   typeList[productTypeIndex].creatProductItem(itemIndex,code,longti,lantitude, state, time);

 }

 function scanProductItem(uint256 productTypeIndex, uint256 itemIndex, uint256 code, uint256 newCode, uint8 state, string longti, string lanti, uint256 time){
   typeList[productTypeIndex].scanProduct(itemIndex, code, newCode, state, longti, lanti, time);
 }

 function destoryProductItem(uint256 productTypeIndex, uint256 itemIndex, address user) returns (bool){
   return typeList[productTypeIndex].destoryProductItem(itemIndex, user);
 }


}
