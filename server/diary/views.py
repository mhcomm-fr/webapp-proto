from rest_framework import viewsets

from diary import models, serializers


class MessageViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing users, only accessible by themselves.
    """
    serializer_class = serializers.MessageSerializer
    queryset = models.Message.objects.all()