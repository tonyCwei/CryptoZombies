document.addEventListener('DOMContentLoaded', (event) => {
    // 初始化Web3
    if (window.ethereum) {
      window.web3 = new Web3(ethereum);
    } else if (window.web3) {
      window.web3 = new Web3(web3.currentProvider);
    } else {
      console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
    }
  
    let cryptoZombies;
    const cryptoZombiesAddress = "0x00d29eedCf668E53Abc0E86edf0101c8B1A7cC43"; // 请替换为合约地址
  
    async function startApp() {
      cryptoZombies = new web3.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);
    }
  
    startApp();
  
    const feedOnKittyButton = document.querySelector('.feedOnKittyButton');
  
    feedOnKittyButton.addEventListener('click', async () => {
      const zombieId = prompt("Enter your zombie's ID:");
      const kittyId = prompt("Enter the kitty's ID you want to feed on:");
  
      await feedOnKitty(zombieId, kittyId);
    });
  
    async function feedOnKitty(zombieId, kittyId) {
      if (!zombieId || !kittyId) {
        alert("Zombie ID and Kitty ID are required!");
        return;
      }
  
      try {
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        const account = accounts[0];
  
        $("#txStatus").text("Eating a kitty. This may take a while...");
        await cryptoZombies.methods.feedOnKitty(zombieId, kittyId)
          .send({ from: account })
          .on("receipt", function (receipt) {
            $("#txStatus").text("Ate a kitty and spawned a new Zombie!");
            console.log(receipt);
          })
          .on("error", function (error) {
            console.error("Error during feeding: ", error);
            $("#txStatus").text(error.message);
          });
      } catch (error) {
        console.error("Error during feeding: ", error);
        $("#txStatus").text(error.message);
      }
    }
  });
  