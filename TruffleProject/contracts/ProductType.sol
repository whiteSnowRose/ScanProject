pragma solidity ^0.4.2;

import "./ProductItem.sol";

contract ProductType {

    string   title;
    string  company;
    string  description;

  struct Comment{
    uint8 rank;
    string comment;
  }

  string[] private blacklist;
  mapping(uint256 => ProductItem) internal itemList;
  Comment[] private commentList;

  constructor() public {

  }

  function init(string t, string m, string d) public {

    //mInfo =  Info(t, m, d);
    title = t;
    company = m;
    description = d;

  }

  function getTitle() constant public returns (string t) {
    return title;
  }

  function getCompany() constant public returns (string c) {
    return company;
  }

  function getDescription() constant public returns (string d) {
    return description;
  }

  function addBlackList(string code) public {
    require(bytes(code).length > 0);
    bool exist = false;
    for (uint256 i = 0; i < blacklist.length; i++) {
      if(hashCompareWithLengthCheckInternal(blacklist[i], code)){
        exist = true;
        break;
      }
    }
    if(!exist){
      blacklist.push(code);
    }

  }

  function isInBlacklist(string code) private view returns (bool) {
    bool exist = false;
    for (uint256 i = 0; i < blacklist.length; i++) {
      if(hashCompareWithLengthCheckInternal(blacklist[i], code)){
        exist = true;
        break;
      }
    }
    return exist;
  }

  function creatProductItem(uint256 index, uint256 code, string longti, string lantitude, uint8 s, uint256 time) public  {
    ProductItem item = new ProductItem();
    item.init(this, index, code, longti, lantitude, s, time);
    itemList[index] = item;
  }

  function addComment(string c, uint8 r) external {
    commentList.push(Comment({rank: r, comment: c}));
  }

  function getAllCommentLength() external constant returns (uint) {

    return commentList.length;
  }

  function getCommentByIndex(uint256 index) external constant returns (string, uint8) {

    return (commentList[index].comment, commentList[index].rank);
  }

  function hashCompareWithLengthCheckInternal(string a, string b) private pure returns (bool) {
        if (bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(bytes(a)) == keccak256(bytes(b));
        }
    }

function getProductItem(uint256 index) public view returns (ProductItem)  {
  return itemList[index];
}

function scanProduct(uint256 itemIndex, uint256 code, uint256 newCode, uint8 state, string longti, string lanti, uint256 time) public returns (bool){
  return itemList[itemIndex].scanProduct(code, newCode, state, longti, lanti, time);
}

function destoryProductItem(uint256 itemIndex, address user) public returns (bool) {
  return itemList[itemIndex].destoryThis(user);
}


}
