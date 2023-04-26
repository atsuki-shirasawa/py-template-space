SOURCE_FILES=./src
TEST_FILES=./tests

lint:
	poetry run mypy ${SOURCE_FILES} ${TEST_FILES}
	poetry run ruff check ${SOURCE_FILES} ${TEST_FILES}

format:
	poetry run ruff check ${SOURCE_FILES} ${TEST_FILES} --fix-only --exit-zero
	poetry run black ${SOURCE_FILES} ${TEST_FILES}

export_requirements:
	poetry export -f requirements.txt --without-hashes --output requirements.txt

export_requirements_dev:
	poetry export -f requirements.txt --without-hashes --with dev --output requirements_dev.txt