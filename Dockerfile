# Use an official Python runtime as the base image
FROM python:3.9.6-slim

# Set environment variables
ENV MLFLOW_HOME /mlflow
ENV MLFLOW_SERVER_PORT 5000
ENV MLFLOW_S3_ENDPOINT_URL https://s3-eu-north-1.amazonaws.com
ENV MLFLOW_S3_BUCKET mlflow-s32

# Pass AWS credentials as build arguments
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

# Install MLflow and other dependencies
RUN pip install mlflow==2.9.1
RUN pip install psycopg2-binary==2.9.9
RUN pip install boto3==1.33.9

# Expose the MLflow UI port
EXPOSE $MLFLOW_SERVER_PORT

# Set the working directory
WORKDIR $MLFLOW_HOME

COPY start_mlflow.sh /start_mlflow.sh
RUN chmod +x /start_mlflow.sh

# Start MLflow server when the container is run
CMD ["/start_mlflow.sh"]
# CMD mlflow db upgrade --database-uri postgresql://postgres:postgres@mlflowdb1.ctrcoixorex7.eu-north-1.rds.amazonaws.com:5432/postgres && mlflow server --host 0.0.0.0 --port $MLFLOW_SERVER_PORT --backend-store-uri postgresql://postgres:postgres@mlflowdb1.ctrcoixorex7.eu-north-1.rds.amazonaws.com:5432/postgres --default-artifact-root s3://mlflow-s32/mlflow_arts/