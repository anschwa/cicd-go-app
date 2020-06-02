FROM golang:1.14 as gobuilder

ARG BUILD_NUMBER

WORKDIR "/opt/app"

COPY . .
RUN make -e BUILD_NUMBER="$BUILD_NUMBER" build

# Distroless includes only the minimum packages needed to run a web
# application, such as: ca-certificates, openssl, and glibc
FROM gcr.io/distroless/base-debian10

COPY --from="gobuilder" "/opt/app/cmd/app" /

EXPOSE 4242
ENTRYPOINT ["./app"]
