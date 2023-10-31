<h1 align="center">Deploy an Infrastructure using Terraform and Jenkins Agent<h1> 


# Deployment 6
October 28, 2023

By: Andrew Mullen

## Purpose:

Purpose:
Demonstrate our ability to use Terraform to deploy infrastructure. First, deploy a Jenkins infrastructure with a main and agent servers.  Also, utilize Jenkins agents, use Terraform, and deploy the Banking Flask application to EC2 instances across regions and AZ's.

## Steps:

### 1. Follow the naming convention below for all resources created in AWS:
```
VPC:
- deplpoyment#-vpc-region: 
	- deployment6-vpc-east
	- deployment6-vpc-west
Instances:
- Function#-region: 
	- applicationServer01-east
	- applicationServer02-east
	- applicationServer01-west
	- applicationServer02-west
Security Groups:
- purposeSG: 
	- US_East_1_HttpAcessSG
	- US_West_2_HttpAcessSG
Subnets:
- purposeSubnet#:
	- publicSubnet01
	- publicSubnet02
Load Balancer:
- purpose-region: 
	- ALB-east
	- ALB-west
```

### 2. Use Terraform to create 2 instances in your default VPC for a Jenkins manager and agent architecture with the following installed:  Terraform file [HERE](https://github.com/andmulLABS01/Deployment_6AM/blob/main/main_jenkins.tf)

Instance 1: 
- Jenkins, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev, python3.7-dev
  - Link to the user data script [HERE](https://github.com/andmulLABS01/Deployment_6AM/blob/main/deploy.sh)
- Create the Jenkins Agent
- Configure AWS credentials in Jenkins.
- Place your Terraform files and user data script in the initTerraform directory.

Instance 2: 
- Terraform and default-jre
  - Link to the user data script [HERE](https://github.com/andmulLABS01/Deployment_6AM/blob/main/deploy1.sh)


#### 2a. Clone the Kura repository to our Jenkins instance and push it to the new repository
	- Create a new repository on GitHub
	- Clone the Kura Deployment 6 repository to the local instance
		- Clone using `git clone` command and the URL of the repository
			- This will copy the files to the local instance 
		- Enter the following to gain access to GitHub repository
			- `git config --global user.name username`
			- `git config --global user.email email@address`
		- Next, you will push the files from the local instance to the new repository (Done from the local instance via the command line)
			- `git push`
			- enter GitHub username
			- enter personal token (GitHub requires this as it is more secure)
			
#### 2b. Create the Jenkins agent on the second instance. Follow the steps in this link to create a Jenkins agent: [link](https://scribehow.com/shared/Step-by-step_Guide_Creating_an_Agent_in_Jenkins__xeyUT01pSAiWXC3qN42q5w)
- This is the step where we will configure and later utilize a Jenkins Agent to deploy the application infrastructure and the Banking application.

#### 2c. Configure your AWS credentials in Jenkins. Follow the steps in this link to configure AWS credentials in Jenkins: [link](https://scribehow.com/shared/How_to_Securely_Configure_AWS_Access_Keys_in_Jenkins__MNeQvA0RSOWj4Ig3pdzIPw)  
- This is the step where we will configure our AWS secret keys in Jenkins to later be utilized by our Jenkins Agent to deploy the Banking application.
					

#### 2d. Place your Terraform files and user data script in the initTerraform directory.
- This is the location where your main.tf, variables.tf, and user data script need to be in order for the jenkinsfile to access them to test the application and deploy the application infrastructure.  To work you must ensure your variables match in the jenkisfile, main.tf, and variables.tf files.
	- The link to main.tf file [HERE](https://github.com/andmulLABS01/Deployment_6AM/blob/main/initTerraform/main.tf)	
	- The link to variables.tf file [HERE](https://github.com/andmulLABS01/Deployment_6AM/blob/main/initTerraform/variables.tf)		
	- The link to deploy2.sh file [HERE](https://github.com/andmulLABS01/Deployment_6AM/blob/main/initTerraform/deploy2.sh)		
		
### 3. Create two VPCs with Terraform, using the Jenkins agent, 1 VPC in US-east-1 and the other VPC in US-west-2 and the following components MUST be in each VPC - 2 AZ's, 2 Public Subnets, 2 EC2's, 1 Route Table, Security Group Ports: 8000, 22
   - This process is to give us practice in using Terraform to create our AWS infrastructure.  
   - Also we will utilize Git to continue gaining experience in the day-to-day operations of a DevOps engineer.
   - We will use Jenkins Agents to deploy our AWS application infrastructure and the Banking Flask application with the jenkinsfile onto the application instances. 

#### 3a. Create an RDS database
- We are creating an RDS database to link our application databases together and create our 2nd tier.
	- Instructions to create the RDS database are [here](https://scribehow.com/shared/How_to_Create_an_AWS_RDS_Database__zqPZ-jdRTHqiOGdhjMI8Zw).
   
#### 3b. Branch, update, and merge the following MySQL endpoints changes to the endpoints for the database.py, load_data.py, and app.py in your repository.   	![image](https://github.com/kura-labs-org/c4_deployment-6/blob/main/format.png)

	- Create a new branch in your repository
		- `git branch newbranchName`
	- Switch to the new branch and edit the database.py, load_data.py, and app.py files.
		- `git switch newbranchName`
		- The red, blue, and green areas of the DATABASE_URL you'll need to edit:
	- After modifying the files commit the changes
		- `git add "filename"`
		- `git commit -m "message"`
	- Merge the changes into the main branch
		- `git switch main`
		- `git merge second main`
	- Push the updates to your repository
		- `git push`
		
### 6. Create a Jenkins multibranch pipeline and run the Jenkinsfile
- Jenkins is the main tool used in this deployment for pulling the program from the GitHub repository, and then building and testing the files to be deployed to instances.
- Creating a multibranch pipeline gives the ability to implement different Jenkinsfiles for different branches of the same project.
- A Jenkinsfile is used by Jenkins to list out the steps to be taken in the deployment pipeline.
- A Jenkins agent is a machine or container that connects to a Jenkins controller and executes tasks when directed by the controller. 
- Agents utilize labels to know what commands to execute in the jenkinsfile. 

- Steps in the Jenkinsfile are as follows:
  - Build
    - The environment is built to see if the application can run.
  - Test
    - Unit test is performed to test specific functions in the application.
  - Init
	- Uses the Jenkins Agent to run the Init command to activate the Terraform process.
  - Plan
    - Uses the Jenkins Agent to run the Plan command in Terraform to map out the main.tf requirements. 	
  - Apply
    - Uses the Jenkins Agent to run the Apply command in Terraform to deploy the AWS application infrastructure. 


### 7. Check your infrastructures and applications
- Here are the screenshots of the applications. 
  - [East](https://github.com/andmulLABS01/Deployment_6AM/blob/main/DP6_app-east.PNG)
  - [West](https://github.com/andmulLABS01/Deployment_6AM/blob/main/DP6_app-west.PNG)

- Here are the screenshots of the infrastructures. 
  - [East](https://github.com/andmulLABS01/Deployment_6AM/blob/main/DP6_infra-east.PNG)
  - [West](https://github.com/andmulLABS01/Deployment_6AM/blob/main/DP6_infra-west.PNG)
	
### 8. Create an application load balancer for US-east-1 and US-west-2. 
- Application load balancers ensure that application traffic is distributed between our two instances so that one is not overly utilized and more available to users.
	-[Instructions here](https://scribehow.com/shared/Creating_Load_Balancer_with_Target_Groups_for_EC2_Instances__WjPUNqE4SLCpkcYRouPjjA)	

### 9. With both infrastructures deployed, is there anything else we should add to our infrastructure?

- I believe that we could add the following to our infrastructure:
	- Reverse web proxy such as nginx.  
		- This will allow us to not have internet traffic directly access our application servers. 
		- Have an additional layer of protection from our database.
	- Private subnets
		- This will allow for us to place our application servers in a subnet that does not have direct access to the internet and allows for additional network segmentation and increased security.
	- NAT Gateway
		- Will allow our applications to reply back to users as they will be in a private subnet that does not have access to the internet.
	- API Gateway
		- To increase the security of who/what can access our application
	- Network Load Balancer
		- To balance the network traffic received from the API Gateway to our application servers. load balancer to balance traffic between the two application servers to make the application more available to users.


## System Diagram:

To view the diagram of the system design/deployment pipeline, click [HERE](https://github.com/andmulLABS01/Deployment_6AM/blob/main/Deployment_6.drawio.png)

## Issues/Troubleshooting:

AMI and Key Pair not working in Terraform when creating West-2 infrastructure.

Resolution Steps:
- AMI needed to be from the US West region, was using the AMI for the US East region in my Terraform file.
- Needed to create a key pair for the US West region and use that in my Terraform file.


Testing deployment of the application using the user data script not working.

Resolution Steps:
- Going through the user data script needed to add `source test/bin/activate` as the last line of the script to create and reestablish the environment. If not, once the script is done running it will go back to the home shell.


Test phase not passing in the Jenkins build, Error unknown database.

Resolution Steps:
- Going through the documentation the error is associated with the wrong database name in the DATABASE_URL.  Looked at the name portion of the URL and found the configuration error `mydatabase` instead of `banking`.
- Changed the name and the Jenkins build completed.


The application load balancer test did not work.

Resolution Steps:
- Reviewed the documentation and found that I configured the new security group in the wrong VPC.
- Made the changes to the ALB, selected the correct VPC, added the security group, and the test was completed successfully.


## Conclusion:

As stated in previous documentation this deployment was improved by automating the setup of infrastructure by using Terraform.  However, additional improvements can be made by changing how we utilize the Jenkins Agents.  For example, we could have created two agents and modified the Jenkinsfile to utilize one for testing and one for deployment of the application.  Also, we could have also utilized multiple branches to deploy our infrastructure instead of relying on one branch to do all the lifting. For example, we could have split our application infrastructure into two main.tf files and put one on each branch.  This would allow for greater flexibility when it comes to making changes and using the main.tf file.
