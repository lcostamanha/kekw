filter @message like /"resource_path":"\/webauthn_service\/v1\/pre_authenticacoes"/
| display @message


filter @message like /"resource_path":"\/webauthn_service\/v1\/pre_authenticacoes"/
| fields @message


filter @message like /"resource_patch":/
| display @message


filter resource_patch is not null
| fields resource_patch
