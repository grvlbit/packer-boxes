# grvlbit's Vagrant Box Packer Builds for Parallels

This project contains the Packer build configurations for all of grvlbit's Vagrant Boxes. Each box builds a minimal base box for use with Parallels. Available boxes include:

  - [grvlbit/rockylinux8](https://app.vagrantup.com/grvlbit/boxes/rockylinux8) - [`rockylinux8` directory](rockylinux8/)
  - [grvlbit/rockylinux8](https://app.vagrantup.com/grvlbit/boxes/rockylinux9) - [`rockylinux9` directory](rockylinux9/)

All of these boxes are available as public, free Vagrant boxes and can be used with the command:

    vagrant init grvlbit/[box name here]

You can also fork this repository and customize a build configuration with your own Ansible roles and playbooks to build a fully custom Vagrant box using Packer.

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build any of these Vagrant boxes:

  - [Packer](http://www.packer.io/)
  - [Parallels](https://www.parallels.com/)
  - [Parallels Virtualization SDK](https://www.parallels.com/download/pvsdk/)
  - [Vagrant](http://vagrantup.com/)
  - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Installing Packer

Download the latest packer from <http://www.packer.io/downloads.html>
and unzip the appropriate directory.

If you are an macOS user consider installing packer using [Homebrew](http://brew.sh/):

    $ brew tap homebrew/binary
    $ brew install packer
    $ brew install packer-completion [optional for bash autocompletion]
    $ brew install parallels-virtualization-sdk

## Usage

Make sure all the required software (listed above) is installed, then cd into one of the box directories and run:

    $ packer build -var 'version=1.0.0' -only=parallels-iso.arm64 .

> **Note**: If you're running different python environments on your machine, you might need to adapt the `PYTHONPATH` so that the ParallelsVirtualizationSDK is found. On MacOS: `PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/10/Libraries/Python/3.7`

After a few minutes, Packer should tell you the box was generated successfully, and the box was uploaded to Vagrant Cloud.

> **Note**: This configuration includes a post-processor that pushes the built box to Vagrant Cloud (which requires a `VAGRANT_CLOUD_TOKEN` environment variable to be set); remove the `vagrant-cloud` post-processor from the Packer template to build the box locally and not push it to Vagrant Cloud. You don't need to specify a `version` variable either, if not using the `vagrant-cloud` post-processor.

If you don't want to push your box to the Vagrant Cloud you'll need to add the box to vagrant manually:

    $ vagrant box add --name rockylinux9 builds/parallels-rockylinux9.box

### Building _all_ the boxes

Whenever VirtualBox is updated, it's best to re-build _all_ the base boxes so they have the latest guest additions.

Assuming you have Ansible and Packer installed already, and you have a `VAGRANT_CLOUD_TOKEN` available in your environment, you can run the playbook to build and push updated versions for all the boxes:

    ansible-playbook build-boxes.yml

You can also build and push just one box:

    ansible-playbook build-boxes.yml -e "{'boxes':['rockylinux9']}"

## Testing built boxes

There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From the same box directory, run the following command after building the box:

    $ vagrant up

Test that the box works correctly, then tear it down with:

    $ vagrant destroy -f

## License

MIT

## Credits

These packer templates were built by considering different sources of inspiraiton. Therefore credits to whom it belongs:

* Michael Rolli (mrolli)
* Jeff Geerling (geerlingguy)
