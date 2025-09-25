import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("CounterModule", (m) => {
  const messenger = m.contract("Messenger");

  m.call(messenger, "incBy", [5n]);

  return { messenger };
});
