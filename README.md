# Cairo development with .devcontainers in VS Code Template

If you're new to dev containers in VS Code then have a look at this [tutorial](https://code.visualstudio.com/docs/remote/containers-tutorial) to set up all requirements for this repository.

## How to use this repository

Documentation from GitHub: [Creating a repository from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template).

## Dependencies

__pip3__ and __apt-get__ is executed in the [Dockerfile](./.devcontainer/Dockerfile) and environment variables such as __STARKNET_NETWORK__ and __STARKNET_WALLET__ is defined in the [devcontainer.json](./.devcontainer/devcontainer.json) file.

## Compile

```sh
cairo-compile src/hello.cairo --output comp/hello_compiled.json
```

## Run

```sh
cairo-run \
  --program=comp/hello_compiled.json --print_output \
  --print_info --relocate_prints
```

or include the tracer flag to use the Cairo tracer, available at http://localhost:8100

```sh
cairo-run \
  --program=comp/hello_compiled.json --print_output \
  --print_info --relocate_prints \
  --tracer
```

## Resources

This dev container is inspired/based on these resources:

* [Microsoft's Python vscode-dev-containers](https://github.com/microsoft/vscode-dev-containers/tree/v0.202.3/containers/python-3) - to be able to run Python 3.9
* [Cairo - Setting up the environment](https://www.cairo-lang.org/docs/quickstart.html#setting-up-the-environment) - The dependencies needed for Cairo
* [Setting Up A StarkNet Dev Environment with Python](https://medium.com/starknet-edu/setting-up-a-starknet-dev-environment-with-python-e4c61c1e8da6) - tutorial by @barretodavid
* [Creating a template repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository) - how to create a template repository