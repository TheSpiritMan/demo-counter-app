# DevOps Project
# Maven Project Jenkins SonarQube Nexus

- In this project, we will be playing with <b>Github</b>, <b>Jenkins</b>,<b>Sonarqube</b> and <b>Nexus</b>.
- We will create Jenkins, Sonarqube and Nexus from Docker Container.
- Since we will require docker inside Jenkins. But the official jenkins image do not include docker inside the image. So we will create our own new Jenkins image.
- The jenkins image used in this project can be pull from dockerhub. [Visit the link](https://hub.docker.com/r/thespiritman/jenkins-with-docker).

## <b>Github: </b>
- In this project, <b>Git</b> is used as <b>VCS(Version Control System)</b>.
- <b>Github</b> is used to store Source Code.

## <b>Jenkins: </b>
- Jenkins is used for <b>CI/CD(Continuous Integration/Continuous Deployment)</b>.
- We will be using <b>Declarative pipeline</b> for this job.

#### <b>Declarative Pipeline: </b>
- This pipeline will contain multiple stages where task will be describe.
- <b>Jenkins</b> automatically fetched the <b>Github</b> Repo, so we do not need to include that in any stage.
- Multiple stages included in this job are:
    - <b>Stage 1:</b>
        - Since this is maven based application, we will run the `mvn test` command.
    
    - <b>Stage 2:</b>
        - Skip the Unit Test.

    - <b>Stage 3:</b> 
        - Clean the prebuild package and `install` create a new package.
    
    - <b>Stage 4:</b>
        - Create a Project in Sonarqube. Remember it requires a Sonarqube Credentials.
    
    - <b>Stage 5:</b>
        - Get quality status report back from Sonarqube.
        - For this, we must create jenkins webhook in sonarqube.

    - <b>Stage 6:</b>
        - Upload the artifact to the <b>Nexus Repository</b>.
        - It reqiures Nexus Credentials to upload the artifact.
    
    - <b>Stage 7:</b>
        - It builds a docker image of the application with the Job_Name and Build_ID. 
        - Remember, <b>Docker</b> must be installed inside Jenkins.
    
    - <b>Stage 8: </b>
        - It tagged the image with registry.


    - <b>Stage 9: </b>
        - It pushes the image to the Nexus Private Registry.
        - It reqires Nexus credentials for that.
   
    - <b>Stage 10: </b>
        - It removes old image to clean the space from the jenkins container.
   
    - <b>Stage 11: </b>
        - Deploy the application from the docker image.

## <b>Sonarqube: </b>
- Sonarqube is used for Code Analysis.

## <b>Nexus: </b>
- Nexus is used for private repository.



# Note:
- If you want to recreate this tutorial, follow the documentation from [Wiki](https://github.com/TheSpiritMan/demo-counter-app/wiki) page.