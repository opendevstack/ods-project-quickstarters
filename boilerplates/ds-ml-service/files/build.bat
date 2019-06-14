REM This .bat script is for local testing on windows machines

setlocal enableDelayedExpansion

git rev-parse HEAD > temp.txt
set /p GIT_REV_PARSE_HEAD=<temp.txt
@echo GIT_COMMIT = "%GIT_REV_PARSE_HEAD%" > src/services/infrastructure/git_info.py

git rev-parse --short HEAD > temp.txt
set /p GIT_REV_PARSE_HEAD_SHORT=<temp.txt
@echo GIT_COMMIT_SHORT = "%GIT_REV_PARSE_HEAD_SHORT%" >> src/services/infrastructure/git_info.py

git rev-parse --abbrev-ref HEAD > temp.txt
set /p GIT_REV_PARSE_BRANCH=<temp.txt
@echo GIT_BRANCH = "%GIT_REV_PARSE_BRANCH%" >> src/services/infrastructure/git_info.py

git rev-parse --show-toplevel > temp.txt
set /p GIT_TOP_LEVEL=<temp.txt
@echo GIT_REPO_NAME = "%GIT_TOP_LEVEL%" >> src/services/infrastructure/git_info.py

@echo GIT_LAST_CHANGE = "Local Test on Windows machine" >> src/services/infrastructure/git_info.py
del temp.txt

del docker-training\dist\ /S /Q
del docker-prediction\dist\ /S /Q


xcopy /s src docker-training\dist\
xcopy /s src docker-prediction\dist\
xcopy /s resources docker-training\dist\
xcopy /s .dvc docker-training\dist\

copy test\run_integration_tests.sh docker-training\dist
copy test\run_unittests.sh docker-training\dist

