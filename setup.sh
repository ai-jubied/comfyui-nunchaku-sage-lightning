#!/bin/bash
# Lightning AI Studio Setup Script for ComfyUI (Nunchaku + SageAttention)
# Hardware: L4, L40S, A100

echo "🚀 Starting Lightning AI ComfyUI Setup Environment..."

# Update pip
echo "📦 Updating pip..."
pip install --upgrade pip

# Install PyTorch for CUDA 12.4 (Optimal for Ampere/Ada architectures like A100/L40S)
echo "🔥 Installing PyTorch 2.5.1 with CUDA 12.4..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Clone ComfyUI base
if [ ! -d "ComfyUI" ]; then
    echo "📥 Cloning ComfyUI v0.14.2..."
    git clone --branch v0.14.2 --depth 1 https://github.com/comfyanonymous/ComfyUI.git
else
    echo "✅ ComfyUI directory already exists."
fi

# Install ComfyUI requirements
echo "📦 Installing ComfyUI core requirements..."
cd ComfyUI
pip install -r requirements.txt

# --- CUSTOM NODES ---
echo "🧩 Installing Custom Nodes..."
cd custom_nodes

# ComfyUI-Manager
if [ ! -d "ComfyUI-Manager" ]; then
    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git
fi

# ComfyUI-Crystools
if [ ! -d "ComfyUI-Crystools" ]; then
    git clone https://github.com/crystian/ComfyUI-Crystools.git
fi

# ComfyUI_HuggingFace_Downloader
if [ ! -d "ComfyUI_HuggingFace_Downloader" ]; then
    git clone https://github.com/jnxmx/ComfyUI_HuggingFace_Downloader.git
fi

# Civicomfy
if [ ! -d "Civicomfy" ]; then
    git clone https://github.com/MoonGoblinDev/Civicomfy.git
fi

# ComfyUI-Nunchaku
if [ ! -d "ComfyUI-nunchaku" ]; then
    git clone --depth 1 https://github.com/nunchaku-ai/ComfyUI-nunchaku.git
fi

# Install custom node requirements
for d in */; do
    if [ -f "$d/requirements.txt" ]; then
        echo "Installing requirements for $d..."
        pip install -r "$d/requirements.txt"
    fi
done

cd .. # Back to ComfyUI base

# --- NUNCHAKU SYSTEM ENGINE ---
echo "⚙️  Checking Nunchaku Inference Engine installation..."
if ! python -c "import nunchaku" 2>/dev/null; then
    TORCH_VER=$(python -c "import torch; v=torch.__version__.split('+')[0].split('.')[:2]; print('.'.join(v))" 2>/dev/null || echo "")
    PY_VER=$(python -c "import sys; print(f'cp{sys.version_info.major}{sys.version_info.minor}')" 2>/dev/null || echo "cp312")

    if [[ -n "$TORCH_VER" ]]; then
        NUNCHAKU_VERSION="${NUNCHAKU_VERSION:-1.2.1}"
        WHEEL_URL="https://github.com/nunchaku-ai/nunchaku/releases/download/v${NUNCHAKU_VERSION}/nunchaku-${NUNCHAKU_VERSION}+torch${TORCH_VER}-${PY_VER}-${PY_VER}-linux_x86_64.whl"

        echo "Attempting: pip install $WHEEL_URL"
        if pip install "$WHEEL_URL"; then
            echo "✅ Nunchaku engine v${NUNCHAKU_VERSION} installed successfully."
        else
            echo "⚠️  Failed to install Nunchaku globally. It can still be installed via ComfyUI Manager."
        fi
    else
        echo "⚠️  Could not detect PyTorch. Skipping Nunchaku."
    fi
fi

# --- SAGEATTENTION ---
echo "🧠 Installing SageAttention 2.2.0 natively..."
pip install sageattention==2.2.0

# --- AI TOOLKIT ---
echo "🛠️ Installing AI Toolkit limitlessly..."
AITK_DIR="../ai-toolkit"
AITK_REPO_URL="https://github.com/ostris/ai-toolkit.git"

if [ ! -d "$AITK_DIR" ]; then
    echo "📥 Cloning AI Toolkit..."
    git clone --depth 1 "$AITK_REPO_URL" "$AITK_DIR"
fi

echo "📦 Installing AI Toolkit Python requirements..."
# Strip out torch since we natively installed right Torch version above
grep -Ev '^(torch|torchvision|torchaudio)($|[<>=])' "$AITK_DIR/requirements.txt" > "$AITK_DIR/requirements.no-torch.txt"
pip install -r "$AITK_DIR/requirements.no-torch.txt"

echo "🌐 Bootstrapping AI Toolkit UI..."
if command -v npm &> /dev/null; then
    cd "$AITK_DIR/ui"
    npm install --include=dev
    npm run update_db
    npm run build
    cd ../../ComfyUI
else
    echo "⚠️ NPM not found. UI component for AI toolkit will not build."
fi

echo "✅ Setup Complete. Run 'bash start_comfy.sh' to launch."
cd ..
