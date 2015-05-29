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
        client = Client.objects.filter(uid=uid)
        if not client:
            client = Client(uid=uid)
            client.save()
        else:
            client = client[0]
    
        topic = Topic.objects.filter(name=topic_name)
        print('ici')
        if not topic:
            topic = Topic(name=topic_name, last_version=0)
            topic.save()
        else:
            topic = topic[0]
        
        print(client)
        endpoint = Endpoint.objects.filter(client=client, topic=topic)
        if not endpoint:
            endpoint = Endpoint(client=client, topic=topic, endpoint_url=url)
        else:
            endpoint = endpoint[0]
            if endpoint.endpoint_url != url:
                endpoint.endpoint_url = url
        endpoint.save()
        
    def unregister(self, topic_name):
        print('ici')
        topic =  Topic.objects.filter(name=topic_name)
        endpoint = Endpoint.objects.filter(client=self, topic=topic[0])
        print('ici')
        if endpoint:
            endpoint.delete()

class Topic(models.Model):
    """
    An Endpoint
    """
    #endpoints = models.ManyToManyField('Client', through='Endpoint', related_name='topic')

    name = models.CharField(max_length=100)
    last_version = models.PositiveIntegerField()

    def notify(self):
        self.last_version += 1
        self.save()
        for endpoint in self.endpoints.all():
            endpoint.notify(self.last_version)
            

class Endpoint(models.Model):
    """
    """
    client = models.ForeignKey(Client)
    topic = models.ForeignKey(Topic, related_name='endpoints')

    endpoint_url = models.URLField()

    def notify(self, version):
        ret = requests.put(self.endpoint_url, data={'version': version})
        if ret.status_code != 200:
            print('push notification : error notifying url')
            # todo : real error handling

