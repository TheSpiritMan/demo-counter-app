pipeline {
	agent any
	tools {
		maven 'MAVEN_HOME'
	}
	environment {
		// DPR = Docker Private Repo
		DPR_CRED = credentials('nexus-creds')
	}
	stages {
		// stage 1
		stage('Unit Testing') {
			steps{
				sh 'mvn test'
			}
		}
		// stage 2
		stage('Integration Testing'){
			steps{
				sh 'mvn verify -DskipUnitTests'
			}
		}
		// stage 3
		stage('Maven Building'){
			steps{
				sh 'mvn clean install'
			}
		}
		// stage 4
		stage('SonarQube Analysis'){
			steps{
				withSonarQubeEnv(credentialsId: 'sonarqube-key', installationName: 'sonarqube-server') {
					sh 'mvn clean package sonar:sonar'
				}
			}
		}
		// stage 5
		stage('Quality Gate Status'){
			steps{
				waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube-key'
			}
		}
		// stage 6
		stage('Upload jar file to Nexus'){
			steps{
				script{
					def readPom =  readMavenPom file: 'pom.xml'
					def nexusRepo = readPom.version.endsWith("SNAPSHOT") ? "demo-counter-app-snapshot" : "demo-counter-app-release"
					nexusArtifactUploader artifacts: 
					[
						[
							artifactId: 'springboot', 
							classifier: '', 
							file: 'target/counterApp.jar', 
							type: 'jar' 
						]
					],
					credentialsId: 'nexus-creds', 
					groupId: 'com.example', 
					nexusUrl: '192.168.18.8:8081', 
					nexusVersion: 'nexus3', 
					protocol: 'http', 
					repository: nexusRepo, 
					version: "${readPom.version}"
				}
			}
		}
		// stage 7
		stage('Docker Image Build'){
			steps{
					sh 'docker build -t $JOB_NAME:v1.$BUILD_ID .'
			}
		}
		// stage 8
		stage('Tag Image with Nexus Repository'){
			steps{
				script{
					sh 'docker image tag $JOB_NAME:v1.$BUILD_ID  192.168.18.8:8082/$JOB_NAME:v1.$BUILD_ID'
					sh 'docker image tag $JOB_NAME:v1.$BUILD_ID  192.168.18.8:8082/$JOB_NAME:latest'
				}
			}
		}
		// stage 9
		stage('Push Docker Image To Private Nexus Repository'){
			steps{
				script{
					sh 'docker login -u ${DPR_CRED_USR} -p ${DPR_CRED_PSW} 192.168.18.8:8082'
					sh 'docker image push 192.168.18.8:8082/$JOB_NAME:v1.$BUILD_ID'
					sh 'docker image push 192.168.18.8:8082/$JOB_NAME:latest'
				}
			}
		}
		// stage 10
		stage('Remove Old Docker Image'){
			steps{
				script{
					sh "docker rmi $(docker images | grep demo-counter-app | awk '{print $3}') --force"
			}
		}
		// stage 11
		stage('Deploy Project Container'){
			steps{
				script{
					sh 'docker run -d -p 8888:8888 --name counterApp 192.168.18.8:8082/demo-counter-app:latest'
				}
			}
		}
	} 
}