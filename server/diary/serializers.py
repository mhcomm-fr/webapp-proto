from diary import models
from rest_framework import serializers


class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Message
        fields = ('id', 'uid', 'content', 'author', 'timestamp')