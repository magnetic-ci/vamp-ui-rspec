# Vamp UI Tests

This test suite is based on Selenium WebDriver for Ruby, RSpec and Chrome Driver working on top of the Xvfb.

## Requirements
* Docker

## Configuration

```bash
# set vamp ui url - required
export VAMP_URL="http://127.0.0.1:8080/service/vamp/"

# create screenshot on each step - optional
export DO_SCREENSHOTS=true
```

## Usage examples

This example shows how to build included Docker image and run `rspec` in a container.

```bash
export VAMP_URL="http://127.0.0.1:8080/service/vamp/"
make
```

This example shows how to save screen shots during the test.

```bash
export VAMP_URL="http://127.0.0.1:8080/service/vamp/"
export DO_SCREENSHOTS=true
make
```

This example shows how to use Chrome in non-headless mode.

> Please note that this is only possible to run on the host OS, not inside a container and it requires `bundler` and `chromedriver` to be installed.

```bash
export VAMP_URL="http://127.0.0.1:8080/service/vamp/"
bundler install
rspec --format doc
```

This example shows how to remove existing screen shots.

```bash
make clean
```

This example shows how to remove existing screen shots and the Docker image.

```bash
make dist-clean
```
