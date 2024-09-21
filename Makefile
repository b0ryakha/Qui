SRC_DIR = "./sources"
EXM_DIR = "./examples"
BUILD_DIR = "./build"
.ONESHELL:

build:
	tl check ${SRC_DIR}/*.tl &&
	tl gen ${SRC_DIR}/*.tl &&
	rm -rf ${BUILD_DIR} &&
	mkdir ${BUILD_DIR} &&
	mv ${SRC_DIR}/*.lua ${BUILD_DIR}

build_examples: build
	tl check ${EXM_DIR}/*.tl &&
	tl gen ${EXM_DIR}/*.tl &&
	mkdir ${BUILD_DIR}/${EXM_DIR} &&
	mv ${EXM_DIR}/*.lua ${BUILD_DIR}/${EXM_DIR}

test: build_examples
	./externals/moonshine/Moonshine.exe ${BUILD_DIR}/${EXM_DIR}/main.lua || true