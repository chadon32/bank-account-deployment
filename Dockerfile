# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8000 (or whichever port your app uses)
EXPOSE 8000

# Set environment variables for PostgreSQL (these will be overwritten in Kubernetes)
ENV POSTGRES_DB=bankaccount_db
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_HOST=db
ENV POSTGRES_PORT=5432

# Run the Python app
CMD ["python", "bankaccounts_manager.py"]
