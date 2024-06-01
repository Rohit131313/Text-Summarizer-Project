FROM python:3.8-slim-buster

# Update and install necessary packages
RUN apt update -y && apt install -y awscli

# Set the working directory
WORKDIR /app

# Copy the entire context to the container
COPY . /app

# List the contents of the /app directory to ensure requirements.txt is copied
RUN ls -la /app

# Print the contents of requirements.txt to check if it's correct
RUN cat /app/requirements.txt

# Install dependencies with retries
RUN pip install --default-timeout=100 -r requirements.txt || \
    (sleep 5 && pip install --default-timeout=100 -r requirements.txt)

# Upgrade and reinstall specific packages
RUN pip install --upgrade accelerate
RUN pip uninstall -y transformers accelerate
RUN pip install transformers accelerate

# Specify the command to run the application
CMD ["python3", "app.py"]