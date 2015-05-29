from django.views.decorators.csrf import ensure_csrf_cookie
from rest_framework.decorators import detail_route
from django.http import HttpResponse

from rest_framework import viewsets
from push_notif import models

from push_notif import serializers

# Create your views here.

class TopicViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing Topic, only accessible by themselves.
    """
    serializer_class = serializers.TopicSerializer
    queryset = models.Topic.objects.all()


class ClientViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing Client, only accessible by themselves.
    """
    serializer_class = serializers.ClientSerializer
    queryset = models.Client.objects.all()
    
    @detail_route(methods=['POST'])
    def register(self, request, pk=None):
        print(request.POST)
        uid = request.POST['uid']
        topic = request.POST['topic_name']
        endpoint_url = request.POST['endpoint_url']
        models.Client.register(uid, topic, endpoint_url)  
        return HttpResponse("ok")
        
    @detail_route(methods=['POST'])
    def unregister(self, request, pk=None):
        print(pk)
        client = models.Client.objects.filter(uid=pk)[0]
        topic = request.POST['topic_name']
        client.unregister(topic)  
        return HttpResponse("ok")

class EndpointViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing Endpoints, only accessible by themselves.
    """
    serializer_class = serializers.EndpointSerializer
    queryset = models.Endpoint.objects.all()
    
    
    
    
    
    