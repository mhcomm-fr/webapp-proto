from django.db import models
from django.contrib.auth.models import User

class Message(models.Model):
    """
    A message
    """
    uid = models.CharField(max_length=100)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
    author = models.ForeignKey(User)

