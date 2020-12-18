
  
## Mayan Direct-Deployment IAC

This repo has the infrastructure as code for deploying [Mayan EDMS](https://www.mayan-edms.com) directly to a virtual machine. 

This is the equivalent of [this mayan documentation](https://docs.mayan-edms.com/chapters/deploying.html). It is also the container-level installation for mayan: it will deploy a virtual machine running Mayan @ [10.0.0.200:8000](http://10.0.0.200:8000/), and you will be able to develop in the VM directly. 
  

### Requirements

* Free up **3GB** of space (you can try the installation minimum w/ **2GB**)
* Make sure you have Vagrant and VirtualBox installed

### Deployment 

* Clone this project, and `cd` into its directory:
* run `vagrant up`, and wait for the install scripts to finish
	* this may take up to **20 minutes**
	* it will create a vagrant VM (`master`) at the private IP `10.0.0.200`
	* the Django application will run on port `8000`
* When done, you can get a shell into the machine with `vagrant ssh`
* The mayan server should have started automatically, access it with your browser here ~> [10.0.0.200:8000](http://10.0.0.200:8000/).

### Notes

* The project is deployed to `/opt/mayan-edms/` in the VM
* The mayan apps directory is located here: `/opt/mayan-edms/lib/python3.6/site-packages/mayan`
* The Python version it uses is installed here: `/opt/mayan-edms/bin/python3`

### mk 