document.addEventListener('DOMContentLoaded', (event) => {
  // Listen to the feeding button click event
  document.querySelector('.feedOnKittyButton').addEventListener('click', async () => {
    // User enters zombie ID and kitten ID
    const zombieId = prompt("Enter your zombie's ID:");
    const kittyId = prompt("Enter the kitty's ID you want to feed on:");

    // Check whether the cryptoZombies contract instance has been initialized
    if (!window.cryptoZombies || !zombieId || !kittyId) {
      alert("CryptoZombies contract is not initialized, or some input is missing.");
      return;
    }

    try {
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      const account = accounts[0];

      // Show status information
      $("#txStatus").text("Eating a kitty. This may take a while...");
      // Call the feedOnKitty method of the contract
      await window.cryptoZombies.methods.feedOnKitty(zombieId, kittyId)
        .send({ from: account })
        .on("receipt", function (receipt) {
          $("#txStatus").text("Ate a kitty and spawned a new Zombie!");
          console.log(receipt);
        })
        .on("error", function (error) {
          console.error("Error during feeding: ", error);
          $("#txStatus").text("Failed to feed on kitty: " + error.message);
        });
    } catch (error) {
      console.error("Error during feeding: ", error);
      $("#txStatus").text("Failed to feed on kitty: " + error.message);
    }
  });
});

  
