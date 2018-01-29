pragma solidity ^0.4.18;

import "./IterableHashSignal.sol";

/**
 * @title SignalRegistry - Allows analysts to store immutable signals to blockchain
 * @author Norf Lipsum - <norf@sygplatform.io>
 */
contract SignalRegistry {

  using IterableHashSignal for IterableHashSignal.HashResult;
  using IterableHashSignal for IterableHashSignal.Signal;
  using IterableHashSignal for IterableHashSignal.Result;

  /* Events */
  event LogSignal(
    bytes32 indexed hash,
    address analyst,
    bytes32 exchange,
    bytes32 market,
    uint16 callPrice,
    uint16 stopLoss,
    uint16[] targets,
    uint startDate,
    uint endDate,
    uint16 price,
    uint8 targetsReached,
    bool stopLossTriggered
  );

  /* Storage */
  mapping(address => IterableHashSignal.HashResult) private signalsMap;

  /* Public Functions */

  function publish(
    bytes32 exchange,
    bytes32 market,
    uint16 callPrice,
    uint16 stopLoss,
    uint16[] targets,
    uint startDate,
    uint endDate,
    uint16 price,
    uint8 targetsReached,
    bool stopLossTriggered
  ) public returns (bytes32 hash) {
    IterableHashSignal.Signal memory signal = IterableHashSignal.Signal(exchange, market, callPrice, stopLoss, targets, startDate, endDate);
    IterableHashSignal.Result memory result = IterableHashSignal.Result(signal, price, targetsReached, stopLossTriggered);

    hash = keccak256(msg.sender, exchange, market, signalsMap[msg.sender].size());
    signalsMap[msg.sender].insert(hash, result);

    LogSignal(hash, msg.sender, exchange, market, callPrice, stopLoss, targets, startDate, endDate, price, targetsReached, stopLossTriggered);
  }

  function countSignals() public view returns(uint count) {
    count = signalsMap[msg.sender].size();
  }

  function getHashByIndex(uint idx) public view returns(bytes32 hash) {
    address analyst = msg.sender;
    IterableHashSignal.HashResult storage signals = signalsMap[analyst];

    //Require target index is bounded
    require(idx < signals.size());

    hash = signals.getKeyByIndex(idx);
  }

  function getResultByIndex(uint idx) public view returns(
    address analyst,
    bytes32 exchange,
    bytes32 market,
    uint16 callPrice,
    uint16 stopLoss,
    uint16[] targets,
    uint startDate,
    uint endDate,
    uint16 price,
    uint8 targetsReached,
    bool stopLossTriggered
  ) {
    IterableHashSignal.HashResult storage signals = signalsMap[msg.sender];

    //Require target index is bounded
    require(idx < signals.size());
    IterableHashSignal.Result memory result = signals.getValueByIndex(idx);

    return (
      msg.sender,
      result.signal.exchange,
      result.signal.market,
      result.signal.callPrice,
      result.signal.stopLoss,
      result.signal.targets,
      result.signal.startDate,
      result.signal.endDate,
      result.price,
      result.targetsReached,
      result.stopLossTriggered
    );
  }

  function getResultByHash(bytes32 hash) public view returns(
    address analyst,
    bytes32 exchange,
    bytes32 market,
    uint16 callPrice,
    uint16 stopLoss,
    uint16[] targets,
    uint startDate,
    uint endDate,
    uint16 price,
    uint8 targetsReached,
    bool stopLossTriggered
  ) {
    IterableHashSignal.HashResult storage signals = signalsMap[msg.sender];

    //Require hash index found
    require(signals.contains(hash));

    IterableHashSignal.Result memory result = signals.get(hash);

    return (
      msg.sender,
      result.signal.exchange,
      result.signal.market,
      result.signal.callPrice,
      result.signal.stopLoss,
      result.signal.targets,
      result.signal.startDate,
      result.signal.endDate,
      result.price,
      result.targetsReached,
      result.stopLossTriggered
    );
  }
}
