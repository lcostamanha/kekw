filter @message like /"resource_path":"\/webauthn_service\/v1\/pre_authenticacoes"/
| display @message


filter @message like /"resource_path":"\/webauthn_service\/v1\/pre_authenticacoes"/
| fields @message


filter @message like /"resource_patch":/
| display @message


filter resource_patch is not null
| fields resource_patch

filter @message like /"status": "200"/ and @message like /"resource_path": "\/webauthn_service\/v1\/credenciais"/
| display @message

filter @message like /"status": "200"/ and @message like /"resource_path": "\/webauthn_service\/v1\/credenciais"/ and not @message like /"status": "403"/
| display @message
