import React, { useEffect, useState } from "react";
import { Container, Center, Input, Button, Text } from "@chakra-ui/react";
import Web3 from "web3";
import VOLTA_BUSD from "../../abis/VOLTA_BUSD.json";

const PickWinner = () => {
    const [account, setAccount] = useState("");
    const [contract, setContract] = useState("");
    const [winner, setWinner] = useState("");

    const loadWeb3 = async () => {
        if (window.ethereum) {
            window.web3 = new Web3(window.ethereum);
            await window.ethereum.enable();
        } else if (window.web3) {
            window.web3 = new Web3(window.web3.currentProvider);
        } else {
            window.alert(
                "Not Ethereum browser detected. You should consider trying Metamask!"
            );
        }
    };

    const loadBlockChain = async () => {
        const web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        setAccount(accounts[0]);
        console.log("account", account);
        const networkId = "56";
        console.log("networkId: ", networkId);
        const networkData = VOLTA_BUSD.networks[networkId];
        console.log("networkData: ", networkData);

        const abi = VOLTA_BUSD.abi;
        const contract = new web3.eth.Contract(
            abi,
            "0x9A16eb6C89059C610296C1530AC0D157242ceE42"
        );
        setContract(contract);
    };

    const loadAll = async () => {
        await loadWeb3();
        await loadBlockChain();
    };

    const pickWinner = async () => {
        try {
            await contract.methods.PickWinner(winner).send({
                from: account,
            });
        } catch (error) {
            console.log(error);
        }
    };

    useEffect(() => {
        loadAll();
    }, []);

    return (
        <Container maxW="container.xl" h="calc(100vh)" bg="#edeef0" p={5}>
            <Center flexDirection="column">
                <Text m={1} fontSize="3xl" fontWeight="medium">
                    Token Quantity
                </Text>
            </Center>
            <Center m={3}>
                <Input
                    placeholder="Token Quantity"
                    maxW="sm"
                    bg="white"
                    borderColor="grey"
                    border="2px"
                    color="black"
                    mr={5}
                    onChange={(e) => setWinner(e.target.value)}
                />
            </Center>
            <Center flexDirection="column">
                <Text m={1} fontSize="3xl" fontWeight="medium">
                    Buyers List
                </Text>
            </Center>
            <Center m={3}>
                <Input
                    placeholder=" Buyers List"
                    maxW="sm"
                    bg="white"
                    borderColor="grey"
                    border="2px"
                    color="black"
                    mr={5}
                    onChange={(e) => setWinner(e.target.value)}
                />
            </Center>
            <Center m={10}>
                <Button
                    bg="#3E3F5E"
                    color="white"
                    _hover={{ background: "#4d4e73" }}
                    onClick={pickWinner}
                >
                    Pick Winner
                </Button>
            </Center>
        </Container>
    );
};

export default PickWinner;
