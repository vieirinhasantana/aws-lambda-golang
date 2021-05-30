TEST?=./...
GOFMT_FILES?=$$(find . -name '*.go' | grep -v vendor)

default: test

lint:
	GO111MODULE=off go get -u github.com/golangci/golangci-lint/cmd/golangci-lint
	golangci-lint run --skip-files=mock.go --tests=false --disable=goimports --enable-all ./...

fmt:
	gofmt -w $(GOFMT_FILES)

fmtcheck:
	@sh -c "'$(CURDIR)/scripts/gofmtcheck.sh'"

covercheck:
	@sh -c "'$(CURDIR)/scripts/checkcoverage.sh' 80"
	rm coverage.out

cover:
	@go tool cover 2>/dev/null; if [ $$? -eq 3 ]; then \
		go get -u golang.org/x/tools/cmd/cover; \
	fi
	go test $(TEST) -coverprofile=coverage.out
	go tool cover -html=coverage.out
	rm coverage.out

test: fmtcheck
	@sh -c "go test ./... -timeout=2m -parallel=4"

.PHONY: default test cover fmt fmtcheck lint

hooks:
	curl -sL https://raw.githubusercontent.com/vieirinhasantana/githooks.go/main/pre-commit.sh > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit