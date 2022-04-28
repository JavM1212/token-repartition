import React, { Component } from "react";

import { ChakraProvider } from "@chakra-ui/react";

import TokenRepartition from "./TokenRepartition/TokenRepartition";

class App extends Component {
    render() {
        return (
            <ChakraProvider>
                <TokenRepartition />
            </ChakraProvider>
        );
    }
}

export default App;
