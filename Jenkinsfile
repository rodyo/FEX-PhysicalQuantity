#!/usr/bin/env groovy

pipeline
{
    agent none

    options {
        timeout(time: 2, unit: 'HOURS')
        parallelsAlwaysFailFast()
    }

    parameters {
        booleanParam(name: 'DO_TESTS',
                     defaultValue: true,
                     description: 'Check if you want to run all the tests')
        booleanParam(name: 'DEPLOY_TOOLBOX',
                     defaultValue: true,
                     description: 'Check if you want to deploy the toobox')
    }

    stages
    {
        stage('Physical Quantity Toolbox - Test')
        {
            parallel
            {
                stage('Windows R2019b') 
				{                    
					agent {label 'MATLAB-windows'}

                    stages
					{
                        stage('Static Analysis') {                            
                            steps {
                                echo "(TODO - perform static checks)"
                            }
                        }
                        
                        stage('Test')
                        {
                            when {
                                expression { params.DO_TESTS == true}
                            }

                            steps
                            {							    
                                bat 'matlab_R2019b \
                                    -softwareopengl \
                                    -sd "test/" \
                                    -batch "jenkins"'

                                step([$class: "TapPublisher",
                                      testResults: "test/artifacts/tap_report.tap"])
                            }

                            post
                            {
                                always 
								{
                                    publishHTML(target: [
                                        allowMissing: false,
                                        alwaysLinkToLastBuild: false,
                                        keepAll: true,
                                        reportDir: 'test/artifacts/test_report/',
                                        reportFiles: 'index.html',
                                        reportName: 'HTML Test Report',
                                        reportTitles: ''])

                                    publishCoverage \
                                        adapters: [coberturaAdapter('test/artifacts/cobertura_coverage_report.xml')],
                                        sourceFileResolver: sourceFiles('NEVER_STORE')
                                }
                                success {
                                    echo "All tests passed!"
                                }
                                failure {                                    
                                    
                                    error "At least one test failed; terminating build..."
                                }
                            }
                        }                        

                    }
					
                }
				
                stage('Windows R2016a') {
                    // Placeholder
                    steps {
                        echo "(will be done once we install R2016a on Windows)"
                    }
                }

                stage('Linux R2019b')
                {
					// Placeholder
                    steps {
                        echo "(will be done once we get a Linux R2019b executor)"
                    }
                }

                stage('Linux R2016a')
                {
					// Placeholder
                    steps {
                        echo "(will be done once we get a Linux R2016a executor)"
                    }                    
                }

            }
        }

		
        stage('Physical Quantity Toolbox - Deploy')
        {
			// Placeholder
			steps {
				echo "(will be done once we get a Linux executor)"
            }
				
			/*
            agent {label 'MATLAB-linux'}

            stages {
                
                stage('Deploy') {
                    when {
                        expression { params.DEPLOY_TOOLBOX == true}
                    }
                    steps {
                        echo "nothing yet!"
                    }
                }
            }
			*/
        }		
    }
}
