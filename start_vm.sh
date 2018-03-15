docker build -t notes .
docker run -p 8888:8888 -v $(pwd):/home/notes --name=notes notes