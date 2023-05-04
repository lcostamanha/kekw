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
}



Você pode substituir os valores de name, 
launch_configuration, 
min_size, max_size, 
on_demand_allocation_strategy, 
on_demand_base_capacity, spot_allocation_strategy, id e version pelos valores que desejar.
