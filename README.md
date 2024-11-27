# build-containers
A basic setup for building projects inside containers

## Usage
```bash
# Clone the repo
git clone https://github.com/mattslaney/build-containers.git
cd build-containers

# Build the container image
./bc . --build

# Build a project
./bc hello --build

# See the build artifacts
./bc hello --ls

# Find executables under the project/dist folder
./bc hello --exe

# Clean all build artifacts (untracked files under project folder)
./bc --clean

# See more usage options
./bc --help
```

### Containerfile's
The main containerfile is used for building projects, unless a project contains it's own Containerfile then this will be used as the build container
