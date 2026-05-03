BIN       := openserp
OWNER     ?= miku
COMMIT    := $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
DIRTY     := $(shell git diff --quiet 2>/dev/null || echo -dirty)
GOOS      ?= $(shell go env GOOS)
GOARCH    ?= $(shell go env GOARCH)
OUTPUT    := dist/$(BIN)-$(OWNER)-$(COMMIT)$(DIRTY)-$(GOOS)-$(GOARCH)

GO_BUILD_FLAGS := -trimpath -ldflags="-s -w"

.PHONY: build clean test vet release-info

build: $(OUTPUT)

$(OUTPUT):
	mkdir -p dist
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build $(GO_BUILD_FLAGS) -o $@ .
	@echo "built $@"

test:
	go test ./...

vet:
	go vet ./...

clean:
	rm -rf dist

release-info:
	@echo "binary: $(OUTPUT)"
	@echo "commit: $(COMMIT)$(DIRTY)"
	@echo "target: $(GOOS)/$(GOARCH)"
