# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY src/requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy over the requirements for the osdk module
# Accept build arguments for the foundry token and host
ARG FOUNDRY_TOKEN
ARG FOUNDRY_HOST
RUN pip install chipotle_burrito_hunter_sdk==0.1.0 --upgrade \
--index-url "https://user:$FOUNDRY_TOKEN@${FOUNDRY_HOST}/artifacts/api/repositories/ri.artifacts.main.repository.ed533b2e-1398-4f50-bd68-39ce902fe8b8/contents/release/pypi/simple" \
--extra-index-url "https://user:$FOUNDRY_TOKEN@${FOUNDRY_HOST}/artifacts/api/repositories/ri.foundry-sdk-asset-bundle.main.artifacts.repository/contents/release/pypi/simple"


# # Copy the startup script into the container
COPY src/templates /app/templates
COPY src/app.py /app
COPY src/static /app

# Define environment variable
ENV FOUNDRY_TOKEN=""

# Run the start script
CMD ["python3", "app.py"]
