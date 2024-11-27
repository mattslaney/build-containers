# build-containers
A basic setup for building projects inside containers

## Usage
```bash
# Clone the repo
git clone https://github.com/mattslaney/build-containers.git
cd build-containers

# Build the container image
./bc .

# Build a project
./bc hello

# See the build artifacts
ls hello/dist
```

### Containerfile's
The main containerfile is used for building projects, unless a project contains it's own Containerfile then this will be used as the build container
