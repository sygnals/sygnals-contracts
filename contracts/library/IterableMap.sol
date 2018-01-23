pragma solidity ^0.4.18;

library IterableMap {

  struct Entry {
    uint keyIndex;
    uint value;
  }

  struct AddressUInt {
    mapping(address => Entry) data;
    address[] keys;
  }

  function insert(AddressUInt storage self, address key, uint value) internal returns(bool replaced) {
    Entry storage e = self.data[key];
    e.value = value;
    if (e.keyIndex > 0) {
      return true;
    }

    e.keyIndex = ++self.keys.length;
    self.keys[e.keyIndex - 1] = key;
    return false;
  }

  function remove(AddressUInt storage self, address key) internal returns(bool success) {
    Entry storage e = self.data[key];
    if (e.keyIndex == 0)
      return false;

    if (e.keyIndex <= self.keys.length) {
      self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
      self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
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
    return self.data[key].keyIndex > 0;
  }

  function size(AddressUInt storage self) internal constant returns(uint) {
    return self.keys.length;
  }

  function get(AddressUInt storage self, address key) internal constant returns(uint) {
    return self.data[key].value;
  }

  function getKeyByIndex(AddressUInt storage self, uint idx) internal constant returns(address) {
    return self.keys[idx];
  }

  function getValueByIndex(AddressUInt storage self, uint idx) internal constant returns(uint) {
    return self.data[self.keys[idx]].value;
  }
}
