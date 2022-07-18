const helloWorld = artifacts.require("HelloWorld");

contract("HelloWorld", () => {
    it("Testing", async () => {
        const instance = await helloWorld.deployed();
        await instance.setMessage("Hello Sargoda");
        const message = await instance.message();
        assert(message == "Hello Sargoda")
    })
})