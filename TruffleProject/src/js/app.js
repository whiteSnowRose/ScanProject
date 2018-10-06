// APP就是一个json对象,里面定义了调用逻辑的所有函数
App = {
  // 定义两个变量
  web3Provider: null,
  contracts: {},
  // 105已经定义当前函数在window加载成功之后会被调用
  init: function() {
    return App.initWeb3();
  },
  // 此函数用来关联私有链,此函数在页面调用会执行
  initWeb3: function() {
    // 初始化web3对象,并且设置私有链
    if (typeof web3 !== 'undefined') {
      // 如果已经设置了Provider，则返回当前的Provider
      App.web3Provider = web3.currentProvider;
      // 根据当前私有链,构建web3对象
      web3 = new Web3(web3.currentProvider);
      console.info("if");
      console.info(web3.currentProvider);
    } else {
      // 指定当前要连接的私有链.并且创建web3对象
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:9545');
      web3 = new Web3(App.web3Provider);
      console.info("else");
      console.info(web3.currentProvider);
    }
    return App.initContract();
  },
  // 此函数用来初始化智能合约
  initContract: function() {
    // 需要创建一个智能合约而且名称必须为 TutorialToken.sol
    $.getJSON('TutorialToken.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var TutorialTokenArtifact = data;
      // contracts在顶部已经定义,用来存储智能合约json文件
      App.contracts.TutorialToken = TruffleContract(TutorialTokenArtifact);
      // 设置当前智能合约所关联的私有链
      App.contracts.TutorialToken.setProvider(App.web3Provider);

      // 显示账户的余额
      return App.getBalances();
    });

    return App.bindEvents();
  },
  // 注册和绑定事件
  bindEvents: function() {
    //  对index.html页面的button按钮注册单击事件
    $(document).on('click', '#transferButton', App.handleTransfer);
  },
  // 此函数用来实现转账功能
  handleTransfer: function(event) {
    event.preventDefault();
    // 获取目前地址的,和要转账的金额
    var amount = parseInt($('#TTTransferAmount').val());
    var toAddress = $('#TTTransferAddress').val();

    console.log('Transfer ' + amount + ' TT to ' + toAddress);

    // 此变量会用来存储智能合约的实例
    var tutorialTokenInstance;
    // web3.eth.getAccounts 同步方式,此处是异步方式
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      // 默认获取第一个账户也就是缺省账户
      var account = accounts[0];
      // 通过指定的合约名称,来创建对象合约对象.
      App.contracts.TutorialToken.deployed().then(function(instance) {
        // 存储了真正的合约对象.
        tutorialTokenInstance = instance;
        // 合约对象调用transfer,此方法在父类 StandardToken中已经定义
        return tutorialTokenInstance.transfer(toAddress, amount, {from: account});
      }).then(function(result) {
        alert('Transfer Successful!');
        // 转账成功,则会调用此方法显示当前账户(account[0])的余额
        return App.getBalances();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },
  // 转账成功,则会调用此方法显示当前账户(account[0])的余额
  getBalances: function() {
    console.log('Getting balances...');
    // 此变量会用来存储智能合约的实例
    var tutorialTokenInstance;
    // 通过异步的方式获取私有链提供的账户信息
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
       // 实例化合约,并且交给 tutorialTokenInstance变量
      App.contracts.TutorialToken.deployed().then(function(instance) {
        tutorialTokenInstance = instance;
         // balanceOf，此方法在父类 StandardToken中已经定义
        return tutorialTokenInstance.balanceOf(account);
      }).then(function(result) {
        console.info(result);
        balance = result.c[0];
         // 用例显示当前账户的余额
        $('#TTBalance').text(balance);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  // 当前window对象加载成功,此init()会被执行,
  $(window).load(function() {
    App.init();
  });
});
