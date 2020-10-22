
## CI with Jenkins and Docker-in-Docker.
### 1) Using Docker with Pipeline. If you use Jenkins in docker and want to use Docker with Pipeline you just bind mount to the host system daemon, using this argument when you run Docker
-v /var/run/docker.sock:/var/run/docker.sock
That means, you will have a Docker CLI in the container. Or in a such way
```
docker run -d -p 8080:8080 -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --restart unless-stopped \
    4oh4/jenkins-docker
```

