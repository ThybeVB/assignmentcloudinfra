Om Terraform te installeren wordt volgend commando gebruikt
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Oracle OCI Integratie

Om via Terraform te deployen naar OCI (Oracle Cloud Infrastructure) zullen we de OCI CLI moeten installeren. Deze CLI zal automatisch een token maken die later zal worden gebruikt in Terraform. Volgende commando's tonen hoe dit wordt geïnstalleerd.

```powershell
Set-ExecutionPolicy RemoteSigned
Invoke-WebRequest https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.ps1 -OutFile install.ps1
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.ps1'))
```

Om dit alternatief in Linux te doen, is het maar één commando. Om dat ik redelijk wat problemen had met de Windows versie koos ik ervoor dit in Ubuntu te doen.

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
```

Eenmaal de CLI is geïnstalleerd, kunnen we de sessie met OCI initializeren.
![Terraform OCI Config 1](./md-images/terraform_oci_config1.png)

Door een tutorial van OCI/Terraform te volgen maken we een basisconfiguratie voor het deployen met OCI. De SecurityToken wordt gehaald uit de machine met de cli, en de compartment_id wordt gehaald uit een `secrets.auto.tfvars` file.

```terraform
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region              = "eu-amsterdam-1"
  auth                = "SecurityToken"
  config_file_profile = "profile"
}

resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = var.compartment_id
  display_name   = "My internal VCN"
}

variable "compartment_id" {
  type        = string
  sensitive   = true
}
```

Na ```terraform apply``` uit te voeren zien we dat in Oracle een VCN werd gemaakt.
![VCN Created](./md-images/terraform-vcn-1.png.png)

