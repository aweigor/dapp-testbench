import { FetchNFTsForm } from "./fetch-nfts-form";
export default function Home() {
  return <FetchNFTsForm apiKey={process.env.NEXT_PUBLIC_API_KEY} />;
}
