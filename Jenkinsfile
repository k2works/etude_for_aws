node {
        stage("Build") {
            checkout scm

            docker.build('app','. -f Dockerfile-dev').inside {
           }
        }

        // Clean up workspace
        step([$class: 'WsCleanup'])
}