import { useState } from "react";
import Web3 from "web3";

import "./App.css";
import TokenMetadataList from './components/TokenMetadataList';
import { volcanoTokenAbi } from "./abis/volcanoTokenAbi";

const web3 = new Web3(Web3.givenProvider || 'http://localhost:8545');

// contractAddr and contractOwnerAddr provided by `truffle migrate`
const contractAddr = '0xb6ea8951142a9684Db551a8624f8Ca2f98d7Ff90';
const tokenContract = new web3.eth.Contract(
  volcanoTokenAbi,
  contractAddr
);

function App() {
  const [tokenUri, setTokenUri] = useState();
  const [getOwnedTokens, setTokensOwned] = useState();
  const [transferTokenState, setTransferTokenState] = useState({
    newTokenOwner: '0x00',
    tokenId: 0
  });

  const handleMintToken = async (event) => {
    event.preventDefault();
    const accounts = await window.ethereum.request({
      method: "eth_accounts",
    });
    const account = accounts[0];
    try {
      await tokenContract.methods.mintToken(account, tokenUri).send({
        from: account,
      });
      console.log(tokenUri);
    } catch (err) {
      console.log(err);
    }
  };

  const handleTokensOwned = async(event) => {
    event.preventDefault();
    const result = await tokenContract.methods.getOwnedTokens().call();
    if (result === null || result.length === 0) {
        setTokensOwned("No owned tokens");
    } else {
        setTokensOwned(<TokenMetadataList tokensMetadata={result} />);
    }
  };

  function handleSetTransferToken(event) {
    setTransferTokenState({
      ...transferTokenState,
      [event.target.name]: event.target.value,
    });
  }


  const transferToken = async(event) => {
    event.preventDefault();
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    const ownerAccount = accounts[0];
    try {
      const gas = await tokenContract.methods
        .safeTransferFrom(
          ownerAccount,
          transferTokenState.newTokenOwner,
          transferTokenState.tokenId
        )
        .estimateGas();
      await tokenContract.methods
        .safeTransferFrom(
            ownerAccount,
            transferTokenState.newTokenOwner,
            transferTokenState.tokenId
          )
        .send({
          from: ownerAccount,
          gas,
        });
    } catch(err) {
        console.log(err);
    }
  }

  return (
    <div className="App">
      <h1>Mint NFT Tokens</h1>
      <header className="App-header">
        <div>
          <form onSubmit={handleMintToken}>
            <label>
              Mint Token
              <br />
              <input
                type="text"
                name="tokenUri"
                placeholder="Insert Token URI"
                onChange={(e) => setTokenUri(e.target.value)}
              />
            </label>
            <input type="submit" value="Mint!" />
          </form>
        </div>
        <br />
        <div>
          <form onSubmit={transferToken}>
            <label>
              Transfer token
              <br />
              <input
                type="text"
                placeholder="New Owner Address"
                name="newTokenOwner"
                onChange={handleSetTransferToken}
              />
            </label>
            <br />
            <label>
              <input
                type="number"
                placeholder="Token ID"
                name="tokenId"
                onChange={handleSetTransferToken}
              />
            </label>
            <br />
            <input type="submit" value="Transfer" />
          </form>
        </div>
        <br />
        <div>
          <label>
            Get my NFT metadata
            <br/>
            <button onClick={handleTokensOwned} type="button">
                Get
            </button>
            {getOwnedTokens}
          </label>
        </div>
      </header>
    </div>
  );
}

export default App;