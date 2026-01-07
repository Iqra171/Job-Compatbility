# Use slim Python image to reduce unnecessary packages
FROM python:3.11-slim

WORKDIR /code

# Copy requirements
COPY requirements.txt .

# Install system dependencies needed for sentence-transformers & PyPDF2
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages (force CPU-only PyTorch)
RUN pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download the embedding model to avoid download on first runtime
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-mpnet-base-v2')"

# Copy the rest of your app
COPY . .

# Expose Gradio default port
EXPOSE 7860

# Launch app
CMD ["python", "app.py"]
