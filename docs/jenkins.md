## Jenkins

### Setup

There are many ways to install Jenkins. But for this tutorial purpose, I will install one Jenkins instance locally using Jenkins's war file.

### Download

Download Jenkins's war file using [this link](https://updates.jenkins-ci.org/download/war/1.638/jenkins.war)

It will download war file for v1.638. Copy this war file into `jenkins` folder present at root of this project.

```bash
cp PATH_TO_DOWNLOADED_WAR_FILE ./jenkins/
```

### Start jenkins locally

```sh
cd jenkins

JENKINS_HOME=./ java -jar ./jenkins.war
```

This will start jenkins at `http://localhost:8080` and make `JENKINS_HOME=$PROJECT_DIR/jenkins/`. So you will be able to see jenkins related files in JENKINS_HOME directory.

### Install plugins
Install following jenkins plugins required for this tutorial
- Github Plugin
- Parameterized Trigger plugin
- Build Pipeline Plugin

### Importing job from config files
I have already created necessary jenkins job for this tutorial and put their config.xml inside [./jobs](./jobs) directory. By importing these files into Jenkins you can easily create these jobs without any manual work.

Instructions to import jobs are written below,

- Download `jenkins-cli.jar` from `http://localhost:8080/jnlpJars/jenkins-cli.jar`

  - *Note: Your Jenkins should be on*

- Copy `jenkins-cli.jar` into `jenkins` directory

```sh  
cp PATH_TO_JENKINS_CLI_JAR_FILE ./jenkins/
```

- Import jenkins jobs

```sh
java -jar ./jenkins/jenkins-cli.jar -s http://localhost:8080 create-job "Mocha Test Docker Image Builder" < jobs/mocha-test-docker-image-builder.xml

java -jar ./jenkins/jenkins-cli.jar -s http://localhost:8080 create-job "Mocha Test Runner" < jobs/mocha-test-runner.xml
```

This will create two jobs
- Mocha test docker image builder
- Mocha test runner

#### Mocha test docker image builder
This job do following things:
- Clone https://github.com/testingry/Project code into Jenkins workspace
- Checkout master branch
- Fetch latest code from master branch
- Build docker image of latest mocha test code
- Upload to local docker registry `localhost:5000`
- Delete docker image from current environment

#### Mocha test runner
This job to following things:
- Pull latest image of mocha test form local registry `localhost:5000`
- Run tests
- Pull test results from docker container
- Remove docker container after test finishes
- Delete docker image from current environment

### Run jobs
Just trigger Mocha test docker image builder job manually from Jenkins UI. This will start docker image building process. Once job is finished it will automatically trigger Mocha test runner job because of Jenkins's Parameterized Trigger plugin. Once job is finished, you can see test results archived in test runner job.

### Bonus, creating pipeline view
As you can see above, we have already installed Jenkins pipeline plugin. You can easily create pipeline view from Jenkins UI itself by selecting initial job as "Mocha Test Docker Image Builder" Pipeline view will look something like this.

![mocha-test-pipeline-view](../images/pipeline-view.png)
