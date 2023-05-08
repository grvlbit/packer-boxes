variable "version" {
  type    = string
  default = ""
}

variable "cloud_token" {
  type    = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source

source "parallels-iso" "aarch64" {
  boot_command           = ["<up>e<down><down><end><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<leftCtrlOn>x<leftCtrlOff>"]
  boot_wait              = "10s"
  cpus                   = "1"
  disk_size              = 81920
  guest_os_type          = "redhat"
  http_directory         = "http"
  iso_checksum           = "sha256:a6df2c64206cc3092c0bf82864bb02d9afe760c2afbdc711867551d8befc3e26"
  iso_urls               = ["Rocky-aarch64-minimal.iso", "https://download.rockylinux.org/pub/rocky/9/isos/aarch64/Rocky-aarch64-minimal.iso"]
  memory                 = "2048"
  parallels_tools_flavor = "lin-arm"
  shutdown_command       = "echo 'vagrant'|sudo -S /sbin/halt -h -p"
  ssh_password           = "vagrant"
  ssh_port               = 22
  ssh_username           = "vagrant"
  ssh_wait_timeout       = "1800s"
  vm_name                = "packer-rockylinux-9-aarch64"
}

source "parallels-iso" "x86_64" {
  boot_command           = ["<up>e<down><down><end><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<leftCtrlOn>x<leftCtrlOff>"]
  boot_wait              = "10s"
  cpus                   = "1"
  disk_size              = 81920
  guest_os_type          = "redhat"
  http_directory         = "http"
  iso_checksum           = "sha256:750c373c3206ae79784e436cc94fffc122296cf1bf8129a427dcd6ba7fac5888"
  iso_urls               = ["Rocky-x86_64-minimal.iso", "http://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-x86_64-minimal.iso"]
  memory                 = "2048"
  parallels_tools_flavor = "lin"
  shutdown_command       = "echo 'vagrant'|sudo -S /sbin/halt -h -p"
  ssh_password           = "vagrant"
  ssh_port               = 22
  ssh_username           = "vagrant"
  ssh_wait_timeout       = "1800s"
  vm_name                = "packer-rockylinux-9-x86_64"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build

build {
  sources = [
             "source.parallels-iso.aarch64",
             "source.parallels-iso.x86_64"
            ]

  post-processors {
    post-processor "vagrant" {
      output = "builds/packer_rockylinux9_{{.BuildName}}_{{.Provider}}.box"
    }

    post-processor "vagrant-cloud" {
        access_token = "${var.cloud_token}"
        box_tag      = "grvlbit/rockylinux9-aarch64"
        version      = "${var.version}"
        only = ["parallels-iso.aarch64"]
    }

    post-processor "vagrant-cloud" {
        access_token = "${var.cloud_token}"
        box_tag      = "grvlbit/rockylinux9"
        version      = "${var.version}"
        only = ["parallels-iso.x86_64"]
    }
  }
}
