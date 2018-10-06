pragma solidity ^0.4.2;

import "./ProductType.sol";
contract ProductItem {
  ProductType mParent;
  uint256 mCurrentDynamicCode;
  uint256 uniqueIndex;
  string mCurrentLongtitude;
  string mCurrentLantitue;
  uint8 mCurrentState;
  address owner;
  uint16 mIndex;

  struct ItemStateInfo {
    string longtitude;
    string lantitue;
    uint8  state;
    uint256 timestamp;
    /*
    0:create
    1:online to sell
    2:offline to sell
    3：scan by user
    4:presell
    5.delivering...
    6.used
    7.resell
    8.destory
    */

  }

  ItemStateInfo[] stateList;

  function setDynamicCode(uint256 newCode) {
    mCurrentDynamicCode = newCode;
  }

  function setLocation(string newLong, string newLant) {
    mCurrentLongtitude = newLong;
    mCurrentLantitue =newLant;
  }

  function setState(uint8 newState) {
    mCurrentState = newState;

  }

  constructor() public {

  }

  function init(ProductType p, uint256 index, uint256 code, string longti, string lantitude, uint8 s, uint256 time) public {
    mParent = p;
    mCurrentDynamicCode = code;
    uniqueIndex = index;
    mCurrentLongtitude = longti;
    mCurrentLantitue = lantitude;
    mCurrentState = s;
    ItemStateInfo memory stateInfo = ItemStateInfo({longtitude:longti, lantitue:lantitude, state:s, timestamp: time});
    mIndex = 0;
    stateList[mIndex] = stateInfo;


  }

  function isCounterFei(uint256 aCode) private returns (bool) {
    if(mCurrentDynamicCode == aCode){
      return true;
    }
    else{
      return false;
    }
  }

  function getState() public returns (uint8){
    return mCurrentState;
  }

  function scanProduct(uint256 code, uint256 newCode, uint8 s, string lon, string lant,uint256 time) returns (bool){
    if(isCounterFei(code)){
      return false;
    }
    else{
      mCurrentDynamicCode = newCode;
      mCurrentLongtitude = lon;
      mCurrentLantitue = lant;
      mCurrentState = s;
      ItemStateInfo memory stateInfo =  ItemStateInfo({longtitude:lon, lantitue:lant, state:s, timestamp: time});
      mIndex = mIndex +1;
      stateList[mIndex] = stateInfo;
      return true;
    }
  }

  function getStateLen() public constant returns (uint256) {
    return stateList.length;
  }

  function getSateInfo(uint8 index) returns (string, string, uint8) {
    return (stateList[index].longtitude, stateList[index].lantitue, stateList[index].state);
  }

  function buyThis(address buyer) {
    owner = buyer;

  }

  function destoryThis(address user) returns (bool) {
    if(owner == user){
      selfdestruct(owner);
      return true;
    }
    else{
      return false;
    }
  }


}
