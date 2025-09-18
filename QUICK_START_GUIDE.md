# 🚀 Quick Start Guide - Hello FHEVM

**Get your first confidential dApp running in under 10 minutes!**

## ⚡ Prerequisites (2 minutes)

✅ **MetaMask installed** ([Download here](https://metamask.io/))
✅ **Node.js 16+** ([Download here](https://nodejs.org/))
✅ **Basic Solidity knowledge** (can write simple smart contracts)

## 🏁 Quick Setup (5 minutes)

### 1. Clone & Install
```bash
git clone <your-repo-url>
cd hello-fhevm-dapp
npm install
```

### 2. Deploy Locally
```bash
# Start local blockchain
npx hardhat node

# Deploy contracts (in new terminal)
npx hardhat run scripts/deploy.js --network hardhat
```

### 3. Run Frontend
```bash
cd frontend
npx http-server -p 8000
```

### 4. Connect & Test
1. Open `http://localhost:8000`
2. Connect MetaMask to `localhost:8545`
3. Import test account from hardhat node
4. Try joining a competition!

## 🔗 Sepolia Testnet (3 minutes)

### 1. Get Test ETH
- Visit [Sepolia Faucet](https://sepoliafaucet.com/)
- Enter your wallet address
- Wait for test ETH

### 2. Deploy to Sepolia
```bash
# Set up .env file
echo "INFURA_PROJECT_ID=your_infura_id" > .env
echo "PRIVATE_KEY=your_private_key" >> .env

# Deploy
npx hardhat run scripts/deploy.js --network sepolia
```

### 3. Update Frontend
- Copy deployed contract address
- Update `CONTRACT_ADDRESS` in `frontend/index.html`
- Test with real testnet!

## 🎯 What You'll Learn

- **FHEVM Basics**: Private computations on blockchain
- **Smart Contracts**: Privacy-preserving scoring system
- **Web3 Integration**: MetaMask + Ethers.js
- **Real Transactions**: Sepolia testnet deployment

## 🆘 Need Help?

- **Tutorial too fast?** → Read the [Full Tutorial](./HELLO_FHEVM_TUTORIAL.md)
- **Errors?** → Check the [Troubleshooting Guide](./TROUBLESHOOTING.md)
- **Questions?** → Join [Zama Discord](https://discord.gg/zama)

## 🎉 Success Criteria

✅ Wallet connected to dApp
✅ Successfully joined a competition
✅ Transaction confirmed on blockchain
✅ Understanding of FHEVM concept

**Time to complete: 10 minutes** ⏱️

---

**Ready for more?** Continue with the [Complete Tutorial](./HELLO_FHEVM_TUTORIAL.md) to understand the code in depth!