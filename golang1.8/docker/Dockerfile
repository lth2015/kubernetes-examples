################################################################
# Image: img.reg.3g:15000/go-librados:1.8
################################################################

FROM img.reg.3g:15000/librados:latest

### Add golang 1.8
RUN mkdir /Golang
ADD go /usr/local/go
ENV GOROOT /usr/local/go
ENV GOPATH /Golang
ENV PATH /usr/local/go/bin:$PATH

ADD Dockerfile /
