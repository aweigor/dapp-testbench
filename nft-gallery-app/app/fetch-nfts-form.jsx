"use client";
import { useState } from "react";

export function FetchNFTsForm({ apiKey }) {
  const PAGE_SIZE = 10;
  const BASE_URL = `https://eth-mainnet.g.alchemy.com/nft/v3/${apiKey}`;
  const getURL = (apiPath, params) => {
    const url = new URL(`${BASE_URL}/${apiPath}`);
    url.search = new URLSearchParams(params);
    return url;
  };
  const PROCEDURE_FOR_OWNER = "getNFTsForOwner";
  const PROCEDURE_FOR_COLLECTION = "getNFTsForCollection";
  const [wallet, setWalletAddress] = useState("");
  const [collection, setCollectionAddress] = useState("");
  const [nfts, setNFTs] = useState([]);
  const [fetchForCollection, setFetchForCollection] = useState("");
  async function fetchNFTsForOwner() {
    const requestOptions = {
      method: "GET",
      redirect: "follow",
    };
    const url = getURL(
      PROCEDURE_FOR_OWNER,
      collection.length
        ? {
            contractAddresses: [collection],
            owner: wallet,
            pageSize: PAGE_SIZE,
          }
        : { owner: wallet, pageSize: PAGE_SIZE }
    );

    const result = await fetch(url, requestOptions).then((response) =>
      response.json()
    );

    if (result) {
      console.log("NFTs", result);
      setNFTs(result?.ownedNfts);
    }
  }

  async function fetchNFTsForCollection() {
    const requestOptions = {
      method: "GET",
      redirect: "follow",
    };
    const url = getURL(
      PROCEDURE_FOR_COLLECTION,
      collection.length
        ? {
            contractAddress: wallet,
            withMetadata: "true",
            pageSize: PAGE_SIZE,
          }
        : {
            contractAddress: collection,
            owner: wallet,
            pageSize: PAGE_SIZE,
          }
    );

    const result = await fetch(url, requestOptions).then((response) =>
      response.json()
    );

    if (result) {
      console.log("NFTs", result);
      setNFTs(result?.ownedNfts);
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
          <input
            onChange={(e) => {
              setFetchForCollection(e.target.checked);
            }}
            type={"checkbox"}
          ></input>
          Fetch for collection
        </label>
        <button
          onClick={() => {
            if (fetchForCollection) {
              fetchNFTsForCollection();
            } else {
              fetchNFTsForOwner();
            }
          }}
        >
          Let's go!
        </button>
      </div>
      <div>
        {nfts.map((nft) => (
          <NftCard nft={nft} />
        ))}
      </div>
    </div>
  );
}
