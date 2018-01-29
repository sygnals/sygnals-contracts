pragma solidity ^0.4.18;

library IterableHashSignal {

  /* Storage */

  struct Result {
    Signal signal;
    uint16 price;
    uint8 targetsReached;
    bool stopLossTriggered;
  }

  struct Signal {
    bytes32 exchange;
    bytes32 market;
    uint16 callPrice;
    uint16 stopLoss;
    uint16[] targets;
    uint startDate;
    uint endDate;
  }

  struct Entry {
    uint keyIndex;
    Result value;
  }

  struct HashResult {
    mapping(bytes32 => Entry) data;
    bytes32[] keys;
  }

  /* Internal Functions */
  function insert(HashResult storage self, bytes32 key, Result value) internal returns(bool replaced) {
    Entry storage entry = self.data[key];
    entry.value = value;
    if (entry.keyIndex > 0) {
      return true;
    }

    entry.keyIndex = ++self.keys.length;
    self.keys[entry.keyIndex - 1] = key;
    return false;
  }

  function contains(HashResult storage self, bytes32 key) internal constant returns(bool exists) {
    Entry storage entry = self.data[key];
    return entry.keyIndex > 0;
  }

  function size(HashResult storage self) internal constant returns(uint) {
    return self.keys.length;
  }

  function get(HashResult storage self, bytes32 key) internal constant returns(Result) {
    Entry storage entry = self.data[key];
    return entry.value;
  }

  function getKeyByIndex(HashResult storage self, uint idx) internal constant returns(bytes32) {
    return self.keys[idx];
  }

  function getValueByIndex(HashResult storage self, uint idx) internal constant returns(Result) {
    bytes32 key = self.keys[idx];
    Entry storage entry = self.data[key];
    return entry.value;
  }
}
