pragma solidity ^0.4.18;

library IterableAddressMap {

  struct Entry {
    uint keyIndex;
    uint value;
  }

  struct AddressUInt {
    mapping(address => Entry) data;
    address[] keys;
  }

  function insert(AddressUInt storage self, address key, uint value) internal returns(bool replaced) {
    Entry storage entry = self.data[key];
    entry.value = value;
    if (entry.keyIndex > 0) {
      return true;
    }

    entry.keyIndex = ++self.keys.length;
    self.keys[entry.keyIndex - 1] = key;
    return false;
  }

  function remove(AddressUInt storage self, address key) internal returns(bool success) {
    Entry storage entry = self.data[key];
    if (entry.keyIndex == 0)
      return false;

    if (entry.keyIndex <= self.keys.length) {
      self.data[self.keys[self.keys.length - 1]].keyIndex = entry.keyIndex;
      self.keys[entry.keyIndex - 1] = self.keys[self.keys.length - 1];
      self.keys.length -= 1;
      delete self.data[key];
      return true;
    }
  }

  function destroy(AddressUInt storage self) internal {
    for (uint i; i < self.keys.length; i++) {
      delete self.data[self.keys[i]];
    }
    delete self.keys;
    return;
  }

  function contains(AddressUInt storage self, address key) internal constant returns(bool exists) {
    Entry storage entry = self.data[key];
    return entry.keyIndex > 0;
  }

  function size(AddressUInt storage self) internal constant returns(uint) {
    return self.keys.length;
  }

  function get(AddressUInt storage self, address key) internal constant returns(uint) {
    Entry storage entry = self.data[key];
    return entry.value;
  }

  function getKeyByIndex(AddressUInt storage self, uint idx) internal constant returns(address) {
    return self.keys[idx];
  }

  function getValueByIndex(AddressUInt storage self, uint idx) internal constant returns(uint) {
    address key = self.keys[idx];
    Entry storage entry = self.data[key];
    return entry.value;
  }
}
