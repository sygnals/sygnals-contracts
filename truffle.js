module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: 5777
    },
    coverage: {
      host: "localhost",
      port: 8545,
      network_id: 5777,
      gas: 0xfffffffffff,
      gasPrice: 0x01
    },
  }
};
