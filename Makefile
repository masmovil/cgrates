# Folder where deployment scripts are placed
DEPLOYMENT ?= ./deployment
BIN_NAME ?= cgr-engine

.PHONY: all
all: clean run

.PHONY: clean
clean:
	rm -rf $(BIN_NAME)

.PHONY: cleanall
cleanall: clean
	rm -rf $(DEPLOYMENT) continuous-deployment-scripts

.PHONY: dependencies
dependencies:
	go mod tidy -v

# Compiles the binary if one of the .go files have been modified after the last build.
$(BIN_NAME): $(shell find . -name "*.go")
	go build -ldflags "-w -s -X 'github.com/cgrates/cgrates/utils.GitLastLog=$(GIT_LAST_LOG)'" -o $(BIN_NAME) github.com/cgrates/cgrates/cmd/cgr-engine

# Builds the binary in the host machine.
.PHONY: build
build: $(BIN_NAME)

.PHONY: migrate
migrate:
	go run main.go migrate up

.PHONY: run
run: build
	./$(BIN_NAME)

.PHONY: unit-test
unit-test:
	go test -v -count=1 ./...

.PHONY: build-docker-image
build-docker-image: | $(DEPLOYMENT)
	$(DEPLOYMENT)/build-image.sh

.PHONY: push-docker-image
push-docker-image: | $(DEPLOYMENT)
	$(DEPLOYMENT)/push-docker-image.sh

.PHONY: deploy
deploy: | $(DEPLOYMENT)
	$(DEPLOYMENT)/deploy-2-k8s.sh

# .PHONY: upload-test-report
# upload-test-report:
# 	$(DEPLOYMENT)/hiptest-publisher.sh

# .PHONY: release-notes
# release-notes:
# 	REPO_NAME=$(REPO_NAME) ./assets/scripts/release-generator.sh