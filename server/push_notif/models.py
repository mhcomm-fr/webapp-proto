from django.db import models
import requests

# Create your models here.



class Client(models.Model):
    """
    A client
    """
    uid = models.CharField(max_length=100)

    topics = models.ManyToManyField('Topic', through='Endpoint', related_name='clients')

    # when create Client  ?
    @classmethod
    def register(cls, uid, topic_name, url):
        print(uid, topic_name, url)
        client, created = Client.objects.get_or_create(uid=uid)

        topic, created = Topic.objects.get_or_create(name=topic_name)

        print(client)
        endpoint, created = Endpoint.objects.get_or_create(client=client, topic=topic)

        endpoint.endpoint_url = url
        endpoint.save()


class Topic(models.Model):
    """
    An Endpoint
    """
    #endpoints = models.ManyToManyField('Client', through='Endpoint', related_name='topic')

    name = models.CharField(max_length=100)
    last_version = models.PositiveIntegerField(default=0)

    @classmethod
    def notify(cls, topic_id):
        topic = Topic.objects.get(id=topic_id)
        topic.last_version += 1
        topic.save()
        for endpoint in topic.endpoints.all():
            endpoint.notify(topic.last_version)


class Endpoint(models.Model):
    """
    """
    client = models.ForeignKey(Client)
    topic = models.ForeignKey(Topic, related_name='endpoints')

    endpoint_url = models.URLField()

    def notify(self, version):
        print('calling url : %r with version %r' % (self.endpoint_url, version))
        ret = requests.put(self.endpoint_url, data={'version': version})
        if ret.status_code != 200:
            print('push notification : error notifying url')
            # todo : real error handling
