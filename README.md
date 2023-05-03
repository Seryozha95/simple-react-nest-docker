# Simple docker configuration of Nest and React

## Build images



- Generate Github `CLASSIC_TOKEN`
- Signin to `ghcr.io`


```
export CP_PATH="CLASSIC_TOKEN"
echo $CP_PATH | docker login ghcr.io -u <GH username> --password-stdin
```


### Build and Push Front-End (ReactJS, NextJS)

- Build an image
```
docker build -t ghcr.io/<GH username>/<PATH Front> . -f dockerfiles/front.dockerfile
```
- Push the image to `ghcr.io`
```
docker push ghcr.io/<GH username>/<PATH Front>:latest
```

### Build and Push Back-End (NodeJs, NestJS)

- Build an image
```
docker build -t ghcr.io/<GH username>/<PATH Back> . -f dockerfiles/back.dockerfile
```
- Push the image to `ghcr.io`
```
docker push ghcr.io/<GH username>/<PATH Back>:latest
```

## Run docker compose

console
docker-compose --file docker-compose.yml --env-file=.env up -d --remove-orphans
