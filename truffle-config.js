require("babel-register");
require("babel-polyfill");
const HDWalletProvider = require("@truffle/hdwallet-provider");

let mnemonic =
    "cbc2d2ad6202a8b3e2cc01104fef84f3b19bff9a78c18b3238e08117963376ee";

module.exports = {
    networks: {
        // bsc: {
        //     provider: () =>
        //         new HDWalletProvider(
        //             mnemonic,
        //             `https://bsc-dataseed1.binance.org`
        //         ),
        //     network_id: 56,
        //     confirmations: 10,
        //     timeoutBlocks: 200,
        //     skipDryRun: true,
        // },
        // testnet: {
        //     provider: () =>
        //         new HDWalletProvider(
        //             mnemonic,
        //             `https://data-seed-prebsc-1-s1.binance.org:8545`
        //         ),
        //     network_id: 97,
        //     confirmations: 10,
        //     timeoutBlocks: 200,
        //     skipDryRun: true,
        // },
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*", // Match any network id
        },
    },
    contracts_directory: "./src/contracts/",
    contracts_build_directory: "./src/abis/",
    compilers: {
        solc: {
            version: "0.8.1",
        },
    },
};
