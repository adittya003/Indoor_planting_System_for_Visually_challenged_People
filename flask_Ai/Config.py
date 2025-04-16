import os

class Config(object):
    DEBUG=True
    SECRET_KEY="123456"


MODEL_CONFIGS = {
    "leaf_disease": {
        "model_id": "leaf_disease-fftnv",
        "version": "1",
        "api_key": "GHAFZ2qW4pu1gR6dDLbN"
    },
    "fruit_detection": {
        "model_id": "tomato-ezrnn-3btss",
        "version": "1",
        "api_key": "t4DiHJzpmpEnGCNNSHwd"
    }
}
PROCESSED_FOLDER = "processed"
os.makedirs(PROCESSED_FOLDER, exist_ok=True)