FROM golang:1.14

ARG BUILD_NUMBER

WORKDIR "/opt/app"

COPY . .

RUN echo "Running tests..."
RUN make -e BUILD_NUMBER="$BUILD_NUMBER" test

RUN echo "Done."
