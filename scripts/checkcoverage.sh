#!/usr/bin/env bash

THRESHOLD=$1

go test -timeout=2m -covermode=atomic -coverprofile coverage.out ./...
sed -i '/mock.go/d' coverage.out
COVERAGE=$(go tool cover -func=coverage.out | grep total | awk '{print $3}')
COVERAGE=${COVERAGE%\%}

if (( $(echo "${COVERAGE} >= ${THRESHOLD}" | bc -l) ));then
    echo "coverage above threshold"
    echo "coverage: ${COVERAGE} - threshold: ${THRESHOLD}"
    exit 0
fi

echo "coverage below threshold"
echo "coverage: ${COVERAGE} - threshold: ${THRESHOLD}"
exit 1