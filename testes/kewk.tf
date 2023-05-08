resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  launch_configuration = aws_launch_configuration.example.id
  min_size             = 1
  max_size             = 3

  # Use spot instances for the workers
  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy = "prioritized"
      on_demand_base_capacity       = 0
      spot_allocation_strategy      = "capacity-optimized"
    }

    launch_template {
      id      = aws_launch_template.example.id
      version = "$Latest"
    }
  }

  # Use a warm pool for the workers
  warm_pool {
    min_size     = 1
    max_size     = 2
    pool_state   = "stopped"
    purge_policy = "OldestInstance"
  }
}


############################################################################################################

# Importar o módulo unittest
import unittest

# Definir uma classe que herda de unittest.TestCase
class TestGenerico(unittest.TestCase):

    # Definir um método que começa com test_
    def test_soma(self):
        # Usar self.assertEqual para verificar se a soma de dois números é igual ao esperado
        self.assertEqual(2 + 3, 5)

    # Definir outro método que começa com test_
    def test_subtracao(self):
        # Usar self.assertEqual para verificar se a subtração de dois números é igual ao esperado
        self.assertEqual(5 - 3, 2)

# Executar os testes se o arquivo for executado como um script
if __name__ == "__main__":
    unittest.main()
