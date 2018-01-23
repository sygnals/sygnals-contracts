Syg Smart Contracts
======================

Collection of smart contracts for Syg signalling platform.

## Requirements

- [Truffle v4.0.5](https://github.com/trufflesuite/truffle) (Solidity v0.4.18)
- [Node v8.4.x](https://nodejs.org/en/blog/release/v8.9.4/) (LTS: Carbon)

## Installation

```
npm install -g truffle
npm install
```

or with [Node Version Manager](https://github.com/creationix/nvm) via `.nvrmc`

```
nvm use
npm install -g truffle
npm install
```

## Compile
```
truffle compile
```

## Deploy/Migrate

```
truffle migrate
```
or
```
truffle migrate --reset
```

## Tests

Test mnemonic (Test files contain hard-coded addresses to test):
```
candy maple cake sugar pudding cream honey rich smooth crumble sweet treat
```

#### Start your Ethereum Client:
Tested using [Ganache App](https://github.com/trufflesuite/ganache) and with [Ganache CLI](https://github.com/trufflesuite/ganache-cli)

via Ganache CLI:
```
ganache-cli --mnemonic "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"
```

#### Run Tests
In a separate terminal:
```
truffle test
```
## License

All smart contracts are released under GPL v.3.
