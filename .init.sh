#!/bin/bash

# VAULT_KEYS=$(docker run --rm -it \
#     -e VAULT_ADDR=http://vault:8200 \
#     --cap-add IPC_LOCK \
#     --network container:vault \
#     vault:1.7.0 operator init -format=json)

VAULT_KEYS='{
  "unseal_keys_b64": [
    "W/EC1c1FU0d4IPPW4jXGeLmUgSy6EmopSzXPT0pgxgy2",
    "F4ZokhFKeTdw9g7+JSu2iKY80naGhROntKsKGLAKnGmk",
    "E77zAwOu+VH9fTWQLO47B/JwDG0PcdRI7rHVpLMKoKZZ",
    "95PT3t5iLvAtX2gvSop8C+bp3xqsBQ574vLdF4nA/DMF",
    "MigmKAyP7SJCnoav8AXEO5ZB6i/RATMvynH8o+v0cm3C"
  ],
  "unseal_keys_hex": [
    "5bf102d5cd4553477820f3d6e235c678b994812cba126a294b35cf4f4a60c60cb6",
    "17866892114a793770f60efe252bb688a63cd276868513a7b4ab0a18b00a9c69a4",
    "13bef30303aef951fd7d35902cee3b07f2700c6d0f71d448eeb1d5a4b30aa0a659",
    "f793d3dede622ef02d5f682f4a8a7c0be6e9df1aac050e7be2f2dd1789c0fc3305",
    "322826280c8fed22429e86aff005c43b9641ea2fd101332fca71fca3ebf4726dc2"
  ],
  "unseal_shares": 5,
  "unseal_threshold": 3,
  "recovery_keys_b64": [],
  "recovery_keys_hex": [],
  "recovery_keys_shares": 5,
  "recovery_keys_threshold": 3,
  "root_token": "s.87WYvQvBcRdGdaeKmxW0MViP"
}'

echo "${VAULT_KEYS}"

ROOT_TOKEN=$()
