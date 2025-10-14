import {Script} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract DeployScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
      string memory seedPhrase = vm.readFile(".secret");
      uint256 privateKey = vm.deriveKey(seedPhrase, 0);
      vm.startBroadcast(privateKey);
      Counter counter = new Counter();
      vm.stopBroadcast();
    }
}
