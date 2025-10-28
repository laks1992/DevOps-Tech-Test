module "network" {
  source = "./modules/network"
  project = var.project
  env     = var.env
}

module "ecs_cluster" {
  source = "./modules/ecs_cluster"
  project = var.project
  env     = var.env
  ami_id = "ami-0c02fb55956c7d316" #
  subnet_ids = module.network.public_subnet_ids
}

module "alb" {
  source = "./modules/alb"
  project = var.project
  env     = var.env
  public_subnet_ids = module.network.public_subnet_ids
  security_group_ids = [aws_security_group.alb_sg.id]
  vpc_id = module.network.vpc_id
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecr_repository" "app" {
  name = "${var.project}-app"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name = "app"
      image = "${aws_ecr_repository.app.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 3000, hostPort = 0 }]
      environment = [
        { name = "MONGO_URI", value = var.mongo_uri },
        { name = "NODE_ENV", value = var.env }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "${var.project}-service"
  cluster         = module.ecs_cluster.this_cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = module.alb.tg_arn
    container_name   = "app"
    container_port   = 3000
  }
  depends_on = [aws_lb_listener.http]
}
