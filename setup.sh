# disable the restart dialogue and install several packages
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt-get update
sudo apt install wget git python3 python3-venv build-essential net-tools awscli -y

# install CUDA (from https://developer.nvidia.com/cuda-downloads)
# wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda_12.0.0_525.60.13_linux.run
# sudo sh cuda_12.0.0_525.60.13_linux.run --silent

# install git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
sudo -u ubuntu git lfs install --skip-smudge

# download the SD model SDXL 1.0 and move it to the SD model directory
sudo -u ubuntu git clone --depth 1 https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0
sudo -u ubuntu git clone --depth 1 https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0

# copy over the BASE model safetensor file to the model directory
cd stable-diffusion-xl-base-1.0/
sudo -u ubuntu git lfs pull --include "sd_xl_base_1.0.safetensors"
sudo -u ubuntu git lfs install --force
cd ..
mv stable-diffusion-xl-base-1.0/sd_xl_base_1.0.safetensors stable-diffusion-webui/models/Stable-diffusion/
rm -rf stable-diffusion-xl-base-1.0/

# copy over the REFINER model safetensor file to the model directory
cd stable-diffusion-xl-refiner-1.0
sudo -u ubuntu git lfs pull --include "sd_xl_refiner_1.0.safetensors"
sudo -u ubuntu git lfs install --force
cd ..
mv stable-diffusion-xl-refiner-1.0/sd_xl_refiner_1.0.safetensors stable-diffusion-webui/models/Stable-diffusion/
rm -rf stable-diffusion-xl-refiner-1.0/

# download the corresponding config file and move it also to the model directory (make sure the name matches the model name)
# wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference.yaml
# cp v2-inference.yaml stable-diffusion-webui/models/Stable-diffusion/v2-1_512-ema-pruned.yaml

# change ownership of the web UI so that a regular user can start the server
sudo chown -R ubuntu:ubuntu stable-diffusion-webui/

# start the server as user 'ubuntu'
# sudo -u ubuntu nohup bash stable-diffusion-webui/webui.sh --listen > log.txt
sudo -u ubuntu nohup bash stable-diffusion-webui/webui.sh > log.txt
