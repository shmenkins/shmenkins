# Targets here are named and act similar to maven build phases
#
# Use current directory name as project name
project_name := $(shell basename $(shell pwd))
python_interpreter := python3.6


# Main targets

# Initializes the project
init:
	virtualenv venv -p $(python_interpreter) && \
		source venv/bin/activate && \
		pip install -r requirements.txt \
		--force-reinstall \
		--upgrade \
		--find-links ~/.cache/shmenkins

# Removes build artifacts, cleans caches, ...
clean:
	rm -rf build dist .cache .tox

# Runs unit tests (makes no network calls, maximum mocking)
# Need to run pytest as a module and from src so the src is added to the PYTHONPATH
test: clean
	source venv/bin/activate && \
		cd src && \
		python -m pytest ../tests

# Runs integration tests (makes network calls, no mocking)
# Need to run pytest as a module and from src so the src is added to the PYTHONPATH
test-integration: clean
	source venv/bin/activate && \
		cd src && \
		python -m pytest ../tests-integration

