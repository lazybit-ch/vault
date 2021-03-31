#!/bin/bash

docker run --rm -it \
    -v ${HOME}/.saferc \
    --network container:vault \
    safe target http://vault:8200 vault

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe init vault

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe vault secrets enable -path=ssh ssh

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe vault write ssh/config/ca generate_signing_key=true

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    --volumes-from vault \
    --entrypoint ash \
    safe -c "safe vault read -field=public_key ssh/config/ca > /certs/ca.pem"

# docker run --rm -i \
#     -v ${HOME}/.saferc:/root/.saferc \
#     --network container:vault \
#     safe vault write ssh/roles/default -<<EOF
# {
#   "allow_user_certificates": true,
#   "allowed_users": "*",
#   "allowed_extensions": "permit-pty,permit-X11-forwarding,permit-agent-forwarding,permit-port-forwarding",
#   "default_extensions": [
#     {
#       "permit-pty": ""
#     }
#   ],
#   "key_type": "ca",
#   "default_user": "git",
#   "ttl": "30m0s"
# }
# EOF

docker run --rm -i \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe vault write ssh/roles/default -<<EOF
{
  "allow_user_certificates": true,
  "allowed_users": "git",
  "allowed_extensions": "permit-pty,permit-port-forwarding",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "git",
  "ttl": "30m0s"
}
EOF

# docker run --rm -it \
#     -v ${HOME}/.ssh:/root/.ssh \
#     -v ${HOME}/.saferc:/root/.saferc \
#     --network container:vault \
#     safe vault write -field=signed_key ssh/sign/default public_key=/root/.ssh/id_rsa.pub

docker run --rm -i \
    -v ${HOME}/.ssh:/root/.ssh \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe vault write -field=signed_key ssh/sign/default -<<EOF > ~/.ssh/id_rsa-cert.pub
{
  "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEnSMccDhxsv1VthTbPg2r4V0wSESHqx0KGaD87LhL1qwRlsA10ALfGU0YH28gPsAmZEFAPYD3DxVeIaxBruLoKrCVOZkB32f2IWoOUMRR9fvNbOZzGJo4RaW/xpHF3UrlTNgsOvP2bEso7y7765mwh1hOX9iFS/2Np3VOVhWbeqQCo7KWR34oHdZrB3cLnT6vbZTTMRZrmzOmCaK3hUiMOt4P2eKMI2OofXOFp52bE/448nDEoa/ZV3KaxZonUKvc2YlvQ1zvAdD6j7P49mRYsvXqK2GufBvsfKk4Uc+FXIfpxSjVPjTE83+afJ8ci8KaFSJeRYlMoX6Y4vfhj0w3 bmassey@hacklabs-2",
  "extensions": {
    "permit-pty": "",
    "permit-port-forwarding": ""
  }
}
EOF

# docker run --rm -it \
#     -v ${HOME}/.saferc:/root/.saferc \
#     --network container:vault \
#     safe vault auth enable oidc
# 
# docker run --rm -it \
#     -v ${HOME}/.saferc:/root/.saferc \
#     --network container:vault \
#     safe vault vault write auth/oidc/config \
#         oidc_discovery_url="http://localhost/y-keycloak/realms/yields" \
#         oidc_client_id="registry" \
#         oidc_client_secret="" \
#         default_profile="default" \
# 
# vault write auth/oidc/role/default \
#     allowed_redirect_uris="http://localhost/ui/vault/auth/oidc/oidc/callback" \
#     allowed_redirect_uris="http://localhost/oidc/callback" \
#     user_claim="email" \
#     policies="default"
# 
# vault write auth/oidc/role/dev -<<EOF
# {
#     "bound_claims": { "groups": ["/yields"] },
#     "oidc_scopes": "profile"
# }
# EOF
