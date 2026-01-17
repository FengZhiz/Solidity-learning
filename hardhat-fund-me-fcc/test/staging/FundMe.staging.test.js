const { ethers, getNamedAccounts, network, deployments } = require("hardhat")
const { expect } = require("chai")
const { developmentChains } = require("../../helper-hardhat-config")

developmentChains.includes(network.name)
    ? describe.skip
    : describe("FundMe Staging Tests", function () {
          let fundMe
          let deployer
          const sendValue = ethers.parseEther("0.1")

          beforeEach(async function () {
              deployer = (await getNamedAccounts()).deployer
              const fundMeDeployment = await deployments.get("FundMe")
              fundMe = await ethers.getContractAt(
                  "FundMe",
                  fundMeDeployment.address,
                  await ethers.getSigner(deployer)
              )
          })

          it("allows people to fund and withdraw", async function () {
              await fundMe.fund({ value: sendValue })
              await fundMe.withdraw()
              const endingFundMeBalance = await ethers.provider.getBalance(
                  fundMe.getAddress()
              )
              expect(endingFundMeBalance).to.equal(0)
          })
      })
