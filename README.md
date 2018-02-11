Syg Smart Contracts
======================

Collection of smart contracts for Syg signalling platform.

| Branch | Status |
| ------------- | -------------
| master | [![Codeship](https://img.shields.io/codeship/b1ae13e0-e322-0135-57dc-5e586c006d0a/master.svg?style=flat-square)](https://app.codeship.com/projects/268383) [![Codecov](https://img.shields.io/codecov/c/github/sygplatform/syg-contracts/master.svg?style=flat-square)](https://codecov.io/gh/sygplatform/syg-contracts)
| dev | [![Codeship](https://img.shields.io/codeship/b1ae13e0-e322-0135-57dc-5e586c006d0a/dev.svg?style=flat-square)](https://app.codeship.com/projects/268383)  [![Codecov](https://img.shields.io/codecov/c/github/sygplatform/syg-contracts/dev.svg?style=flat-square)](https://codecov.io/gh/sygplatform/syg-contracts)

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

```
npm run test
```

## Coverage

```
npm run converage
```

## License

All smart contracts are released under GPL v.3.
