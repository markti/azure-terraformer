build {
  sources = [
    "source.azure-arm.vm"
  ]

  provisioner shell {
    execute_command = local.execute_command
    inline = ["apt update && apt upgrade -y"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    pause_before = "90s"
    inline = [
      "apt-get install -y jq"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get install -y build-essential"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "wget -q https://repos.influxdata.com/influxdata-archive_compat.key",
      "echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null",
      "echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list",
      "apt-get update",
      "apt-get install -y influxdb",
      "apt-get install -y telegraf"
      ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb",
      "dpkg -i packages-microsoft-prod.deb",
      "apt-get update",
      "apt-get install -y powershell"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["curl -sL https://aka.ms/InstallAzureCLIDeb | bash"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install curl"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install wget"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get -y install unzip"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install grep"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install screen"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install openssl"]
  }

  provisioner shell {
    execute_command = local.execute_command
    inline = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only = ["azure-arm"]
  }

}