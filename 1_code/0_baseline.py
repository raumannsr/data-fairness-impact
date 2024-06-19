# coding: utf-8
# Introduction
"""
The baseline model predicts a binary label (melanoma or not) from a skin lesion image.
The model is built on a convolutional base and extended further by adding specific layers.
As an encoder, we used ResNet50 convolutional base. For this base,
containing a series of pooling and convolution layers, we applied fixed pre-trained ImageNet weights.
"""
from stl_model import STLModel
from environment_variables import EnvVars

NAME = '0_baseline'
PROJECT = 'HINTS'

env = EnvVars.getInstance()
model = STLModel()
model.read_train_val_test_data()
model.build_model()
model.fit_model()
model.predict_model()
if env.get_env_var('save_model')=="True":
    model.save_model()
model.report_metrics()