# Base image với PyTorch + CUDA (nếu dùng GPU)
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

# Set môi trường để không hỏi múi giờ
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

# Copy toàn bộ project vào container
COPY . .
RUN mkdir -p /app/checkpoints
COPY efficientnet_b0_rwightman-3dd342df.pth /app/checkpoints/
# Cài đặt thư viện Python
RUN pip install --upgrade pip
# Mở cổng Flask
COPY efficientnet_b0_rwightman-3dd342df.pth ./models/
EXPOSE 5050
# Lệnh mặc định (có thể thay bằng train/inference)
CMD ["python", "app.py"]
