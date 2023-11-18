# Demo

## Video

The video is [here](./Sarma.mp4) or on YouTube [here](https://youtu.be/TQwNU1_pgeE).

## Demo instructions

Create the private accounts:
```
cd client
node createPrivateAccounts.js
```
Observe the files in ```client/keys```.

There are 3 types of transactions implemented in the example:

Public to private, transfers 2 beans from the EVM contract to the private account:
```
cd client
node public_to_private_execution.js
```

Private to private, spends 2 beans, 1 goes back to the original owner and 1 to the new owner:
```
cd client
node private_to_private_execution.js
```

Private to public, spends 1 bean and transfers it to the EVM contract:
```
cd client
node private_to_public_execution.js
```
