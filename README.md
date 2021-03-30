# How to build

`docker build -t ctf:ubuntu20.04 .`

# How to run

- Windows (command prompt)  
  `docker run --rm -v %cd%:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04`
- Windows (Powershell)  
  `docker run --rm -v ${PWD}:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04`
- Linux  
  `docker run --rm -v $PWD:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04`

`docker exec -it ctf /bin/bash`

# Additional Notes

- https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde
- set-variable -name DISPLAY -value 192.168.1.2:0.0
- `docker run --rm -v ${PWD}:/pwd -e DISPLAY=${DISPLAY} --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04`
