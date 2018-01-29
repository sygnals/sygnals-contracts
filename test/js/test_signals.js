const utils = require('./utils')
var Web3 = require('web3');
var web3 = new Web3('ws://localhost:8545');

const SignalRegistry = artifacts.require('SignalRegistry');

contract('SignalRegistry', function(accounts) {
  let signalRegistry;
  let analyst = accounts[1];

  beforeEach(async () => {
    signalRegistry = await SignalRegistry.new();
  })

  /** publish() **/
  it("should publish", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    transaction = await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });

    var log = utils.getEventLogs(transaction, 'LogSignal')[0];
    assert.equal(log.args.analyst, analyst, analyst + " should be the analyst");
    var exchangeBytes = web3.eth.abi.encodeParameter('bytes32', web3.utils.utf8ToHex('BITTREX'));
    assert.equal(log.args.exchange, exchangeBytes, 'exchange should be equal');
    var marketBytes = web3.eth.abi.encodeParameter('bytes32', web3.utils.utf8ToHex('ADA/BTC'));
    assert.equal(log.args.market, marketBytes, 'market should be equal');
    assert.equal(log.args.callPrice, 5322, 'callPrice should be equal');
    assert.equal(log.args.stopLoss, 5200, 'stopLoss should be equal');
    assert.equal(log.args.targets[0], 5400, 'target 1 should be equal');
    assert.equal(log.args.targets[1], 5500, 'target 2 should be equal');
    assert.equal(log.args.targets[2], 5600, 'target 3 should be equal');
    assert.equal(log.args.startDate, startDate, 'startDate should be equal');
    assert.equal(log.args.endDate, endDate, 'endDate should be equal');
    assert.equal(log.args.price, 5800, 'price should be equal');
    assert.equal(log.args.targetsReached, 3, 'targetsReached should be equal');
    assert.equal(log.args.stopLossTriggered, false, 'stopLossTriggered should be equal');
  });

  /** countSignals() **/
  it("should count signals", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });

    count = await signalRegistry.countSignals({
      from: analyst
    });
    assert.equal(count, 1, "signal count should be 1");
  });

  it("should count signals: no analyst data", async () => {
    count = await signalRegistry.countSignals({
      from: analyst
    });
    assert.equal(count, 0, "signal count should be 0");
  });

  /** getHashByIndex() **/
  it("should get signal's hash by index", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    transaction = await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });

    hash = await signalRegistry.getHashByIndex(0, {
      from: analyst
    });
    var log = utils.getEventLogs(transaction, 'LogSignal')[0];
    assert.equal(log.args.hash, hash, hash + " should be the hash");
  });

  it("should not get signal's hash by index: no analyst data", async () => {
    try {
      await signalRegistry.getHashByIndex(0, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not get signal's hash by index: unknown index", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });
    try {
      await signalRegistry.getHashByIndex(1, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not get signal's hash by index: negative index ", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });
    try {
      await signalRegistry.getHashByIndex(-1, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  /** getResultByIndex() **/
  it("should get result by index", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    transaction = await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });

    var [
      sender, exchange, market, callPrice, stopLoss, targets,
      startDate, endDate, price, targetsReached, stopLossTriggered
    ] = await signalRegistry.getResultByIndex(0, {
      from: analyst
    });

    var log = utils.getEventLogs(transaction, 'LogSignal')[0];
    assert.equal(log.args.analyst, sender, sender + " should be the analyst");
    assert.equal(log.args.exchange, exchange, 'exchange should be equal');
    assert.equal(log.args.market, market, 'market should be equal');
    assert.equal(log.args.callPrice.toString(), callPrice.toString(), 'callPrice should be equal');
    assert.equal(log.args.stopLoss.toString(), stopLoss.toString(), 'stopLoss should be equal');
    assert.equal(log.args.targets[0].toString(), targets[0].toString(), 'target 1 should be equal');
    assert.equal(log.args.targets[1].toString(), targets[1].toString(), 'target 2 should be equal');
    assert.equal(log.args.targets[2].toString(), targets[2].toString(), 'target 3 should be equal');
    assert.equal(log.args.startDate.toString(), startDate.toString(), 'startDate should be equal');
    assert.equal(log.args.endDate.toString(), endDate.toString(), 'endDate should be equal');
    assert.equal(log.args.price.toString(), price.toString(), 'price should be equal');
    assert.equal(log.args.targetsReached.toString(), targetsReached.toString(), 'targetsReached should be equal');
    assert.equal(log.args.stopLossTriggered.toString(), stopLossTriggered.toString(), 'stopLossTriggered should be equal');
  });

  it("should not get result by index: no analyst data", async () => {
    try {
      await signalRegistry.getResultByIndex(0, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not get result by index: unknown index", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });
    try {
      await signalRegistry.getResultByIndex(1, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not get result by index: negative index ", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });
    try {
      await signalRegistry.getResultByIndex(-1, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  /** getResultByHash() **/
  it("should get result by hash", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    transaction = await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });

    var exchangeBytes = web3.eth.abi.encodeParameter('bytes32', web3.utils.utf8ToHex('BITTREX'))
    var marketBytes = web3.eth.abi.encodeParameter('bytes32', web3.utils.utf8ToHex('ADA/BTC'))
    var sizeBytes = web3.utils.toBN(0);

    var hash = web3.utils.soliditySha3(analyst, exchangeBytes, marketBytes, sizeBytes);

    var [
      sender, exchange, market, callPrice, stopLoss, targets,
      startDate, endDate, price, targetsReached, stopLossTriggered
    ] = await signalRegistry.getResultByHash(hash, {
      from: analyst
    });

    var log = utils.getEventLogs(transaction, 'LogSignal')[0];
    assert.equal(log.args.hash, hash, hash + " should be the hash");
    assert.equal(log.args.analyst, sender, sender + " should be the analyst");
    assert.equal(log.args.exchange, exchange, 'exchange should be equal');
    assert.equal(log.args.market, market, 'market should be equal');
    assert.equal(log.args.callPrice.toString(), callPrice.toString(), 'callPrice should be equal');
    assert.equal(log.args.stopLoss.toString(), stopLoss.toString(), 'stopLoss should be equal');
    assert.equal(log.args.targets[0].toString(), targets[0].toString(), 'target 1 should be equal');
    assert.equal(log.args.targets[1].toString(), targets[1].toString(), 'target 2 should be equal');
    assert.equal(log.args.targets[2].toString(), targets[2].toString(), 'target 3 should be equal');
    assert.equal(log.args.startDate.toString(), startDate.toString(), 'startDate should be equal');
    assert.equal(log.args.endDate.toString(), endDate.toString(), 'endDate should be equal');
    assert.equal(log.args.price.toString(), price.toString(), 'price should be equal');
    assert.equal(log.args.targetsReached.toString(), targetsReached.toString(), 'targetsReached should be equal');
    assert.equal(log.args.stopLossTriggered.toString(), stopLossTriggered.toString(), 'stopLossTriggered should be equal');
  });

  it("should not get result by hash: no analyst data", async () => {
    try {
      var hash = web3.utils.soliditySha3(analyst);
      await signalRegistry.getResultByHash(hash, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not get result by hash: unknown hash", async () => {
    var startDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    var endDate = Math.floor(new Date('January 29, 2018 05:00:00') / 1000);
    transaction = await signalRegistry.publish(
      'BITTREX', 'ADA/BTC', 5322, 5200, [5400, 5500, 5600], startDate, endDate, 5800, 3, false, {
        from: analyst
      });

    var exchangeBytes = web3.eth.abi.encodeParameter('bytes32', web3.utils.utf8ToHex('UNKNOWN'))
    var marketBytes = web3.eth.abi.encodeParameter('bytes32', web3.utils.utf8ToHex('ADA/BTC'))
    var sizeBytes = web3.utils.toBN(0);

    var hash = web3.utils.soliditySha3(analyst, exchangeBytes, marketBytes, sizeBytes);

    try {
      transaction = await signalRegistry.getResultByHash(hash, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });


});
