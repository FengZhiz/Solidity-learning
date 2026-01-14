require("@nomiclabs/hardhat-waffle")
require("dotenv").config()
require("@nomicfoundation/hardhat-verify")
require("./tasks/block-number")
require("hardhat-gas-reporter")
require("solidity-coverage")

//解决超时问题
const { ProxyAgent, setGlobalDispatcher } = require("undici")
const proxyAgent = new ProxyAgent("http://172.28.240.1:7899")
setGlobalDispatcher(proxyAgent)

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL || "https:/..."
const PRIVATE_KEY = process.env.PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY

module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        sepolia: {
            url: SEPOLIA_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 11155111,
        },
        localhost: {
            url: "http://127.0.0.1:8545/",
            chainId: 31337,
        },
    },
    solidity: "0.8.7",
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
    gasReporter: {
        enabled: false,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: COINMARKETCAP_API_KEY,
        gasPriceApi: `https://api.etherscan.io/v2/api?module=proxy&chainid=1&action=eth_gasPrice&apikey=${ETHERSCAN_API_KEY}`,
    },
}
