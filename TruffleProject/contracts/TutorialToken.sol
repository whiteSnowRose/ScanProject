pragma solidity ^0.4.23;

// import 加载系统提供sol文件
import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract TutorialToken is StandardToken {
     // 此代码是构造函数.
    function TutorialToken() public {
      // totalSupply_ 在父类BasicToken
      totalSupply_ = INITIAL_SUPPLY;
      // 默认吧代币赋值给合约所有者
      balances[msg.sender] = INITIAL_SUPPLY;
    }

  string public symbol = 'TT';
  // 指定代币的名称
  string public name = 'TutorialToken';
  // 指定创建的代币数量
  uint public INITIAL_SUPPLY = 12000;

}
