import classes from './TokenMetadata.module.css';
import Card from './Card';

function TokenMetadataItem(props) {
    function getIpfsUrl(uri) {
        return `https://ipfs.infura.io/ipfs/${uri}`;
    }

    return (
      <li className={classes.item}>
        <Card>
          <div className={classes.content}>
            <h3>TokenID: {props.tokenID}</h3>
            <p>Token timestamp: {props.timestamp}</p>
            <img className={classes.image} alt="tokenUri" src={getIpfsUrl(props.tokenURI)} />
          </div>
        </Card>
      </li>
    );
}

export default TokenMetadataItem;