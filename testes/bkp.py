from unittest.mock import MagicMock

def test_read_from_dynamo():
    # Criar um objeto GlueJob
    glue_job = GlueJob(args={})

    # Simular o GlueContext e a resposta do DynamoDB
    glue_job.glueContext = MagicMock()
    glue_job.glueContext.create_dynamic_frame.from_options.return_value = "fake_frame"

    # Chamar o método read_from_dynamo
    result = glue_job.read_from_dynamo("fake_table_name")

    # Verificar se o resultado é o esperado
    assert result == "fake_frame"

if __name__ == "__main__":
    test_read_from_dynamo()
    print("All tests passed!")
