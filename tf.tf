configurations = [
  {
    applications = [
      {
        name = "webauthnbff",
        parameters = [
          {
            name = "gw.address"
            description = ""
            type = "String"
            value = "https://x4azcevw82.execute-api.sa-east-1.amazonaws.com/dev"
            isSensitive = false
          },
          {
            name = "http.maxconnections"
            description = ""
            type = "String"
            value = "5"
            isSensitive = false
          }
        ]
      },
      {
        name = "fido",
        parameters = [
          {
            name = "alguma_configuracao"
            description = ""
            type = "String"
            value = "algum_valor"
            isSensitive = false
          },
          {
            name = "outra_configuracao"
            description = ""
            type = "String"
            value = "outro_valor"
            isSensitive = false
          }
        ]
      }
    ]
  }
]

