> [!WARNING]
> The code has been made vulnerable on purpose. Please do not deploy or reuse this codebase in a live environment.

---

# Basic solidity security examples!

Here you have multiple small examples of basic security issue of solidity smart contracts to start your security journey. 


:star: `101`

- Logic bugs, different examples
- Basic reentrancy - more details [here](https://www.cyfrin.io/glossary/reentrancy-attack)
- Unencrypted secret data on-chain - more details [here](https://swcregistry.io/docs/SWC-136)
- Weak pseudo-randomness - more details [here](https://swcregistry.io/docs/SWC-120)
- Arithmetic under/overflow - more details [here](https://swcregistry.io/docs/SWC-101)
	- Uncatched due to old sol version, new version causing a DoS, casting errors...
- Access controls - more details [here](https://swcregistry.io/docs/SWC-115)
	- Both missing controls and based on `tx.origin`
- Force feeding ether - more details [here](https://swcregistry.io/docs/SWC-132)
- Gas exhaustion - more details [here](https://swcregistry.io/docs/SWC-128)
- Frontrunning
- Unchecked call return value


:star: `102`

- Push vs Pull approach (PoC can be found in test/) - more details [here](https://swcregistry.io/docs/SWC-113)
- Cross-function reentrancy (PoC can be found in test/)
- Commit and reveal scheme implementations (PoC can be found in test/)
	- Pre-computable 
	- Replayable (+ frontrun)
- Upgradability related
	- Storage collision between Proxy and Implementation

## Next steps

The current version is `v0.4`. At the moment I would like to achieve the below in order to upgrade it:

:pushpin:`V1.0`

- Multiple examples per basic issue
- Foundry tests of the 101 issues
- Deploy to testnet and add etherscan links
