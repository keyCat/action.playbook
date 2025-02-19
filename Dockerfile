FROM golang:alpine as builder

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
WORKDIR /build

# Copy and download dependency using go mod
COPY . .

RUN go mod download

# Build the application
RUN go build -o main 

FROM arillso/ansible:2.10.3 as production

# Copy binary from build to main folder
COPY --from=builder /build/main /usr/local/bin

# Run as root
USER root

# Install deps
RUN apk --update --no-cache add \
  bash \
  curl \
  nodejs \
  npm

# Command to run when starting the container
CMD ["main"]
