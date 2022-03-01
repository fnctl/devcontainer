
.PHONY: all build run clean
all: clean build run
build: .image-id
	@echo && cat .image-id && echo
run: build
	docker run --rm -it --hostname=make-dev \
		-e GITHUB_USER=$(USER) \
		--mount="type=bind,source=$(PWD),target=/devcontainer" -w=/devcontainer \
		$(shell cat .image-id)
clean:
	@rm -f .image-id || true

.image-id:
	docker build --iidfile .image-id .