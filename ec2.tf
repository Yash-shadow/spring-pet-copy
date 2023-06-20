resource "aws_security_group" "ec2_sg" {

  name = "ec2_sg"
  ingress {
    description = "allow inbiound form secret application "
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"

  }

}

locals {
  sec_id = aws_security_group.ec2_sg.id
}


resource "aws_instance" "myec22" {

  ami           = "ami-0c65adc9a5c1b5d7c"
  instance_type = "t2.medium"
  key_name      = var.key_pair
  depends_on    = [aws_security_group.ec2_sg]
  count         = var.counts

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_path)
    host        = self.public_ip
    timeout     = "1000m"


  }
  vpc_security_group_ids = [local.sec_id]
  provisioner "remote-exec" {
    inline = [

      "sudo apt-get update",
      "sudo apt-get install ca-certificates curl gnupg -y",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "chmod a+r /etc/apt/keyrings/docker.gpg",

      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
      "sudo apt install openjdk-17-jre-headless -y",
      "cd ~",
      "git clone https://github.com/Yash-shadow/spring-pet-copy.git",
      "cd ./spring-pet-copy",
      "sudo docker compose up -d"
    ]


  }





}


output "myIPS" {
  value = aws_instance.myec22[*].public_ip
  

}


