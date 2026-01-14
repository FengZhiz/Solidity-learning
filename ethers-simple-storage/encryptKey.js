const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config();

async function main() {
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY);
  const encryptedJsonKey = await wallet.encrypt(
    //返回一个加密的JSON密钥，需要两个参数：密钥密码和密钥
    process.env.PRIVATE_KEY_PASSWORD // 加密密码
    // 无需手动传私钥 —— wallet 实例已持有，方法内部会自动读取
  );
  console.log(encryptedJsonKey);
  fs.writeFileSync("./encrypedKey.json", encryptedJsonKey);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
