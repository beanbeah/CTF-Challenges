#build docker image
build:
	docker build -t code-runner .
#run docker image with name and file location passed as argument
#i.e make run name=test file=test.c
run:
	cat $(file) | docker run --rm -i --cap-add=DAC_READ_SEARCH --cap-drop=SYS_CHROOT --cap-drop=DAC_OVERRIDE --network none --name $(name) --stop-timeout 5 code-runner