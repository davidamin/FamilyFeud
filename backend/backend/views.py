from django.shortcuts import render, render_to_response, get_object_or_404
from django.template import Context, RequestContext, loader
from django.template.loader import get_template
from django.http import HttpResponse
from django.http import JsonResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.admin.models import LogEntry, ADDITION, CHANGE

from django.core import serializers

from energyapi import models
from django.utils import dateparse

from datetime import datetime

import json
import logging

kenny_loggins = logging.getLogger('transactions')
kenny_loggins.setLevel(logging.INFO)
#kenny_loggins.addHandler(logging.FileHandler())

def model_to_json(model):
	data = serializers.serialize('json',[model,])
	struct = json.loads(data)
	data = json.dumps(struct[0])
	return data

def index(request):
	return HttpResponse("HAI")
	
def log_test(request):
	kenny_loggins.info("This is a log test")
	return HttpResponse("All good")
