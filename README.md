Установка пакетов:
```bash
forge install OpenZeppelin/openzeppelin-contracts
```
```bash
forge install foundry-rs/forge-std
```
Для теста:
```bash
forge test
```

Для деплоя:
```bash
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```