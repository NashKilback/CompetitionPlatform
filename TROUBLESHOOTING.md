# 🔧 Troubleshooting Guide - Hello FHEVM

Common issues and solutions for the Hello FHEVM tutorial.

## 🔗 Wallet Connection Issues

### ❌ "MetaMask not detected"
**Problem**: Browser can't find MetaMask extension

**Solution**:
1. Install MetaMask: https://metamask.io/
2. Refresh the page
3. Make sure MetaMask is unlocked

### ❌ "Wrong network"
**Problem**: MetaMask connected to wrong network

**Solution**:
1. Open MetaMask
2. Click network dropdown (top)
3. Select "Sepolia Test Network" or "Localhost 8545"
4. Refresh page

### ❌ "Insufficient funds"
**Problem**: Not enough ETH for gas fees

**Solution**:
- **Sepolia**: Get test ETH from [Sepolia Faucet](https://sepoliafaucet.com/)
- **Local**: Import account from hardhat node output
```bash
# Hardhat provides test accounts with 10000 ETH each
Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)
Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## 💻 Development Issues

### ❌ "Contract not deployed"
**Problem**: Frontend can't find contract

**Solution**:
1. Make sure contract is deployed:
```bash
npx hardhat run scripts/deploy.js --network hardhat
```
2. Copy the deployed address
3. Update `CONTRACT_ADDRESS` in `frontend/index.html`

### ❌ "Node.js version error"
**Problem**: Node.js too old

**Solution**:
1. Install Node.js 16+: https://nodejs.org/
2. Verify version: `node --version`
3. Reinstall dependencies: `npm install`

### ❌ "Permission denied"
**Problem**: File permission issues (Windows/Mac)

**Solution**:
```bash
# Windows
npm config set script-shell "C:\\Program Files\\git\\bin\\bash.exe"

# Mac/Linux
sudo npm install -g npm
```

## 🌐 Network Issues

### ❌ "Failed to fetch"
**Problem**: Can't connect to blockchain

**Solution**:
1. **Local network**: Make sure hardhat node is running
```bash
npx hardhat node
```
2. **Sepolia**: Check Infura project ID in `.env`
3. **MetaMask**: Try disconnecting and reconnecting

### ❌ "Transaction failed"
**Problem**: Transaction reverted

**Common Causes**:
- Insufficient gas limit
- Contract requirements not met
- Already joined competition
- Invalid competition ID

**Solution**:
1. Check MetaMask transaction details
2. Verify requirements in smart contract
3. Try with more gas

## 🔐 FHEVM Specific Issues

### ❌ "Scores not private"
**Problem**: Individual scores are visible

**Explanation**: This tutorial uses a simplified version for learning. In production FHEVM:
- Scores are encrypted client-side
- Only encrypted data is stored
- Individual scores remain private

**Solution**: For real privacy, integrate with Zama's fhEVM library:
```bash
npm install fhevm
```

### ❌ "Understanding FHE concepts"
**Problem**: Confused about Fully Homomorphic Encryption

**Resources**:
- [Zama Documentation](https://docs.zama.ai/)
- [FHE Explained Simply](https://blog.zama.ai/what-is-fully-homomorphic-encryption/)
- [FHEVM Tutorial Series](https://docs.zama.ai/fhevm)

## 📱 Browser Issues

### ❌ "Console errors"
**Problem**: JavaScript errors in browser

**Solution**:
1. Open Developer Tools (F12)
2. Check Console tab for errors
3. Common fixes:
   - Clear browser cache
   - Disable ad blockers
   - Try incognito mode

### ❌ "Page doesn't load"
**Problem**: Frontend server issues

**Solution**:
```bash
# Try different port
npx http-server -p 3000

# Or use Python
python -m http.server 3000

# Or Node.js
npx serve -p 3000
```

## 🔍 Debugging Tips

### Check Contract Status
```bash
# Verify contract deployment
npx hardhat verify --network sepolia <CONTRACT_ADDRESS>

# Test contract functions
npx hardhat console --network sepolia
```

### Check Transaction Details
1. Copy transaction hash from MetaMask
2. Visit Sepolia Etherscan: `https://sepolia.etherscan.io/tx/<HASH>`
3. Check status and error messages

### Enable Debug Logging
Add to your frontend JavaScript:
```javascript
// Add after ethers import
window.ethers = ethers; // For console debugging
console.log("Debug mode enabled");
```

## 📞 Getting Help

### Before Asking for Help

1. ✅ Read error messages completely
2. ✅ Check this troubleshooting guide
3. ✅ Try the suggested solutions
4. ✅ Search existing issues on GitHub

### Where to Get Help

- **Zama Discord**: https://discord.gg/zama
- **GitHub Issues**: Create detailed issue with:
  - Error message (full text)
  - Steps to reproduce
  - Your environment (OS, Node version, etc.)
  - Screenshot if applicable

### Reporting Template

```
**Problem**: Brief description

**Environment**:
- OS: Windows 10 / macOS / Linux
- Node.js version:
- Browser: Chrome / Firefox / Safari
- MetaMask version:

**Steps to reproduce**:
1.
2.
3.

**Error message**:
```
[Paste full error here]
```

**What I've tried**:
-
-
```

## 🎯 Success Checklist

If everything works correctly, you should see:

✅ MetaMask connects without errors
✅ Wallet address and balance displayed
✅ Competition cards load properly
✅ Join button works (prompts for name/submission)
✅ Transaction confirms in MetaMask
✅ Success message appears
✅ Button changes to "Joined ✓"

## 🚀 Performance Tips

### Speed Up Development
```bash
# Use local network for faster testing
npx hardhat node --hostname 0.0.0.0

# Skip gas estimation for local testing
// In frontend, add:
gasLimit: 3000000
```

### Optimize for Production
- Use environment variables for sensitive data
- Implement proper error handling
- Add loading states for better UX
- Cache contract instances

---

**Still stuck?** The Zama community is friendly and helpful! Join the [Discord](https://discord.gg/zama) for real-time support. 🤝