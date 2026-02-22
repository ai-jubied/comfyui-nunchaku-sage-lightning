# Premium ComfyUI Nunchaku-Sage Lightning Studio Template

This template is fine-tuned to run **ComfyUI** with hardware-accelerated **SageAttention** and the **Nunchaku Inference Engine** on **Lightning AI Studios**.

## 🚀 Supported Studio Instances
We highly recommend running this template on NVIDIA's Ampere & Ada architectures, which natively accelerate SageAttention out of the box. 

Supported GPUs on Lightning AI:
- **L4 (Ada Lovelace)** - *Recommended for Speed/Cost Balance*
- **L40s (Ada Lovelace)** - *High Performance*
- **A100 (Ampere)** - *Maximum VRAM/Bandwidth*

*(Note: T4 is significantly older (Turing) and does not fully support Nunchaku/Sage optimizations out-of-the-box in the same way).*

---

## 🛠️ Installation Instructions

Unlike Runpod, **Lightning AI Studios** work best without isolated `venv` spaces. We install everything straight into the default Lightning Python environment (which comes with VSCode/Jupyter pre-configured!).

1. Open your Lightning Studio Terminal.
2. Clone this repository (if you haven't already):
```bash
git clone https://github.com/aijubied/comfyui-nunchaku-sage-v1.git
cd comfyui_sageattention_nunchaku_lightning
```
3. Run the setup script:
```bash
bash setup.sh
```

This script will automatically:
- Upgrade `pip`
- Install PyTorch `2.5.1` (CUDA 12.4) tailored for A100/L40S.
- Install **Filebrowser**.
- Clone the ComfyUI core engine.
- Install essential custom nodes (Manager, Crystools, HF Downloader, Civicomfy).
- Attemp to install the **Nunchaku Engine** matching your PyTorch version.
- Install **SageAttention 2.2.0** natively.
- Clone and bootstrap **Ostris' AI Toolkit**.

---

## ▶️ Running Services

Once setup is complete, you can start everything at any time using:
```bash
bash start_comfy.sh
```

### Accessing the Web Interfaces
1. Once the script prints `Started ComfyUI on Port 8188...`
2. Look at the **right-hand sidebar** in your Lightning AI Studio.
3. Click the **"Ports"** or **"App"** plugin.
4. If the port you need isn't listed, type the port number and click the `+` button.
5. Click the pop-out arrow next to the port to open it in a new tab!

**Available Ports:**
- **Port 8188:** ComfyUI
- **Port 8675:** AI Toolkit UI
- **Port 8080:** Filebrowser (Root directory access)

---

## 📦 What's Included
- **Ostris AI Toolkit:** Train Loras directly.
- **Filebrowser:** Easily upload models and manage outputs.
- **Nunchaku Engine:** Dramatically accelerates SVD/SD3 inference via specialized compiling.
- **Sage Attention:** A high-speed attention backend (much faster than `xformers` or `flash_attention_2` on modern GPUs).
- **ComfyUI Manager**
- **Crystools** (Resource/VRAM monitoring)
- **HuggingFace Downloader** (Direct-to-server model downloads)
- **Civicomfy** (Civitai integration)

## ⚠️ Notes
- The initial setup script might take 3-5 minutes depending on your Studio's internet connection, as it pulls a fresh PyTorch 2.5.1 + CUDA 12.4 binary.
- This template assumes you are launching a fresh Python 3.10/3.12 default studio environment.
