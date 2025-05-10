# Base image với PyTorch + CUDA (nếu dùng GPU)
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Ho_Chi_Minh

# Cài đặt thư viện hệ thống
RUN apt-get update && apt-get install -y \
    tzdata \
    gcc \
    apt-utils \
    git \
    wget \
    curl \
    nano \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Tạo thư mục app
WORKDIR /app

COPY Requirements.txt .
RUN pip install --no-cache-dir -r Requirements.txt

# Copy toàn bộ project (trừ file .pth)
COPY . .

# Tạo thư mục và tải mô hình từ Google Drive
RUN mkdir -p /app/models && \
    wget -O /app/models/efficientnet_b0_rwightman-3dd342df.pth \
    "https://drive.google.com/uc?export=download&id=1ZngLd066kQP7orXBJRRWnZW-fat43G9K"

# Cập nhật pip
RUN pip install --upgrade pip

EXPOSE 5050

CMD ["python", "app.py"]
