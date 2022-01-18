# azure-devops
Interview assesment


azure-devops.yaml file can be used to configure azuredevops file to perform terraform plan and apply resource , required pipeline setup and parameters need to be passwed to pipeline 

In this example code I have referred module directly 
in real time senaiors we need dedicate repository for TF module and we refere to those modules using github link 

E.g. 

module "consul" {
  source = "git@github.com:hashicorp/example.git"
}
