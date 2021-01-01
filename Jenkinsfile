pipeline {
    agent {
        label 'linux'
    }

    triggers {
        pollSCM '@hourly'
        cron '@daily'
    }

    tools {
        maven 'Latest Maven'
    }

    options {
        ansiColor('xterm')
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '15')
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Clean') {
            steps {
                sh 'mvn -B clean'
                sh 'rm -rf protoc'
            }
        }

        stage("Build") {
            when {
                branch "master"
            }

            steps {
                sh "./build.sh"
            }
        }

        stage("Check Dependencies") {
            when {
                branch "master"
            }

            steps {
                dependencyCheck additionalArguments: '''--suppression dependency-check-suppression.xml''', odcInstallation: 'Latest'
                dependencyCheckPublisher failedTotalCritical: 1, failedTotalHigh: 5, failedTotalLow: 8, failedTotalMedium: 8, pattern: '', unstableTotalCritical: 0, unstableTotalHigh: 4, unstableTotalLow: 8, unstableTotalMedium: 8
            }
        }

        stage('Deploy Java Module') {
            when {
                allOf {
                    branch "master"
                    not {
                        triggeredBy "TimerTrigger"
                    }
                }
            }

            steps {
                configFileProvider([configFile(fileId: '96a603cc-e1a4-4d5b-a7e9-ae1aa566cdfc', variable: 'MAVEN_SETTINGS_XML')]) {
                    sh label: 'maven deploy', script: 'mvn -B -s "$MAVEN_SETTINGS_XML" -DskipTests deploy'
                }
            }
        }
    }

    post {
        unsuccessful {
            mail to: "rafi@guengel.ch",
                    subject: "${JOB_NAME} (${BRANCH_NAME};${env.BUILD_DISPLAY_NAME}) -- ${currentBuild.currentResult}",
                    body: "Refer to ${currentBuild.absoluteUrl}"
        }
    }
}