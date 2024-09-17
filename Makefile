SRC_DIR = "./sources"
BUILD_DIR = "./build"

build:
	tl check $(SRC_DIR)/*.tl && tl gen $(SRC_DIR)/*.tl && rm -rf $(BUILD_DIR) && mkdir $(BUILD_DIR) && mv $(SRC_DIR)/*.lua $(BUILD_DIR)

test: build
	./externals/moonshine/Moonshine.exe $(BUILD_DIR)/test.lua