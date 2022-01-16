import TokenMetadata from './TokenMetadata';
import classes from './TokenMetadataList.module.css';

function TokenMetadataList(props) {
    console.log(props.tokensMetadata);
    return (
      <ul className={classes.list}>
        {props.tokensMetadata.map((tokenMetadata) => (
          <TokenMetadata
            key={tokenMetadata.tokenID}
            tokenId={tokenMetadata.tokenID}
            tokenTimestamp={tokenMetadata.timestamp}
            tokenUri={tokenMetadata.tokenURI}
          />
        ))}
      </ul>
    );
}

export default TokenMetadataList;