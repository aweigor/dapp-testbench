import { useState } from "react";

export default function Home() {
  const [wallet, setWalletAddress] = useState("");
  const [collection, setCollectionAddress] = useState("");
  const [nfts, setNFTs] = useState([]);
  async function fetchNFTsForOwner() {
    var requestOptions = {
      method: "GET",
      redirect: "follow",
    };
    const apiKey = process.env.API_KEY;
    const baseURL = `https://eth-mainnet.g.alchemy.com/nft/v3/${apiKey}/getNFTsForOwner/`;
    const pageSize = 2;
    let result;
    if (collection.length) {
      const fetchURL = `${baseURL}?owner=${wallet}&pageSize=${pageSize}`;
      result = await fetch(fetchURL, requestOptions).then((response) =>
        response.json()
      );
    } else {
      const url = `${baseURL}?contractAddresses=${new URLSearchParams([
        collection,
      ]).getAll()}&owner=${wallet}&pageSize=${pageSize}`;
      result = await fetch(url, requestOptions).then((response) =>
        response.json()
      );
    }

    if (result) {
      console.log("NFTs", result);
      setNFTs(result?.ownedNfts);
    }
  }

  async function fetchNFTsForCollection() {
    const apiKey = process.env.API_KEY;
    const baseURL = `https://eth-mainnet.g.alchemy.com/nft/v3/${apiKey}/getNFTsForCollection/`;

    if (collection.length) {
      const fetchURL = `${baseURL}?conteractAddress=${wallet}&withMetadata=${"true"}`;
      result = await fetch(fetchURL, requestOptions).then((response) =>
        response.json()
      );
    } else {
      const url = `${baseURL}?contractAddresses=${new URLSearchParams([
        collection,
      ]).getAll()}&owner=${wallet}&pageSize=${pageSize}`;
      result = await fetch(url, requestOptions).then((response) =>
        response.json()
      );
    }
  }
  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-2">
      <div>
        <input
          onChange={(e) => {
            setWalletAddress(e.target.value);
          }}
          type={"text"}
          placeholder="Wallet address"
        ></input>
        <input
          onChange={(e) => {
            setCollectionAddress(e.target.value);
          }}
          type={"text"}
          placeholder="Collection address"
        ></input>
        <label>
          <input type={"checkbox"}>Fetch for collection</input>
        </label>
        <button onClick={fetchNFTs}>Let's go! </button>
      </div>
    </div>
  );
}
