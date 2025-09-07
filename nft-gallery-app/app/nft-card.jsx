export const NftCard = (nft) => {
  return (
    <div>
      <p>
        {nft.contract.address.substr(0, 5)}...
        {nft.contract.address.substr(nft.contract.address.length - 4)}
      </p>
    </div>
  );
};
