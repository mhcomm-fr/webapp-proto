from push_notif import models
from rest_framework import serializers


class ClientSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Client
        fields = ('uid',)
        


class TopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Topic
        fields = ('name', 'last_version')
        
        
class EndpointSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Endpoint
        fields = ('endpoint_url',)