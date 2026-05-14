CXX ?= g++
CXXFLAGS ?= -std=c++14 -O2
CPPFLAGS ?= -I./src -MMD -MP

# 调试编译选项(不优化, 带-g调试信息, 开启警告)
DEBUG_CXXFLAGS = -std=c++14 -g -O0 -Wall -Wextra
DEBUG_CPPFLAGS = -I./src -MMD -MP

TARGET ?= neuralnet

BUILD_DIR ?= build
DEBUG_BUILD_DIR ?= build-debug

SRCS := $(wildcard src/*.cpp)
# 递归查找src/.cpp文件(支持无限子目录)
# SRCS := $(shell find src -name "*.cpp")

OBJS := $(patsubst src/%.cpp, $(BUILD_DIR)/%.o, $(SRCS))
DEBUG_OBJS := $(patsubst src/%.cpp, $(DEBUG_BUILD_DIR)/%.o, $(SRCS))

DEPS := $(OBJS:.o=.d) $(DEBUG_OBJS:.o=.d)

.PHONY: all debug clean run run-debug

all: $(TARGET)

debug: $(TARGET)-debug

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@

$(TARGET)-debug: $(DEBUG_OBJS)
	$(CXX) $(DEBUG_CXXFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p $(BUILD_DIR)
	@echo "正在编译: $*"
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

$(DEBUG_BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p $(DEBUG_BUILD_DIR)
	@echo "正在编译: $*"
	$(CXX) $(DEBUG_CPPFLAGS) $(DEBUG_CXXFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

run-debug: $(TARGET)-debug
	./$(TARGET)-debug

clean:
	rm -rf $(BUILD_DIR) $(TARGET)
	rm -rf $(DEBUG_BUILD_DIR) $(TARGET)-debug

-include $(DEPS)