from rest_framework import viewsets

from diary import models, serializers
from push_notif.models import Topic


class MessageViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing users, only accessible by themselves.
    """
    serializer_class = serializers.MessageSerializer
    queryset = models.Message.objects.all()

    def perform_create(self, serializer):
        super(MessageViewSet, self).perform_create(serializer)
        try:
            topic_id = Topic.objects.get(name='msg').id
            Topic.notify(topic_id)
        except Topic.DoesNotExist:
            pass
