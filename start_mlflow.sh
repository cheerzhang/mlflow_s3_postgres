#!/bin/bash

# Attempt MLflow database upgrade
mlflow db upgrade postgresql://postgres:postgres@mlflowdb1.ctrcoixorex7.eu-north-1.rds.amazonaws.com:5432/postgres

# Check the exit code of the previous command
if [ $? -eq 0 ]; then
    # Database upgrade succeeded, start MLflow server
    mlflow server --host 0.0.0.0 --port $MLFLOW_SERVER_PORT --backend-store-uri postgresql://postgres:postgres@mlflowdb1.ctrcoixorex7.eu-north-1.rds.amazonaws.com:5432/postgres --default-artifact-root s3://mlflow-s32/mlflow_arts/
else
    # Database upgrade failed, print an error message
    echo "Failed to upgrade database. Exiting without starting MLflow server."
    mlflow server --host 0.0.0.0 --port $MLFLOW_SERVER_PORT --backend-store-uri postgresql://postgres:postgres@mlflowdb1.ctrcoixorex7.eu-north-1.rds.amazonaws.com:5432/postgres --default-artifact-root s3://mlflow-s32/mlflow_arts/
fi

