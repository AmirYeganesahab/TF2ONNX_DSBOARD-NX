#!/bin/bash

#========================================================
# Check if nvcc (CUDA compiler) is available
if command -v nvcc &> /dev/null; then
    # If nvcc is found, print CUDA version
    cuda_version=$(nvcc --version | grep "release" | awk '{print $6}')
    echo "CUDA is installed. Version: $cuda_version"
else
    # If nvcc is not found, print an error message and exit
    echo "Error: CUDA is not installed. Please install CUDA before running this script."
    exit 1
fi
sudo apt update

#========================================================
# Check if jtop is installed
if command -v jtop &> /dev/null; then
    echo "jtop is already installed."
else
    # Prompt the user if they want to install jtop
    read -p "jtop is not installed. Do you want to install it? (y/n): " answer
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
        # Install jtop using pip
        sudo apt-get install python3-dev libncurses5-dev
	python3 -m pip install jetson-stats
        echo "jtop has been installed successfully."
    else
        echo "jtop is not installed. Exiting script."
    fi
fi

#========================================================
# Check if lsb_release is available
if command -v lsb_release &> /dev/null; then
    # Get Jetson system information
    jetson_info=$(lsb_release -a 2>/dev/null | grep "Description:")

    # Extract JetPack version from the information
    jetpack_version=$(echo "$jetson_info" | awk '{print $3}')
    
    if [ -n "$jetpack_version" ]; then
        echo "JetPack version: $jetpack_version"
    else
        echo "Unable to determine JetPack version."
    fi
else
    echo "Error: lsb_release not found. Please make sure it is installed."
fi

#========================================================
# Check if Cython is installed
if command -v cython &> /dev/null; then
    echo "Cython is already installed."
else
    # Prompt the user if they want to install Cython
    read -p "Cython is not installed. Do you want to install it? (y/n): " answer
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
        # Install Cython using pip
        python3 -m pip install Cython --user
        echo "Cython has been installed successfully."
    else
        echo "Cython is not installed. Exiting script."
        exit 1
    fi
fi

export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
sudo apt-get install python3-pip
python3 -m pip install nvidia-pyindex
python3 -m pip install nvidia-tensorrt
sudo apt-get install libprotoc-dev protobuf-compiler
sudo apt-get remove protobuf-compiler
sudo apt-get install protobuf-compiler
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
python3 -m pip install onnx --verbose
python3 -m pip install tf2onnx --verbose
