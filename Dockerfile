# Base image đơn giản, không dùng GPU
FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Ho_Chi_Minh

# Cài đặt thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    gcc \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Đặt thư mục làm việc
WORKDIR /app

# Cài thư viện Python
COPY Requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r Requirements.txt

# Copy toàn bộ project vào container
COPY . .

# Expose cổng Flask
EXPOSE 5050

# Chạy ứng dụng Flask
CMD ["python", "app.py"]
