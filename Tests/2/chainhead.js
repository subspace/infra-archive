const { ApiPromise, WsProvider } = require('@polkadot/api');
const fs = require('fs');


async function main() {
//  await checkHealth();

   
    const wsProvider = new WsProvider("ws://172.17.0.1:9944");
    // Initialise the provider to connect to the node
    const rtt = JSON.parse(fs.readFileSync("runtime_types.json"));

    // Create the API and wait until ready
    const api = new ApiPromise({ 
      provider: wsProvider,
      types: rtt
    });
  
    api.on('disconnected', async () => {
      console.log("diconnected");
      process.exit(1);
    });

    api.on('error', async (value) => {
      value.onmessage();
      process.exit(1);
    });

    await api.isReady;

    // Get the chain head
    const header = (await api.rpc.chain.getHeader());
    console.log(header.number.toString());


  while (true) {
  //await api.query.system.account(alice.address);
  //process.stdout.write(`Read balance ${count} times at rate ${rate} r/s\r`);

  //await api.rpc.chain.getHeader();
  //console.log(header.number.toString());

    const header = (await api.rpc.chain.getHeader());
    console.log(header.number.toString());

  }
}

main().catch((e) => {console.error(e); process.exit(1)}).finally(() => process.exit());

