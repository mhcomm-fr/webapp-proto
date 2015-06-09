from django.views.decorators.csrf import ensure_csrf_cookie
from rest_framework.decorators import list_route
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
    
    @list_route(methods=['GET'])
    def notify(self, request):
        topic_name = request.GET['name']
        topic = models.Topic.objects.get(name=topic_name)
        if topic:
            models.Topic.notify(topic.id)
            return HttpResponse("ok")
        else:
            return HttpResponse("no topic found")




class ClientViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing Client, only accessible by themselves.
    """
    serializer_class = serializers.ClientSerializer
    queryset = models.Client.objects.all()
    
    @list_route(methods=['POST'])
    def register(self, request):
        # to test : '{"uid":123,"topic_name":"test","endpoint_url":"bla"}'
        print(request.data)
        uid = request.data['uid']
        topic = request.data['topic_name']
        endpoint_url = request.data['endpoint_url']
        models.Client.register(uid, topic, endpoint_url)  
        return HttpResponse("ok")
        
    @list_route(methods=['POST'])
    def unregister(self, request):
        # to test : '{"uid":123,"topic_name":"test"}'
        print(pk)
        uid = request.data['uid']
        client = models.Client.objects.filter(uid=uid)[0]
        topic = request.data['topic_name']

        models.Endpoint.objects.filter(client__uid=uid, topic__name=topic).delete()
        
        #client.unregister(topic)  
        return HttpResponse("ok")

class EndpointViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing Endpoints, only accessible by themselves.
    """
    serializer_class = serializers.EndpointSerializer
    queryset = models.Endpoint.objects.all()
    
    
    
    
    
    