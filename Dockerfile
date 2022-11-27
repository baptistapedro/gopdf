FROM ubuntu:20.04 as builder

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && apt-get install -y build-essential tzdata pkg-config \
	wget clang git

RUN wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

ADD . /gopdf
WORKDIR /gopdf

ADD fuzzers/fuzz_pdfttf.go ./fuzzers/
WORKDIR ./fuzzers/
RUN go mod init myfuzz
RUN go get github.com/signintech/gopdf
RUN go build

FROM ubuntu:20.04
COPY --from=builder /gopdf/fuzzers/myfuzz /
COPY --from=builder /gopdf/test/res/*.ttf /testsuite/

ENTRYPOINT []
CMD ["/myfuzz", "@@"]
