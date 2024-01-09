DIRECTORY = $(CONDA_ARCHIVES)/packages

build:
	docker build --build-arg TAG=$(UBUNTU_IMAGE_TAG) --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) --build-arg UNAME=$(USER) --build-arg GNAME=$(shell id -gn) -t rmn_libs_ubuntu_$(UBUNTU_IMAGE_TAG) -f Dockerfile .

build-nc:
	docker build --no-cache --build-arg TAG=$(UBUNTU_IMAGE_TAG) --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) --build-arg UNAME=$(USER) --build-arg GNAME=$(shell id -gn) -t rmn_libs_ubuntu_$(UBUNTU_IMAGE_TAG) -f Dockerfile .

transfer: build
	if [ -d "$(DIRECTORY)" ]; then \
		rm -rf $(DIRECTORY); \
	fi; \
	mkdir -p $(DIRECTORY)
	docker run -it -v $(DIRECTORY):/home/$(USER)/data rmn_libs_ubuntu_$(UBUNTU_IMAGE_TAG) /bin/bash -c "/home/$(USER)/transfer.sh"
	echo "copied archives to $(DIRECTORY)"

run: build
	docker run -it rmn_libs_ubuntu_$(UBUNTU_IMAGE_TAG) bash 

clean:
	docker image rm -f rmn_libs_ubuntu_$(UBUNTU_IMAGE_TAG)
