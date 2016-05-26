## GoCD

### Setup
Install both Go Server and Go Agent using [this](https://docs.go.cd/current/installation/) documentation.

After this you will be able to see Go Server running at `http://localhost:8153`

### Creating Mocha Docker Test Pipeline
After opening `http://localhost:8153`, you will be asked to create a new pipeline. Okay lets create it.

Enter following,

Step 1: Basic Settings
- Pipeline Name: Mocha_Docker_Test_Demo
- Pipeline Group Name: Mocha_Test_Demo

Step 2: Material
- Material Type: Git
- URL: `git@github.com:testingry/Project.git`
- Branch: master
- Poll for new changes: Yes
- Shallow clone: Yes

Press Check Connection button. In case there is any problem, it means your Go Server machine is not able to connect to your github account. Go Server machine's ssh public key should be registered in your github account.

Step 3: Stage/Job
- Stage Name: dockerImageBuilder
- Trigger Type: On Success
- Job Name: dockerImageBuilder
- Task Type: More ...
- Command: `./scripts/gocd/build_docker_image.sh`
- Arguments: Empty
- Working Directory: `./`

This will create a very simple pipleline with one stage(dockerImageBuilder) with one job(dockerImageBuilder). This job will build docker image and upload it to local image repository.

Lets, add build environment variables
- Go to ADMIN > Pipelines > Mocha_Docker_Test_Demo > Environment Variables
- Add `IMAGE_TAG` paramter with default value `latest`

Lets, run it for once to see if it is building image or not.

- Go, Pipelines
- Press run button

Pipeline run must be successful

#### Adding mocha test runner stage

Now, lets create a stage which will pull latest mocha test docker image, run test and artifact test results.

- Go to ADMIN -> Pipelines -> Mocha_Docker_Test_Demo -> Stages
- Click Add new Stage
- Stage Settings:
  - Stage Name: mocha_test_runner
  - Trigger Type: On Success
  - Job Name: mochaTestRunner
  - Task Type: More ...
  - Command: `./scripts/gocd/mocha_test_runner.sh`
  - Arguments: Empty
  - Working Directory: `./`
- Test Artifact Settings:
  - ADMIN -> Pipelines -> Mocha_Docker_Test_Demo -> mochaTestRunner -> mochaTestRunner(Job Settings) -> Artifacts
  - Source: `test-results.xml`
  - Destination: Empty
  - Type: Test Artifact

Lets, run the whole pipeline again to check if it is running test or not.

- Go, Pipelines
- Press run button
- mochaTestRunner stage will start after dockerImageBuilder stage is finished.
- You can check test results in Job results in `Tests` tab.


### Screenshots
Mocha Docker Test Demo Pipeline
![mocha docker test demo pipeline](../images/mocha_docker_test_demo_pipeline.png)

Pipeline Run Results
![pipeline run results](../images/pipeline_run_results.png)

Mocha Test Results
![mocha test reults](../images/mocha_test_results.png)
